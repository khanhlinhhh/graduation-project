import { useState, useEffect } from 'react';
import { collection, getDocs, doc, updateDoc, query, orderBy, where } from 'firebase/firestore';
import { db } from '../firebase';
import { Search, Plus, Minus, Eye, X, User, Mail, Calendar, Award } from 'lucide-react';

export default function Users() {
    const [users, setUsers] = useState([]);
    const [filteredUsers, setFilteredUsers] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');
    const [loading, setLoading] = useState(true);
    const [selectedUser, setSelectedUser] = useState(null);
    const [pointsModal, setPointsModal] = useState({ open: false, user: null, action: 'add' });
    const [pointsAmount, setPointsAmount] = useState('');

    useEffect(() => {
        fetchUsers();
    }, []);

    useEffect(() => {
        const filtered = users.filter(user =>
            user.displayName?.toLowerCase().includes(searchQuery.toLowerCase()) ||
            user.email?.toLowerCase().includes(searchQuery.toLowerCase())
        );
        setFilteredUsers(filtered);
    }, [searchQuery, users]);

    const fetchUsers = async () => {
        try {
            const snapshot = await getDocs(query(collection(db, 'users'), orderBy('createdAt', 'desc')));
            const usersData = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
            setUsers(usersData);
            setFilteredUsers(usersData);
        } catch (error) {
            console.error('Error fetching users:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleUpdatePoints = async () => {
        if (!pointsAmount || !pointsModal.user) return;

        const amount = parseInt(pointsAmount);
        if (isNaN(amount) || amount <= 0) return;

        const newPoints = pointsModal.action === 'add'
            ? (pointsModal.user.greenPoints || 0) + amount
            : Math.max(0, (pointsModal.user.greenPoints || 0) - amount);

        try {
            await updateDoc(doc(db, 'users', pointsModal.user.id), {
                greenPoints: newPoints
            });

            // Update local state
            const updatedUsers = users.map(u =>
                u.id === pointsModal.user.id ? { ...u, greenPoints: newPoints } : u
            );
            setUsers(updatedUsers);
            setPointsModal({ open: false, user: null, action: 'add' });
            setPointsAmount('');
        } catch (error) {
            console.error('Error updating points:', error);
        }
    };

    const fetchUserDetails = async (user) => {
        try {
            // Fetch check-in history
            const checkInsSnapshot = await getDocs(
                query(collection(db, 'checkins'), where('userId', '==', user.id), orderBy('timestamp', 'desc'))
            );
            const checkIns = checkInsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

            // Fetch redemption history
            const redemptionsSnapshot = await getDocs(
                query(collection(db, 'redemptions'), where('userId', '==', user.id), orderBy('redeemedAt', 'desc'))
            );
            const redemptions = redemptionsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

            setSelectedUser({ ...user, checkIns, redemptions });
        } catch (error) {
            console.error('Error fetching user details:', error);
            setSelectedUser(user);
        }
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
                <h1 className="text-3xl font-bold text-gray-800">Quản lý người dùng</h1>
                <p className="text-gray-500 mt-1">Xem và quản lý thông tin người dùng</p>
            </div>

            {/* Search */}
            <div className="mb-6">
                <div className="relative max-w-md">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                        type="text"
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        placeholder="Tìm kiếm theo tên hoặc email..."
                        className="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                    />
                </div>
            </div>

            {/* Users Table */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                <table className="w-full">
                    <thead className="bg-gray-50 border-b border-gray-100">
                        <tr>
                            <th className="text-left py-4 px-6 text-sm font-medium text-gray-500">Người dùng</th>
                            <th className="text-left py-4 px-6 text-sm font-medium text-gray-500">Email</th>
                            <th className="text-center py-4 px-6 text-sm font-medium text-gray-500">Điểm xanh</th>
                            <th className="text-center py-4 px-6 text-sm font-medium text-gray-500">Check-ins</th>
                            <th className="text-center py-4 px-6 text-sm font-medium text-gray-500">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        {filteredUsers.map((user) => (
                            <tr key={user.id} className="hover:bg-gray-50 transition-colors">
                                <td className="py-4 px-6">
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                                            {user.avatarUrl ? (
                                                <img src={user.avatarUrl} alt="" className="w-10 h-10 rounded-full object-cover" />
                                            ) : (
                                                <User className="w-5 h-5 text-green-600" />
                                            )}
                                        </div>
                                        <span className="font-medium text-gray-800">{user.displayName || 'Người dùng'}</span>
                                    </div>
                                </td>
                                <td className="py-4 px-6 text-gray-600">{user.email}</td>
                                <td className="py-4 px-6 text-center">
                                    <span className="font-semibold text-green-600">{(user.greenPoints || 0).toLocaleString()}</span>
                                </td>
                                <td className="py-4 px-6 text-center text-gray-600">{user.totalCheckIns || 0}</td>
                                <td className="py-4 px-6">
                                    <div className="flex items-center justify-center gap-2">
                                        <button
                                            onClick={() => fetchUserDetails(user)}
                                            className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                                            title="Xem chi tiết"
                                        >
                                            <Eye className="w-4 h-4" />
                                        </button>
                                        <button
                                            onClick={() => setPointsModal({ open: true, user, action: 'add' })}
                                            className="p-2 text-green-600 hover:bg-green-50 rounded-lg transition-colors"
                                            title="Thêm điểm"
                                        >
                                            <Plus className="w-4 h-4" />
                                        </button>
                                        <button
                                            onClick={() => setPointsModal({ open: true, user, action: 'subtract' })}
                                            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                            title="Trừ điểm"
                                        >
                                            <Minus className="w-4 h-4" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                {filteredUsers.length === 0 && (
                    <div className="py-12 text-center text-gray-500">
                        Không tìm thấy người dùng nào
                    </div>
                )}
            </div>

            {/* Points Modal */}
            {pointsModal.open && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">
                                {pointsModal.action === 'add' ? 'Thêm điểm' : 'Trừ điểm'}
                            </h3>
                            <button onClick={() => setPointsModal({ open: false, user: null, action: 'add' })} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <p className="text-gray-600 mb-4">
                            Người dùng: <span className="font-medium">{pointsModal.user?.displayName || pointsModal.user?.email}</span>
                        </p>
                        <p className="text-gray-600 mb-4">
                            Điểm hiện tại: <span className="font-semibold text-green-600">{(pointsModal.user?.greenPoints || 0).toLocaleString()}</span>
                        </p>

                        <input
                            type="number"
                            value={pointsAmount}
                            onChange={(e) => setPointsAmount(e.target.value)}
                            placeholder="Nhập số điểm"
                            className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none mb-6"
                        />

                        <div className="flex gap-3">
                            <button
                                onClick={() => setPointsModal({ open: false, user: null, action: 'add' })}
                                className="flex-1 py-3 border border-gray-200 text-gray-600 rounded-xl hover:bg-gray-50 transition-colors"
                            >
                                Hủy
                            </button>
                            <button
                                onClick={handleUpdatePoints}
                                className={`flex-1 py-3 text-white rounded-xl transition-colors ${pointsModal.action === 'add'
                                    ? 'bg-green-500 hover:bg-green-600'
                                    : 'bg-red-500 hover:bg-red-600'
                                    }`}
                            >
                                {pointsModal.action === 'add' ? 'Thêm điểm' : 'Trừ điểm'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* User Detail Modal */}
            {selectedUser && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">Chi tiết người dùng</h3>
                            <button onClick={() => setSelectedUser(null)} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        {/* User Info */}
                        <div className="bg-gray-50 rounded-xl p-4 mb-6">
                            <div className="flex items-center gap-4 mb-4">
                                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center">
                                    {selectedUser.avatarUrl ? (
                                        <img src={selectedUser.avatarUrl} alt="" className="w-16 h-16 rounded-full object-cover" />
                                    ) : (
                                        <User className="w-8 h-8 text-green-600" />
                                    )}
                                </div>
                                <div>
                                    <h4 className="text-xl font-semibold text-gray-800">{selectedUser.displayName || 'Người dùng'}</h4>
                                    <p className="text-gray-500">{selectedUser.email}</p>
                                </div>
                            </div>

                            <div className="grid grid-cols-3 gap-4">
                                <div className="text-center p-3 bg-white rounded-lg">
                                    <p className="text-2xl font-bold text-green-600">{(selectedUser.greenPoints || 0).toLocaleString()}</p>
                                    <p className="text-sm text-gray-500">Điểm xanh</p>
                                </div>
                                <div className="text-center p-3 bg-white rounded-lg">
                                    <p className="text-2xl font-bold text-blue-600">{selectedUser.totalCheckIns || 0}</p>
                                    <p className="text-sm text-gray-500">Check-ins</p>
                                </div>
                                <div className="text-center p-3 bg-white rounded-lg">
                                    <p className="text-2xl font-bold text-purple-600">{selectedUser.checkInStreak || 0}</p>
                                    <p className="text-sm text-gray-500">Streak</p>
                                </div>
                            </div>
                        </div>

                        {/* Recent Check-ins */}
                        {selectedUser.checkIns && selectedUser.checkIns.length > 0 && (
                            <div className="mb-6">
                                <h5 className="font-medium text-gray-800 mb-3">Lịch sử Check-in gần đây</h5>
                                <div className="space-y-2">
                                    {selectedUser.checkIns.slice(0, 5).map((checkIn) => (
                                        <div key={checkIn.id} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                                            <span className="text-gray-600">
                                                {checkIn.date?.toDate?.()?.toLocaleDateString('vi-VN') || 'N/A'}
                                            </span>
                                            <span className="text-green-600 font-medium">+{checkIn.pointsEarned} điểm</span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* Recent Redemptions */}
                        {selectedUser.redemptions && selectedUser.redemptions.length > 0 && (
                            <div>
                                <h5 className="font-medium text-gray-800 mb-3">Lịch sử đổi thưởng</h5>
                                <div className="space-y-2">
                                    {selectedUser.redemptions.slice(0, 5).map((redemption) => (
                                        <div key={redemption.id} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                                            <div className="flex items-center gap-2">
                                                <span>{redemption.rewardEmoji}</span>
                                                <span className="text-gray-600">{redemption.rewardName}</span>
                                            </div>
                                            <span className="text-red-600 font-medium">-{redemption.pointsUsed} điểm</span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
