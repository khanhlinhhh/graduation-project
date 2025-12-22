import { useState, useEffect } from 'react';
import { collection, getDocs, doc, updateDoc, deleteDoc, query, orderBy, where } from 'firebase/firestore';
import { db } from '../firebase';
import { Search, Plus, Minus, Eye, X, User, Pencil, Trash2, AlertTriangle, Save, Loader2 } from 'lucide-react';

export default function Users() {
    const [users, setUsers] = useState([]);
    const [filteredUsers, setFilteredUsers] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');
    const [loading, setLoading] = useState(true);
    const [selectedUser, setSelectedUser] = useState(null);
    const [pointsModal, setPointsModal] = useState({ open: false, user: null, action: 'add' });
    const [pointsAmount, setPointsAmount] = useState('');

    // New State for Edit/Delete
    const [editModal, setEditModal] = useState({ open: false, user: null });
    const [deleteModal, setDeleteModal] = useState({ open: false, userId: null });
    const [isSubmitting, setIsSubmitting] = useState(false);

    // Form data for edit
    const [editForm, setEditForm] = useState({ displayName: '', email: '', isAdmin: false });

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

    useEffect(() => {
        if (editModal.user) {
            setEditForm({
                displayName: editModal.user.displayName || '',
                email: editModal.user.email || '',
                isAdmin: editModal.user.isAdmin || false
            });
        }
    }, [editModal.user]);

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

    const handleUpdateUser = async (e) => {
        e.preventDefault();
        if (!editModal.user) return;
        setIsSubmitting(true);

        try {
            await updateDoc(doc(db, 'users', editModal.user.id), {
                displayName: editForm.displayName,
                email: editForm.email,
                isAdmin: editForm.isAdmin
            });

            // Update local state
            setUsers(prev => prev.map(u =>
                u.id === editModal.user.id
                    ? { ...u, displayName: editForm.displayName, email: editForm.email, isAdmin: editForm.isAdmin }
                    : u
            ));

            setEditModal({ open: false, user: null });
        } catch (error) {
            console.error("Error updating user:", error);
            alert("Không thể cập nhật thông tin người dùng");
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDeleteUser = async () => {
        if (!deleteModal.userId) return;
        setIsSubmitting(true);

        try {
            await deleteDoc(doc(db, 'users', deleteModal.userId));
            setUsers(prev => prev.filter(u => u.id !== deleteModal.userId));
            setDeleteModal({ open: false, userId: null });
        } catch (error) {
            console.error("Error deleting user:", error);
            alert("Không thể xóa người dùng");
        } finally {
            setIsSubmitting(false);
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
                            <th className="text-center py-4 px-6 text-sm font-medium text-gray-500">Vai trò</th>
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
                                        <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center overflow-hidden">
                                            {user.avatarUrl ? (
                                                <img src={user.avatarUrl} alt="" className="w-full h-full object-cover" />
                                            ) : (
                                                <User className="w-5 h-5 text-green-600" />
                                            )}
                                        </div>
                                        <span className="font-medium text-gray-800">{user.displayName || 'Người dùng'}</span>
                                    </div>
                                </td>
                                <td className="py-4 px-6 text-gray-600">{user.email}</td>
                                <td className="py-4 px-6 text-center">
                                    {user.isAdmin ? (
                                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                                            Admin
                                        </span>
                                    ) : (
                                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                            User
                                        </span>
                                    )}
                                </td>
                                <td className="py-4 px-6 text-center">
                                    <span className="font-semibold text-green-600">{(user.greenPoints || 0).toLocaleString()}</span>
                                </td>
                                <td className="py-4 px-6 text-center text-gray-600">{user.totalCheckIns || 0}</td>
                                <td className="py-4 px-6">
                                    <div className="flex items-center justify-center gap-1.5">
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
                                            className="p-2 text-orange-600 hover:bg-orange-50 rounded-lg transition-colors"
                                            title="Trừ điểm"
                                        >
                                            <Minus className="w-4 h-4" />
                                        </button>
                                        <div className="w-px h-6 bg-gray-200 mx-1"></div>
                                        <button
                                            onClick={() => setEditModal({ open: true, user })}
                                            className="p-2 text-gray-600 hover:bg-gray-100 rounded-lg transition-colors"
                                            title="Chỉnh sửa thông tin"
                                        >
                                            <Pencil className="w-4 h-4" />
                                        </button>
                                        <button
                                            onClick={() => setDeleteModal({ open: true, userId: user.id })}
                                            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                            title="Xóa người dùng"
                                        >
                                            <Trash2 className="w-4 h-4" />
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
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
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

            {/* Edit User Modal */}
            {editModal.open && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">Chỉnh sửa thông tin</h3>
                            <button onClick={() => setEditModal({ open: false, user: null })} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <form onSubmit={handleUpdateUser} className="space-y-4">
                            <div className="space-y-2">
                                <label className="block text-sm font-medium text-gray-700">Tên hiển thị</label>
                                <input
                                    type="text"
                                    value={editForm.displayName}
                                    onChange={(e) => setEditForm({ ...editForm, displayName: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 outline-none"
                                    placeholder="Nhập tên hiển thị"
                                />
                            </div>

                            <div className="space-y-2">
                                <label className="block text-sm font-medium text-gray-700">Email</label>
                                <input
                                    type="email"
                                    value={editForm.email}
                                    onChange={(e) => setEditForm({ ...editForm, email: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 outline-none"
                                    placeholder="example@email.com"
                                />
                            </div>

                            <div className="space-y-2">
                                <label className="flex items-center justify-between">
                                    <span className="block text-sm font-medium text-gray-700">Quyền quản trị</span>
                                    <label className="relative inline-flex items-center cursor-pointer">
                                        <input
                                            type="checkbox"
                                            checked={editForm.isAdmin}
                                            onChange={(e) => setEditForm({ ...editForm, isAdmin: e.target.checked })}
                                            className="sr-only peer"
                                        />
                                        <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-purple-300 rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-purple-600"></div>
                                    </label>
                                </label>
                                <p className="text-xs text-gray-500">Cho phép người dùng truy cập bảng quản trị</p>
                            </div>

                            <div className="flex justify-end gap-3 pt-4">
                                <button
                                    type="button"
                                    onClick={() => setEditModal({ open: false, user: null })}
                                    className="px-4 py-2 text-gray-600 hover:bg-gray-50 rounded-lg border border-gray-200"
                                >
                                    Hủy
                                </button>
                                <button
                                    type="submit"
                                    disabled={isSubmitting}
                                    className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:opacity-50"
                                >
                                    {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                                    Cập nhật
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Delete Confirmation Modal */}
            {deleteModal.open && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-sm">
                        <div className="flex flex-col items-center text-center mb-6">
                            <div className="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center mb-4">
                                <AlertTriangle className="w-6 h-6 text-red-600" />
                            </div>
                            <h3 className="text-lg font-semibold text-gray-800">Xóa người dùng?</h3>
                            <p className="text-gray-500 text-sm mt-2">
                                Hành động này sẽ xóa vĩnh viễn tài khoản và dữ liệu liên quan. Bạn có chắc chắn không?
                            </p>
                        </div>

                        <div className="flex gap-3">
                            <button
                                onClick={() => setDeleteModal({ open: false, userId: null })}
                                className="flex-1 py-2 text-gray-600 hover:bg-gray-50 rounded-lg border border-gray-200"
                            >
                                Hủy
                            </button>
                            <button
                                onClick={handleDeleteUser}
                                disabled={isSubmitting}
                                className="flex-1 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:opacity-50"
                            >
                                {isSubmitting ? 'Đang xóa...' : 'Xóa vĩnh viễn'}
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
                                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center overflow-hidden">
                                    {selectedUser.avatarUrl ? (
                                        <img src={selectedUser.avatarUrl} alt="" className="w-full h-full object-cover" />
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
