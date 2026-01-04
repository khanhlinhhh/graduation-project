import { useState, useEffect } from 'react';
import { collection, getDocs, query, orderBy, doc, getDoc, writeBatch, increment, serverTimestamp } from 'firebase/firestore';
import { db } from '../firebase';
import { Package, MapPin, User, CheckCircle, XCircle, Clock } from 'lucide-react';

export default function WasteRequests() {
    const [requests, setRequests] = useState([]);
    const [stats, setStats] = useState({ pending: 0, confirmed: 0, rejected: 0 });
    const [filter, setFilter] = useState('pending');
    const [loading, setLoading] = useState(true);
    const [selectedRequest, setSelectedRequest] = useState(null);
    const [userDetails, setUserDetails] = useState(null);
    const [modalLoading, setModalLoading] = useState(false);

    useEffect(() => {
        fetchRequests();
    }, []);

    const fetchRequests = async () => {
        try {
            const snapshot = await getDocs(query(collection(db, 'waste_requests'), orderBy('createdAt', 'desc')));
            const requestsData = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
            setRequests(requestsData);

            const pending = requestsData.filter(r => r.status === 'pending').length;
            const confirmed = requestsData.filter(r => r.status === 'confirmed').length;
            const rejected = requestsData.filter(r => r.status === 'rejected').length;
            setStats({ pending, confirmed, rejected });
        } catch (error) {
            console.error('Error:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleRequestClick = async (request) => {
        setSelectedRequest(request);
        setModalLoading(true);
        setUserDetails(null);
        try {
            const userDoc = await getDoc(doc(db, 'users', request.userId));
            if (userDoc.exists()) setUserDetails({ id: userDoc.id, ...userDoc.data() });
        } catch (error) {
            console.error('Error:', error);
        } finally {
            setModalLoading(false);
        }
    };

    const handleConfirm = async (request) => {
        if (!window.confirm(`Xác nhận yêu cầu? User sẽ nhận ${request.pointsAwarded} điểm.`)) return;
        try {
            const batch = writeBatch(db);
            batch.update(doc(db, 'waste_requests', request.id), {
                status: 'confirmed',
                confirmedBy: 'admin',
                confirmedAt: serverTimestamp(),
                updatedAt: serverTimestamp(),
            });
            batch.update(doc(db, 'users', request.userId), { greenPoints: increment(request.pointsAwarded) });
            batch.set(doc(collection(db, 'notifications')), {
                userId: request.userId,
                title: '✅ Đã xác nhận thu gom rác',
                message: `Bạn nhận ${request.pointsAwarded} điểm. Cảm ơn bạn đã bảo vệ môi trường!`,
                type: 'waste_confirmed',
                createdAt: serverTimestamp(),
                isRead: false,
                data: { requestId: request.id, points: request.pointsAwarded },
            });
            await batch.commit();
            await fetchRequests();
            setSelectedRequest(null);
            alert('✅ Đã xác nhận!');
        } catch (error) {
            alert('❌ Lỗi: ' + error.message);
        }
    };

    const handleReject = async (request) => {
        const reason = window.prompt('Nhập lý do từ chối:');
        if (!reason) return;
        try {
            const batch = writeBatch(db);
            batch.update(doc(db, 'waste_requests', request.id), {
                status: 'rejected',
                rejectionReason: reason,
                confirmedBy: 'admin',
                confirmedAt: serverTimestamp(),
                updatedAt: serverTimestamp(),
            });
            batch.set(doc(collection(db, 'notifications')), {
                userId: request.userId,
                title: '❌ Yêu cầu bị từ chối',
                message: `Yêu cầu bị từ chối. Lý do: ${reason}`,
                type: 'waste_rejected',
                createdAt: serverTimestamp(),
                isRead: false,
                data: { requestId: request.id, reason },
            });
            await batch.commit();
            await fetchRequests();
            setSelectedRequest(null);
            alert('✅ Đã từ chối');
        } catch (error) {
            alert('❌ Lỗi: ' + error.message);
        }
    };

    const filteredRequests = requests.filter(r => filter === 'all' || r.status === filter);

    if (loading) return <div className="flex items-center justify-center h-full"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-500"></div></div>;

    return (
        <div className="p-8">
            <div className="mb-8">
                <h1 className="text-3xl font-bold text-gray-800">Yêu cầu thu gom rác</h1>
                <p className="text-gray-500 mt-1">Quản lý yêu cầu pickup và dropoff</p>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                            <Clock className="w-6 h-6 text-orange-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500">Chờ xác nhận</p>
                            <p className="text-2xl font-bold text-gray-800">{stats.pending}</p>
                        </div>
                    </div>
                </div>

                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                            <CheckCircle className="w-6 h-6 text-green-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500">Đã xác nhận</p>
                            <p className="text-2xl font-bold text-gray-800">{stats.confirmed}</p>
                        </div>
                    </div>
                </div>

                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                            <XCircle className="w-6 h-6 text-red-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500">Đã từ chối</p>
                            <p className="text-2xl font-bold text-gray-800">{stats.rejected}</p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Filters */}
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 mb-8">
                <div className="flex gap-4 border-b">
                    {['pending', 'confirmed', 'rejected', 'all'].map(s => (
                        <button
                            key={s}
                            onClick={() => setFilter(s)}
                            className={`pb-3 px-4 font-medium transition-colors ${filter === s ? 'text-green-600 border-b-2 border-green-600' : 'text-gray-500 hover:text-gray-700'}`}
                        >
                            {s === 'pending' && `Chờ (${stats.pending})`}
                            {s === 'confirmed' && `Đã xác nhận (${stats.confirmed})`}
                            {s === 'rejected' && `Từ chối (${stats.rejected})`}
                            {s === 'all' && `Tất cả (${requests.length})`}
                        </button>
                    ))}
                </div>
            </div>

            {/* Table */}
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <table className="w-full">
                    <thead className="bg-gray-50">
                        <tr>
                            <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">User</th>
                            <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">Loại</th>
                            <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">Phương thức</th>
                            <th className="text-left py-3 px-4 text-sm font-medium text-gray-500">Địa chỉ/Điểm</th>
                            <th className="text-center py-3 px-4 text-sm font-medium text-gray-500">Điểm</th>
                            <th className="text-center py-3 px-4 text-sm font-medium text-gray-500">Trạng thái</th>
                            <th className="text-center py-3 px-4 text-sm font-medium text-gray-500">Hành động</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        {filteredRequests.map(req => (
                            <tr key={req.id} className="hover:bg-green-50 cursor-pointer transition-colors" onClick={() => handleRequestClick(req)}>
                                <td className="py-3 px-4 text-gray-600">{req.userId?.slice(0, 8)}...</td>
                                <td className="py-3 px-4"><span className="px-2 py-1 bg-green-100 text-green-600 rounded-full text-sm">♻️ {req.wasteTypeLabel}</span></td>
                                <td className="py-3 px-4">
                                    <div className="flex items-center gap-2">
                                        {req.type === 'pickup' ? (
                                            <><Package className="w-4 h-4 text-blue-600" /><span className="text-sm text-blue-600">Đến lấy</span></>
                                        ) : (
                                            <><MapPin className="w-4 h-4 text-purple-600" /><span className="text-sm text-purple-600">Dropoff</span></>
                                        )}
                                    </div>
                                </td>
                                <td className="py-3 px-4 text-sm text-gray-600">{req.type === 'pickup' ? req.address : req.collectionPointName}</td>
                                <td className="py-3 px-4 text-center text-green-600 font-medium">+{req.pointsAwarded}</td>
                                <td className="py-3 px-4 text-center">
                                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${req.status === 'pending' ? 'bg-orange-100 text-orange-600' :
                                            req.status === 'confirmed' ? 'bg-green-100 text-green-600' :
                                                'bg-red-100 text-red-600'
                                        }`}>
                                        {req.status === 'pending' && '⏳ Chờ'}
                                        {req.status === 'confirmed' && '✅ OK'}
                                        {req.status === 'rejected' && '❌ Từ chối'}
                                    </span>
                                </td>
                                <td className="py-3 px-4">
                                    {req.status === 'pending' && (
                                        <div className="flex gap-2 justify-center" onClick={(e) => e.stopPropagation()}>
                                            <button onClick={() => handleConfirm(req)} className="p-1 hover:bg-green-100 rounded" title="Xác nhận"><CheckCircle className="w-5 h-5 text-green-600" /></button>
                                            <button onClick={() => handleReject(req)} className="p-1 hover:bg-red-100 rounded" title="Từ chối"><XCircle className="w-5 h-5 text-red-600" /></button>
                                        </div>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                {filteredRequests.length === 0 && <div className="text-center py-12 text-gray-500">Không có yêu cầu</div>}
            </div>

            {/* Modal */}
            {selectedRequest && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50" onClick={() => setSelectedRequest(null)}>
                    <div className="bg-white rounded-2xl p-6 w-full max-w-2xl mx-4 shadow-2xl" onClick={(e) => e.stopPropagation()}>
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-xl font-bold text-gray-800">Chi tiết yêu cầu</h3>
                            <button onClick={() => setSelectedRequest(null)} className="p-2 hover:bg-gray-100 rounded-full"><XCircle className="w-5 h-5 text-gray-500" /></button>
                        </div>
                        {modalLoading ? (
                            <div className="flex items-center justify-center py-8"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500"></div></div>
                        ) : (
                            <div className="space-y-6">
                                {userDetails && (
                                    <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-4">
                                        <h4 className="text-sm font-medium text-gray-500 mb-3">Thông tin User</h4>
                                        <div className="flex items-center gap-4">
                                            {userDetails.avatarUrl ? (
                                                <img src={userDetails.avatarUrl} alt="Avatar" className="w-16 h-16 rounded-full object-cover border-2 border-white shadow" />
                                            ) : (
                                                <div className="w-16 h-16 rounded-full bg-green-200 flex items-center justify-center"><User className="w-8 h-8 text-green-600" /></div>
                                            )}
                                            <div>
                                                <p className="font-semibold text-gray-800">{userDetails.displayName || 'Chưa đặt tên'}</p>
                                                <p className="text-gray-500 text-sm">{userDetails.email}</p>
                                                <p className="text-green-600 text-sm">💚 {userDetails.greenPoints || 0} điểm</p>
                                            </div>
                                        </div>
                                    </div>
                                )}
                                <div className="bg-gray-50 rounded-xl p-4 space-y-3">
                                    <h4 className="text-sm font-medium text-gray-500 mb-3">Chi tiết yêu cầu</h4>
                                    <div className="grid grid-cols-2 gap-4">
                                        <div><p className="text-xs text-gray-500">Loại rác</p><p className="font-medium">{selectedRequest.wasteTypeLabel}</p></div>
                                        <div><p className="text-xs text-gray-500">Phương thức</p><p className="font-medium">{selectedRequest.type === 'pickup' ? '📦 Đến lấy' : '📍 Dropoff'}</p></div>
                                        <div><p className="text-xs text-gray-500">Điểm thưởng</p><p className="font-semibold text-green-600">+{selectedRequest.pointsAwarded} điểm</p></div>
                                        <div><p className="text-xs text-gray-500">Độ tin cậy</p><p className="font-medium">{(selectedRequest.confidence * 100).toFixed(0)}%</p></div>
                                    </div>
                                    <div className="pt-3 border-t"><p className="text-xs text-gray-500">{selectedRequest.type === 'pickup' ? 'Địa chỉ' : 'Điểm thu gom'}</p><p className="font-medium">{selectedRequest.type === 'pickup' ? selectedRequest.address : selectedRequest.collectionPointName}</p></div>
                                    {selectedRequest.notes && <div className="pt-3 border-t"><p className="text-xs text-gray-500">Ghi chú</p><p className="text-sm">{selectedRequest.notes}</p></div>}
                                </div>
                                {selectedRequest.status === 'pending' && (
                                    <div className="flex gap-3">
                                        <button onClick={() => handleReject(selectedRequest)} className="flex-1 py-3 bg-red-500 hover:bg-red-600 text-white rounded-xl font-medium">❌ Từ chối</button>
                                        <button onClick={() => handleConfirm(selectedRequest)} className="flex-1 py-3 bg-green-500 hover:bg-green-600 text-white rounded-xl font-medium">✅ Xác nhận</button>
                                    </div>
                                )}
                            </div>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
