import { useState, useEffect } from 'react';
import { db } from '../firebase';
import {
    collection,
    getDocs,
    addDoc,
    deleteDoc,
    doc,
    updateDoc,
    query,
    orderBy
} from 'firebase/firestore';
import {
    MapPin,
    Plus,
    Search,
    Pencil,
    Trash2,
    Loader2,
    Navigation,
    Phone,
    Clock,
    X,
    Save,
    AlertTriangle
} from 'lucide-react';

const CATEGORIES = [
    'Nhựa',
    'Giấy',
    'Kim loại',
    'Thủy tinh',
    'Pin/Điện tử'
];

export default function CollectionPoints() {
    const [points, setPoints] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [editingPoint, setEditingPoint] = useState(null);
    const [deleteId, setDeleteId] = useState(null);
    const [isSubmitting, setIsSubmitting] = useState(false);

    // Form state
    const [formData, setFormData] = useState({
        name: '',
        address: '',
        openTime: '08:00 - 17:00',
        phone: '',
        latitude: '',
        longitude: '',
        categories: [],
        rating: 5.0
    });

    useEffect(() => {
        fetchPoints();
    }, []);

    useEffect(() => {
        if (editingPoint) {
            setFormData({
                name: editingPoint.name,
                address: editingPoint.address,
                openTime: editingPoint.openTime,
                phone: editingPoint.phone,
                latitude: editingPoint.latitude,
                longitude: editingPoint.longitude,
                categories: editingPoint.categories || [],
                rating: editingPoint.rating
            });
        } else {
            setFormData({
                name: '',
                address: '',
                openTime: '08:00 - 17:00',
                phone: '',
                latitude: '',
                longitude: '',
                categories: [],
                rating: 5.0
            });
        }
    }, [editingPoint]);

    const fetchPoints = async () => {
        try {
            const q = query(collection(db, 'collection_points'), orderBy('name'));
            const querySnapshot = await getDocs(q);
            const pointsData = querySnapshot.docs.map(doc => ({
                id: doc.id,
                ...doc.data()
            }));
            setPoints(pointsData);
        } catch (error) {
            console.error("Error fetching points:", error);
            alert("Không thể tải danh sách điểm thu gom");
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsSubmitting(true);

        try {
            const dataToSave = {
                ...formData,
                latitude: parseFloat(formData.latitude),
                longitude: parseFloat(formData.longitude),
            };

            if (editingPoint) {
                await updateDoc(doc(db, 'collection_points', editingPoint.id), dataToSave);
            } else {
                await addDoc(collection(db, 'collection_points'), dataToSave);
            }

            setIsDialogOpen(false);
            setEditingPoint(null);
            fetchPoints();
        } catch (error) {
            console.error("Error saving point:", error);
            alert("Không thể lưu điểm thu gom");
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!deleteId) return;

        try {
            await deleteDoc(doc(db, 'collection_points', deleteId));
            fetchPoints();
        } catch (error) {
            console.error("Error deleting point:", error);
            alert("Không thể xóa điểm thu gom");
        } finally {
            setDeleteId(null);
        }
    };

    const toggleCategory = (category) => {
        setFormData(prev => {
            const current = prev.categories;
            if (current.includes(category)) {
                return { ...prev, categories: current.filter(c => c !== category) };
            } else {
                return { ...prev, categories: [...current, category] };
            }
        });
    };

    const filteredPoints = points.filter(point =>
        point.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        point.address.toLowerCase().includes(searchTerm.toLowerCase())
    );

    if (loading) {
        return (
            <div className="flex items-center justify-center h-full">
                <Loader2 className="w-8 h-8 animate-spin text-green-600" />
            </div>
        );
    }

    return (
        <div className="p-8 max-w-7xl mx-auto">
            <div className="flex justify-between items-center mb-8">
                <div>
                    <h1 className="text-3xl font-bold text-gray-800">Điểm thu gom rác</h1>
                    <p className="text-gray-500 mt-1">Quản lý các địa điểm thu gom rác tái chế</p>
                </div>
                <button
                    onClick={() => {
                        setEditingPoint(null);
                        setIsDialogOpen(true);
                    }}
                    className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-xl hover:bg-green-700 transition-colors"
                >
                    <Plus className="w-5 h-5" />
                    <span>Thêm điểm mới</span>
                </button>
            </div>

            <div className="mb-6">
                <div className="relative max-w-md">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                        type="text"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        placeholder="Tìm kiếm theo tên hoặc địa chỉ..."
                        className="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                    />
                </div>
            </div>

            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                <table className="w-full">
                    <thead className="bg-gray-50 border-b border-gray-100">
                        <tr>
                            <th className="text-left py-4 px-6 text-sm font-medium text-gray-500">Tên điểm thu gom</th>
                            <th className="text-left py-4 px-6 text-sm font-medium text-gray-500">Thông tin liên hệ</th>
                            <th className="text-left py-4 px-6 text-sm font-medium text-gray-500">Loại rác</th>
                            <th className="text-left py-4 px-6 text-sm font-medium text-gray-500">Tọa độ</th>
                            <th className="text-right py-4 px-6 text-sm font-medium text-gray-500">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        {filteredPoints.length === 0 ? (
                            <tr>
                                <td colSpan={5} className="py-12 text-center text-gray-500">
                                    Không tìm thấy điểm thu gom nào
                                </td>
                            </tr>
                        ) : (
                            filteredPoints.map((point) => (
                                <tr key={point.id} className="hover:bg-gray-50 transition-colors">
                                    <td className="py-4 px-6">
                                        <div className="font-medium text-gray-800">{point.name}</div>
                                        <div className="text-sm text-gray-500 flex items-center mt-1">
                                            <MapPin className="w-3 h-3 mr-1" />
                                            {point.address}
                                        </div>
                                    </td>
                                    <td className="py-4 px-6">
                                        <div className="text-sm flex items-center text-gray-600">
                                            <Clock className="w-3 h-3 mr-1 text-gray-400" />
                                            {point.openTime}
                                        </div>
                                        {point.phone && (
                                            <div className="text-sm text-gray-500 flex items-center mt-1">
                                                <Phone className="w-3 h-3 mr-1" />
                                                {point.phone}
                                            </div>
                                        )}
                                    </td>
                                    <td className="py-4 px-6">
                                        <div className="flex flex-wrap gap-1">
                                            {point.categories?.map((cat, idx) => (
                                                <span key={idx} className="bg-green-50 text-green-700 text-xs px-2 py-0.5 rounded-full border border-green-100">
                                                    {cat}
                                                </span>
                                            ))}
                                        </div>
                                    </td>
                                    <td className="py-4 px-6">
                                        <div className="text-xs text-gray-500 font-mono">
                                            {point.latitude?.toString().slice(0, 7)}, {point.longitude?.toString().slice(0, 7)}
                                        </div>
                                        <a
                                            href={`https://www.google.com/maps?q=${point.latitude},${point.longitude}`}
                                            target="_blank"
                                            rel="noreferrer"
                                            className="text-xs text-blue-600 hover:underline flex items-center mt-1"
                                        >
                                            <Navigation className="w-3 h-3 mr-0.5" /> Google Maps
                                        </a>
                                    </td>
                                    <td className="py-4 px-6">
                                        <div className="flex justify-end gap-2">
                                            <button
                                                onClick={() => {
                                                    setEditingPoint(point);
                                                    setIsDialogOpen(true);
                                                }}
                                                className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                                                title="Chỉnh sửa"
                                            >
                                                <Pencil className="w-4 h-4" />
                                            </button>
                                            <button
                                                onClick={() => setDeleteId(point.id)}
                                                className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                                title="Xóa"
                                            >
                                                <Trash2 className="w-4 h-4" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>

            {/* Add/Edit Modal */}
            {isDialogOpen && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">
                                {editingPoint ? 'Chỉnh sửa điểm thu gom' : 'Thêm điểm thu gom mới'}
                            </h3>
                            <button
                                onClick={() => setIsDialogOpen(false)}
                                className="text-gray-400 hover:text-gray-600"
                            >
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <label htmlFor="name" className="block text-sm font-medium text-gray-700">Tên điểm thu gom</label>
                                    <input
                                        id="name"
                                        value={formData.name}
                                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                                        placeholder="Vd: Điểm thu gom Quận 1"
                                        required
                                        className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                                    />
                                </div>
                                <div className="space-y-2">
                                    <label htmlFor="phone" className="block text-sm font-medium text-gray-700">Số điện thoại</label>
                                    <input
                                        id="phone"
                                        value={formData.phone}
                                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                                        placeholder="Vd: 0901234567"
                                        className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                                    />
                                </div>
                            </div>

                            <div className="space-y-2">
                                <label htmlFor="address" className="block text-sm font-medium text-gray-700">Địa chỉ</label>
                                <textarea
                                    id="address"
                                    value={formData.address}
                                    onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                                    placeholder="Địa chỉ cụ thể..."
                                    required
                                    rows={3}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                                />
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <label htmlFor="openTime" className="block text-sm font-medium text-gray-700">Giờ mở cửa</label>
                                    <input
                                        id="openTime"
                                        value={formData.openTime}
                                        onChange={(e) => setFormData({ ...formData, openTime: e.target.value })}
                                        placeholder="Vd: 08:00 - 17:00"
                                        className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                                    />
                                </div>
                                <div className="space-y-2">
                                    <label className="block text-sm font-medium text-gray-700">Loại rác thu gom</label>
                                    <div className="flex flex-wrap gap-2 mt-2">
                                        {CATEGORIES.map(cat => (
                                            <div
                                                key={cat}
                                                onClick={() => toggleCategory(cat)}
                                                className={`cursor-pointer px-3 py-1 rounded-full text-sm border transition-all ${formData.categories.includes(cat)
                                                        ? 'bg-green-100 border-green-500 text-green-700'
                                                        : 'bg-gray-50 border-gray-200 text-gray-600 hover:bg-gray-100'
                                                    }`}
                                            >
                                                {cat}
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <label htmlFor="latitude" className="block text-sm font-medium text-gray-700">Vĩ độ (Latitude)</label>
                                    <input
                                        id="latitude"
                                        type="number"
                                        step="any"
                                        value={formData.latitude}
                                        onChange={(e) => setFormData({ ...formData, latitude: e.target.value })}
                                        placeholder="Vd: 10.7769"
                                        required
                                        className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                                    />
                                </div>
                                <div className="space-y-2">
                                    <label htmlFor="longitude" className="block text-sm font-medium text-gray-700">Kinh độ (Longitude)</label>
                                    <input
                                        id="longitude"
                                        type="number"
                                        step="any"
                                        value={formData.longitude}
                                        onChange={(e) => setFormData({ ...formData, longitude: e.target.value })}
                                        placeholder="Vd: 106.7009"
                                        required
                                        className="w-full px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                                    />
                                </div>
                            </div>
                            <div className="text-xs text-gray-500 italic">
                                Tip: Bạn có thể lấy tọa độ từ Google Maps (nhấp chuột phải vào địa điểm &gt; chọn tọa độ đầu tiên).
                            </div>

                            <div className="flex justify-end gap-3 pt-4">
                                <button
                                    type="button"
                                    onClick={() => setIsDialogOpen(false)}
                                    className="px-4 py-2 border border-gray-200 rounded-lg text-gray-600 hover:bg-gray-50 transition-colors"
                                >
                                    Hủy
                                </button>
                                <button
                                    type="submit"
                                    disabled={isSubmitting}
                                    className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50"
                                >
                                    {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                                    {editingPoint ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Delete Confirmation Modal */}
            {deleteId && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md">
                        <div className="flex items-center gap-4 mb-4">
                            <div className="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <AlertTriangle className="w-6 h-6 text-red-600" />
                            </div>
                            <div>
                                <h3 className="text-lg font-semibold text-gray-800">Xác nhận xóa</h3>
                                <p className="text-gray-500 text-sm">
                                    Bạn có chắc chắn muốn xóa điểm thu gom này? Hành động này không thể hoàn tác.
                                </p>
                            </div>
                        </div>

                        <div className="flex justify-end gap-3">
                            <button
                                onClick={() => setDeleteId(null)}
                                className="px-4 py-2 border border-gray-200 rounded-lg text-gray-600 hover:bg-gray-50 transition-colors"
                            >
                                Hủy
                            </button>
                            <button
                                onClick={handleDelete}
                                className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
                            >
                                Xóa vĩnh viễn
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
