import { useState, useEffect } from 'react';
import { collection, getDocs, query, orderBy, doc, getDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { CalendarCheck, TrendingUp, Calendar, X, User, Mail, Award, Flame } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

export default function CheckIns() {
    const [checkIns, setCheckIns] = useState([]);
    const [stats, setStats] = useState({ today: 0, thisWeek: 0, thisMonth: 0 });
    const [chartData, setChartData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [selectedCheckIn, setSelectedCheckIn] = useState(null);
    const [selectedUser, setSelectedUser] = useState(null);
    const [modalLoading, setModalLoading] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchCheckIns();
    }, []);

    const fetchCheckIns = async () => {
        try {
            const snapshot = await getDocs(
                query(collection(db, 'checkins'), orderBy('timestamp', 'desc'))
            );
            const checkInsData = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
            setCheckIns(checkInsData);

            // Calculate stats
            const now = new Date();
            const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const weekAgo = new Date(today);
            weekAgo.setDate(weekAgo.getDate() - 7);
            const monthAgo = new Date(today);
            monthAgo.setMonth(monthAgo.getMonth() - 1);

            let todayCount = 0, weekCount = 0, monthCount = 0;
            const dailyCounts = {};

            checkInsData.forEach(checkIn => {
                const checkInDate = checkIn.date?.toDate?.() || checkIn.timestamp?.toDate?.();
                if (!checkInDate) return;

                if (checkInDate >= today) todayCount++;
                if (checkInDate >= weekAgo) weekCount++;
                if (checkInDate >= monthAgo) monthCount++;

                // Count by day for chart
                const dayKey = checkInDate.toISOString().split('T')[0];
                dailyCounts[dayKey] = (dailyCounts[dayKey] || 0) + 1;
            });

            setStats({ today: todayCount, thisWeek: weekCount, thisMonth: monthCount });

            // Prepare chart data (last 14 days)
            const chartArray = [];
            for (let i = 13; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);
                const dayKey = date.toISOString().split('T')[0];
                chartArray.push({
                    name: date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' }),
                    checkIns: dailyCounts[dayKey] || 0,
                });
            }
            setChartData(chartArray);
        } catch (error) {
            console.error('Error fetching check-ins:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleCheckInClick = async (checkIn) => {
        if (!checkIn || !checkIn.userId) {
            console.error('Invalid check-in data');
            return;
        }

        setError(null);
        setSelectedCheckIn(checkIn);
        setSelectedUser(null);
        setModalLoading(true);

        try {
            // Fetch user data from Firestore
            const userDoc = await getDoc(doc(db, 'users', checkIn.userId));
            if (userDoc.exists()) {
                setSelectedUser({ id: userDoc.id, ...userDoc.data() });
            } else {
                setSelectedUser(null);
            }
        } catch (error) {
            console.error('Error fetching user:', error);
            setError('Không thể tải thông tin người dùng');
            setSelectedUser(null);
        } finally {
            setModalLoading(false);
        }
    };

    const closeModal = () => {
        setSelectedCheckIn(null);
        setSelectedUser(null);
    };

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
                <h1 className="text-3xl font-bold text-gray-800">Thống kê Check-in</h1>
                <p className="text-gray-500 mt-1">Xem hoạt động check-in của người dùng</p>
            </div>

            {/* Stats Cards */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <CalendarCheck className="w-6 h-6 text-green-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500">Hôm nay</p>
                            <p className="text-2xl font-bold text-gray-800">{stats.today}</p>
                        </div>
                    </div>
                </div>

                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                            <TrendingUp className="w-6 h-6 text-blue-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500">7 ngày qua</p>
                            <p className="text-2xl font-bold text-gray-800">{stats.thisWeek}</p>
                        </div>
                    </div>
                </div>

                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                            <Calendar className="w-6 h-6 text-purple-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500">30 ngày qua</p>
                            <p className="text-2xl font-bold text-gray-800">{stats.thisMonth}</p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Chart */}
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 mb-8">
                <h2 className="text-lg font-semibold text-gray-800 mb-6">Check-in 14 ngày qua</h2>
                <ResponsiveContainer width="100%" height={300}>
                    <BarChart data={chartData}>
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
                        <Bar dataKey="checkIns" fill="#22c55e" radius={[4, 4, 0, 0]} />
                    </BarChart>
                </ResponsiveContainer>
            </div>

            {/* Recent Check-ins */}
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <h2 className="text-lg font-semibold text-gray-800 mb-6">Check-in gần đây</h2>
                <p className="text-sm text-gray-500 mb-4">💡 Click vào hàng để xem thông tin user</p>
                <div className="overflow-x-auto">
                    <table className="w-full">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">User ID</th>
                                <th className="text-center py-3 px-4 text-sm font-medium text-gray-500">Streak</th>
                                <th className="text-center py-3 px-4 text-sm font-medium text-gray-500">Điểm nhận</th>
                                <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">Thời gian</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                            {checkIns.slice(0, 20).map((checkIn) => (
                                <tr
                                    key={checkIn.id}
                                    className="hover:bg-green-50 cursor-pointer transition-colors"
                                    onClick={() => handleCheckInClick(checkIn)}
                                >
                                    <td className="py-3 px-4 text-gray-600">{checkIn.userId?.slice(0, 12)}...</td>
                                    <td className="py-3 px-4 text-center">
                                        <span className="px-2 py-1 bg-orange-100 text-orange-600 rounded-full text-sm font-medium">
                                            🔥 {checkIn.streakDay || 1}
                                        </span>
                                    </td>
                                    <td className="py-3 px-4 text-center text-green-600 font-medium">
                                        +{checkIn.pointsEarned || 10}
                                    </td>
                                    <td className="py-3 px-4 text-gray-500 text-sm">
                                        {checkIn.timestamp?.toDate?.()?.toLocaleString('vi-VN') || 'N/A'}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* User Detail Modal */}
            {selectedCheckIn && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md mx-4 shadow-2xl">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-xl font-bold text-gray-800">Chi tiết Check-in</h3>
                            <button
                                onClick={closeModal}
                                className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                            >
                                <X className="w-5 h-5 text-gray-500" />
                            </button>
                        </div>

                        {modalLoading ? (
                            <div className="flex items-center justify-center py-8">
                                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500"></div>
                            </div>
                        ) : (
                            <div className="space-y-6">
                                {/* User Info */}
                                <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-4">
                                    <h4 className="text-sm font-medium text-gray-500 mb-3">Thông tin User</h4>
                                    {selectedUser ? (
                                        <div className="flex items-center gap-4">
                                            {selectedUser.avatarUrl ? (
                                                <img
                                                    src={selectedUser.avatarUrl}
                                                    alt="Avatar"
                                                    className="w-16 h-16 rounded-full object-cover border-2 border-white shadow"
                                                />
                                            ) : (
                                                <div className="w-16 h-16 rounded-full bg-green-200 flex items-center justify-center">
                                                    <User className="w-8 h-8 text-green-600" />
                                                </div>
                                            )}
                                            <div className="flex-1">
                                                <p className="font-semibold text-gray-800">
                                                    {selectedUser.displayName || 'Chưa đặt tên'}
                                                </p>
                                                <div className="flex items-center gap-1 text-gray-500 text-sm mt-1">
                                                    <Mail className="w-4 h-4" />
                                                    <span>{selectedUser.email || 'N/A'}</span>
                                                </div>
                                                <div className="flex items-center gap-1 text-green-600 text-sm mt-1">
                                                    <Award className="w-4 h-4" />
                                                    <span>{selectedUser.greenPoints || 0} điểm xanh</span>
                                                </div>
                                            </div>
                                        </div>
                                    ) : (
                                        <p className="text-gray-500 italic">Không tìm thấy thông tin user</p>
                                    )}
                                </div>

                                {/* Check-in Details */}
                                <div className="bg-gray-50 rounded-xl p-4">
                                    <h4 className="text-sm font-medium text-gray-500 mb-3">Chi tiết Check-in</h4>
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="flex items-center gap-2">
                                            <Flame className="w-5 h-5 text-orange-500" />
                                            <div>
                                                <p className="text-xs text-gray-500">Streak</p>
                                                <p className="font-semibold text-gray-800">
                                                    {selectedCheckIn.streakDay || 1} ngày
                                                </p>
                                            </div>
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <Award className="w-5 h-5 text-green-500" />
                                            <div>
                                                <p className="text-xs text-gray-500">Điểm nhận</p>
                                                <p className="font-semibold text-green-600">
                                                    +{selectedCheckIn.pointsEarned || 10} điểm
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="mt-4 pt-4 border-t border-gray-200">
                                        <p className="text-xs text-gray-500">Thời gian check-in</p>
                                        <p className="font-medium text-gray-800">
                                            {selectedCheckIn.timestamp?.toDate?.()?.toLocaleString('vi-VN') || 'N/A'}
                                        </p>
                                    </div>
                                    <div className="mt-3">
                                        <p className="text-xs text-gray-500">User ID</p>
                                        <p className="font-mono text-xs text-gray-600 break-all">
                                            {selectedCheckIn.userId}
                                        </p>
                                    </div>
                                </div>

                                {/* Close Button */}
                                <button
                                    onClick={closeModal}
                                    className="w-full py-3 bg-green-500 hover:bg-green-600 text-white rounded-xl font-medium transition-colors"
                                >
                                    Đóng
                                </button>
                            </div>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
