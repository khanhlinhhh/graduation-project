import { useState, useEffect } from 'react';
import { collection, getDocs, doc, addDoc, updateDoc, deleteDoc, query, orderBy, getDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { Plus, Edit2, Trash2, X, Gift, User, Mail, Coins, Calendar } from 'lucide-react';

const EMOJI_OPTIONS = ['🎁', '🖊️', '📓', '🌱', '📔', '♻️', '🌵', '🛍️', '☕', '🎫', '🧴', '📱'];
const COLOR_OPTIONS = ['#4CAF50', '#5C6BC0', '#AB47BC', '#66BB6A', '#FFB74D', '#26C6DA', '#EF5350', '#FF7043'];

export default function Rewards() {
    const [rewards, setRewards] = useState([]);
    const [redemptions, setRedemptions] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [editingReward, setEditingReward] = useState(null);
    const [selectedRedemption, setSelectedRedemption] = useState(null);
    const [userInfo, setUserInfo] = useState(null);
    const [loadingUser, setLoadingUser] = useState(false);
    const [formData, setFormData] = useState({
        name: '',
        description: '',
        points: '',
        emoji: '🎁',
        colorHex: '#4CAF50',
    });

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        try {
            const rewardsSnapshot = await getDocs(query(collection(db, 'rewards'), orderBy('points')));
            setRewards(rewardsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })));

            const redemptionsSnapshot = await getDocs(query(collection(db, 'redemptions'), orderBy('redeemedAt', 'desc')));
            setRedemptions(redemptionsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })));
        } catch (error) {
            console.error('Error fetching data:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        const rewardData = {
            name: formData.name,
            description: formData.description,
            points: parseInt(formData.points),
            emoji: formData.emoji,
            colorHex: formData.colorHex,
        };

        try {
            if (editingReward) {
                await updateDoc(doc(db, 'rewards', editingReward.id), rewardData);
            } else {
                await addDoc(collection(db, 'rewards'), rewardData);
            }
            await fetchData();
            closeModal();
        } catch (error) {
            console.error('Error saving reward:', error);
        }
    };

    const handleDelete = async (rewardId) => {
        if (!confirm('Bạn có chắc muốn xóa phần thưởng này?')) return;

        try {
            await deleteDoc(doc(db, 'rewards', rewardId));
            await fetchData();
        } catch (error) {
            console.error('Error deleting reward:', error);
        }
    };

    const openEditModal = (reward) => {
        setEditingReward(reward);
        setFormData({
            name: reward.name,
            description: reward.description,
            points: reward.points.toString(),
            emoji: reward.emoji,
            colorHex: reward.colorHex,
        });
        setShowModal(true);
    };

    const closeModal = () => {
        setShowModal(false);
        setEditingReward(null);
        setFormData({ name: '', description: '', points: '', emoji: '🎁', colorHex: '#4CAF50' });
    };

    const handleRedemptionClick = async (redemption) => {
        setSelectedRedemption(redemption);
        setLoadingUser(true);
        setUserInfo(null);

        try {
            const userDoc = await getDoc(doc(db, 'users', redemption.userId));
            if (userDoc.exists()) {
                setUserInfo({ id: userDoc.id, ...userDoc.data() });
            } else {
                setUserInfo({ id: redemption.userId, displayName: 'Không tìm thấy', email: 'N/A' });
            }
        } catch (error) {
            console.error('Error fetching user:', error);
            setUserInfo({ id: redemption.userId, displayName: 'Lỗi tải', email: 'N/A' });
        } finally {
            setLoadingUser(false);
        }
    };

    const closeUserModal = () => {
        setSelectedRedemption(null);
        setUserInfo(null);
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
            <div className="flex items-center justify-between mb-8">
                <div>
                    <h1 className="text-3xl font-bold text-gray-800">Quản lý phần thưởng</h1>
                    <p className="text-gray-500 mt-1">Thêm, sửa, xóa phần thưởng cho người dùng</p>
                </div>
                <button
                    onClick={() => setShowModal(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors"
                >
                    <Plus className="w-5 h-5" />
                    <span>Thêm phần thưởng</span>
                </button>
            </div>

            {/* Rewards Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                {rewards.map((reward) => (
                    <div key={reward.id} className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div className="flex items-start justify-between mb-4">
                            <div
                                className="w-14 h-14 rounded-2xl flex items-center justify-center text-2xl"
                                style={{ backgroundColor: reward.colorHex + '20' }}
                            >
                                {reward.emoji}
                            </div>
                            <div className="flex gap-2">
                                <button
                                    onClick={() => openEditModal(reward)}
                                    className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                                >
                                    <Edit2 className="w-4 h-4" />
                                </button>
                                <button
                                    onClick={() => handleDelete(reward.id)}
                                    className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                >
                                    <Trash2 className="w-4 h-4" />
                                </button>
                            </div>
                        </div>
                        <h3 className="font-semibold text-gray-800 mb-1">{reward.name}</h3>
                        <p className="text-sm text-gray-500 mb-4 line-clamp-2">{reward.description}</p>
                        <div className="flex items-center justify-between">
                            <span className="text-lg font-bold text-green-600">{reward.points.toLocaleString()} điểm</span>
                        </div>
                    </div>
                ))}
            </div>

            {/* Recent Redemptions */}
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center gap-2 mb-6">
                    <Gift className="w-5 h-5 text-purple-600" />
                    <h2 className="text-lg font-semibold text-gray-800">Lượt đổi thưởng gần đây</h2>
                </div>
                <div className="overflow-x-auto">
                    <table className="w-full">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">Phần thưởng</th>
                                <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">User ID</th>
                                <th className="text-center py-3 px-4 text-sm font-medium text-gray-500">Điểm</th>
                                <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">Thời gian</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                            {redemptions.slice(0, 10).map((redemption) => (
                                <tr
                                    key={redemption.id}
                                    onClick={() => handleRedemptionClick(redemption)}
                                    className="hover:bg-green-50 cursor-pointer transition-colors"
                                >
                                    <td className="py-3 px-4">
                                        <div className="flex items-center gap-2">
                                            <span>{redemption.rewardEmoji}</span>
                                            <span className="text-gray-800">{redemption.rewardName}</span>
                                        </div>
                                    </td>
                                    <td className="py-3 px-4 text-blue-600 text-sm font-medium hover:underline">
                                        {redemption.userId?.slice(0, 8)}...
                                        <span className="text-gray-400 text-xs ml-1">👆</span>
                                    </td>
                                    <td className="py-3 px-4 text-center text-red-600 font-medium">-{redemption.pointsUsed}</td>
                                    <td className="py-3 px-4 text-gray-500 text-sm">
                                        {redemption.redeemedAt?.toDate?.()?.toLocaleString('vi-VN') || 'N/A'}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Modal */}
            {showModal && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">
                                {editingReward ? 'Sửa phần thưởng' : 'Thêm phần thưởng'}
                            </h3>
                            <button onClick={closeModal} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Tên phần thưởng</label>
                                <input
                                    type="text"
                                    value={formData.name}
                                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none"
                                    required
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                                <textarea
                                    value={formData.description}
                                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none resize-none"
                                    rows={2}
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Số điểm</label>
                                <input
                                    type="number"
                                    value={formData.points}
                                    onChange={(e) => setFormData({ ...formData, points: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none"
                                    required
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">Emoji</label>
                                <div className="flex flex-wrap gap-2">
                                    {EMOJI_OPTIONS.map((emoji) => (
                                        <button
                                            key={emoji}
                                            type="button"
                                            onClick={() => setFormData({ ...formData, emoji })}
                                            className={`w-10 h-10 text-xl rounded-lg border-2 transition-colors ${formData.emoji === emoji ? 'border-green-500 bg-green-50' : 'border-gray-200'
                                                }`}
                                        >
                                            {emoji}
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">Màu sắc</label>
                                <div className="flex flex-wrap gap-2">
                                    {COLOR_OPTIONS.map((color) => (
                                        <button
                                            key={color}
                                            type="button"
                                            onClick={() => setFormData({ ...formData, colorHex: color })}
                                            className={`w-10 h-10 rounded-lg border-2 transition-colors ${formData.colorHex === color ? 'border-gray-800' : 'border-transparent'
                                                }`}
                                            style={{ backgroundColor: color }}
                                        />
                                    ))}
                                </div>
                            </div>

                            <div className="flex gap-3 pt-4">
                                <button
                                    type="button"
                                    onClick={closeModal}
                                    className="flex-1 py-2 border border-gray-200 text-gray-600 rounded-xl hover:bg-gray-50 transition-colors"
                                >
                                    Hủy
                                </button>
                                <button
                                    type="submit"
                                    className="flex-1 py-2 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors"
                                >
                                    {editingReward ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* User Info Modal */}
            {selectedRedemption && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">Thông tin đổi thưởng</h3>
                            <button onClick={closeUserModal} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        {/* Redemption Info */}
                        <div className="bg-purple-50 rounded-xl p-4 mb-4">
                            <div className="flex items-center gap-3 mb-3">
                                <span className="text-3xl">{selectedRedemption.rewardEmoji}</span>
                                <div>
                                    <p className="font-semibold text-gray-800">{selectedRedemption.rewardName}</p>
                                    <p className="text-red-600 font-medium">-{selectedRedemption.pointsUsed} điểm</p>
                                </div>
                            </div>
                            <div className="flex items-center gap-2 text-sm text-gray-500">
                                <Calendar className="w-4 h-4" />
                                <span>{selectedRedemption.redeemedAt?.toDate?.()?.toLocaleString('vi-VN') || 'N/A'}</span>
                            </div>
                        </div>

                        {/* User Info */}
                        <div className="border border-gray-200 rounded-xl p-4">
                            <h4 className="font-medium text-gray-800 mb-3 flex items-center gap-2">
                                <User className="w-4 h-4 text-blue-600" />
                                Thông tin người dùng
                            </h4>

                            {loadingUser ? (
                                <div className="flex items-center justify-center py-4">
                                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500"></div>
                                </div>
                            ) : userInfo ? (
                                <div className="space-y-3">
                                    {userInfo.avatarUrl && (
                                        <div className="flex justify-center mb-4">
                                            <img
                                                src={userInfo.avatarUrl}
                                                alt="Avatar"
                                                className="w-16 h-16 rounded-full object-cover border-2 border-green-500"
                                            />
                                        </div>
                                    )}
                                    <div className="flex items-center gap-2">
                                        <User className="w-4 h-4 text-gray-400" />
                                        <span className="text-gray-600">Tên:</span>
                                        <span className="font-medium text-gray-800">{userInfo.displayName || 'Chưa đặt tên'}</span>
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <Mail className="w-4 h-4 text-gray-400" />
                                        <span className="text-gray-600">Email:</span>
                                        <span className="font-medium text-gray-800">{userInfo.email || 'N/A'}</span>
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <Coins className="w-4 h-4 text-gray-400" />
                                        <span className="text-gray-600">Điểm xanh:</span>
                                        <span className="font-medium text-green-600">{userInfo.greenPoints?.toLocaleString() || 0}</span>
                                    </div>
                                    <div className="pt-2 border-t border-gray-100">
                                        <p className="text-xs text-gray-400">User ID: {userInfo.id}</p>
                                    </div>
                                </div>
                            ) : (
                                <p className="text-gray-500 text-center py-4">Không tìm thấy thông tin</p>
                            )}
                        </div>

                        <button
                            onClick={closeUserModal}
                            className="w-full mt-4 py-2 border border-gray-200 text-gray-600 rounded-xl hover:bg-gray-50 transition-colors"
                        >
                            Đóng
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}
