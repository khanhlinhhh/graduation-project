import { useState, useEffect } from 'react';
import { collection, getDocs, query, orderBy, limit, where, Timestamp } from 'firebase/firestore';
import { db } from '../firebase';
import { Users, Gift, CalendarCheck, Coins, TrendingUp, Award } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

export default function Dashboard() {
    const [stats, setStats] = useState({
        totalUsers: 0,
        totalPoints: 0,
        totalCheckIns: 0,
        totalRedemptions: 0,
    });
    const [topUsers, setTopUsers] = useState([]);
    const [checkInData, setCheckInData] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchDashboardData();
    }, []);

    const fetchDashboardData = async () => {
        try {
            // Fetch users
            const usersSnapshot = await getDocs(collection(db, 'users'));
            let totalPoints = 0;
            const usersData = [];
            usersSnapshot.forEach(doc => {
                const data = doc.data();
                totalPoints += data.greenPoints || 0;
                usersData.push({ id: doc.id, ...data });
            });

            // Get top 5 users by points
            const sortedUsers = usersData.sort((a, b) => (b.greenPoints || 0) - (a.greenPoints || 0)).slice(0, 5);
            setTopUsers(sortedUsers);

            // Fetch check-ins count
            const checkInsSnapshot = await getDocs(collection(db, 'checkins'));

            // Fetch redemptions count
            const redemptionsSnapshot = await getDocs(collection(db, 'redemptions'));

            // Prepare check-in chart data (last 7 days)
            const last7Days = [];
            for (let i = 6; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);
                const dayStart = new Date(date.getFullYear(), date.getMonth(), date.getDate());
                const dayEnd = new Date(dayStart);
                dayEnd.setDate(dayEnd.getDate() + 1);

                let count = 0;
                checkInsSnapshot.forEach(doc => {
                    const checkInDate = doc.data().date?.toDate();
                    if (checkInDate && checkInDate >= dayStart && checkInDate < dayEnd) {
                        count++;
                    }
                });

                last7Days.push({
                    name: dayStart.toLocaleDateString('vi-VN', { weekday: 'short' }),
                    checkIns: count,
                });
            }
            setCheckInData(last7Days);

            setStats({
                totalUsers: usersSnapshot.size,
                totalPoints,
                totalCheckIns: checkInsSnapshot.size,
                totalRedemptions: redemptionsSnapshot.size,
            });
        } catch (error) {
            console.error('Error fetching dashboard data:', error);
        } finally {
            setLoading(false);
        }
    };

    const statCards = [
        { label: 'Tổng người dùng', value: stats.totalUsers, icon: Users, color: 'blue', gradient: 'from-blue-500 to-blue-600' },
        { label: 'Tổng điểm xanh', value: stats.totalPoints.toLocaleString(), icon: Coins, color: 'green', gradient: 'from-green-500 to-green-600' },
        { label: 'Lượt Check-in', value: stats.totalCheckIns, icon: CalendarCheck, color: 'purple', gradient: 'from-purple-500 to-purple-600' },
        { label: 'Lượt đổi thưởng', value: stats.totalRedemptions, icon: Gift, color: 'orange', gradient: 'from-orange-500 to-orange-600' },
    ];

    if (loading) {
        return (
            <div className="flex items-center justify-center h-full">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-500"></div>
            </div>
        );
    }

    return (
        <div className="p-8">
            {/* Header */}
            <div className="mb-8">
                <h1 className="text-3xl font-bold text-gray-800">Dashboard</h1>
                <p className="text-gray-500 mt-1">Tổng quan hoạt động ứng dụng Green Recycle</p>
            </div>

            {/* Stats Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                {statCards.map((card, index) => (
                    <div
                        key={index}
                        className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-shadow"
                    >
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-gray-500 text-sm">{card.label}</p>
                                <p className="text-3xl font-bold text-gray-800 mt-2">{card.value}</p>
                            </div>
                            <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${card.gradient} flex items-center justify-center shadow-lg`}>
                                <card.icon className="w-7 h-7 text-white" />
                            </div>
                        </div>
                    </div>
                ))}
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Chart */}
                <div className="lg:col-span-2 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-2 mb-6">
                        <TrendingUp className="w-5 h-5 text-green-600" />
                        <h2 className="text-lg font-semibold text-gray-800">Check-in 7 ngày qua</h2>
                    </div>
                    <ResponsiveContainer width="100%" height={300}>
                        <AreaChart data={checkInData}>
                            <defs>
                                <linearGradient id="colorCheckIns" x1="0" y1="0" x2="0" y2="1">
                                    <stop offset="5%" stopColor="#22c55e" stopOpacity={0.3} />
                                    <stop offset="95%" stopColor="#22c55e" stopOpacity={0} />
                                </linearGradient>
                            </defs>
                            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                            <XAxis dataKey="name" stroke="#9ca3af" fontSize={12} />
                            <YAxis stroke="#9ca3af" fontSize={12} />
                            <Tooltip
                                contentStyle={{
                                    borderRadius: '12px',
                                    border: 'none',
                                    boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)'
                                }}
                            />
                            <Area
                                type="monotone"
                                dataKey="checkIns"
                                stroke="#22c55e"
                                strokeWidth={2}
                                fillOpacity={1}
                                fill="url(#colorCheckIns)"
                            />
                        </AreaChart>
                    </ResponsiveContainer>
                </div>

                {/* Top Users */}
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-2 mb-6">
                        <Award className="w-5 h-5 text-yellow-500" />
                        <h2 className="text-lg font-semibold text-gray-800">Top người dùng</h2>
                    </div>
                    <div className="space-y-4">
                        {topUsers.map((user, index) => (
                            <div key={user.id} className="flex items-center gap-3">
                                <div className={`w-8 h-8 rounded-full flex items-center justify-center text-white text-sm font-bold ${index === 0 ? 'bg-yellow-500' :
                                        index === 1 ? 'bg-gray-400' :
                                            index === 2 ? 'bg-orange-400' : 'bg-gray-300'
                                    }`}>
                                    {index + 1}
                                </div>
                                <div className="flex-1 min-w-0">
                                    <p className="font-medium text-gray-800 truncate">
                                        {user.displayName || 'Người dùng'}
                                    </p>
                                    <p className="text-sm text-gray-500 truncate">{user.email}</p>
                                </div>
                                <div className="text-right">
                                    <p className="font-semibold text-green-600">{(user.greenPoints || 0).toLocaleString()}</p>
                                    <p className="text-xs text-gray-500">điểm</p>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
}
