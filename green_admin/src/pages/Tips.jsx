import { useState, useEffect } from 'react';
import { collection, getDocs, doc, addDoc, updateDoc, deleteDoc, query, orderBy } from 'firebase/firestore';
import { db } from '../firebase';
import { uploadToCloudinary } from '../cloudinary';
import { Plus, Edit2, Trash2, X, Lightbulb, ChevronDown, ChevronUp, Upload, Image } from 'lucide-react';

const CATEGORIES = ['Giấy', 'Nguy hại', 'Tái chế', 'Hữu cơ', 'Điện tử'];
const ICONS = [
    // Chung
    '♻️', '🗑️', '🌍', '🌱', '💧', '💡',
    // Giấy & Carton
    '📦', '📰', '📄', '🧻', '📋',
    // Nguy hại
    '🔋', '⚠️', '☢️', '💊', '🧪', '🔌', '💀',
    // Tái chế
    '🥫', '🍾', '🧴', '🥤', '🫙',
    // Hữu cơ
    '🍌', '🍎', '🥬', '🍂', '☕', '🥕', '🍲',
    // Điện tử
    '📱', '💻', '🖥️', '🎧', '📺', '🖨️',
    // Vải & Khác
    '👕', '👔', '👟', '🧵', '🎒',
];

export default function Tips() {
    const [tips, setTips] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [editingTip, setEditingTip] = useState(null);
    const [expandedTip, setExpandedTip] = useState(null);
    const [deleteModal, setDeleteModal] = useState({ open: false, tip: null });
    const [uploading, setUploading] = useState(false);
    const [formData, setFormData] = useState({
        title: '',
        shortDescription: '',
        icon: '♻️',
        category: 'Giấy',
        steps: [''],
        imageUrl: '',
    });

    useEffect(() => {
        fetchTips();
    }, []);

    const fetchTips = async () => {
        try {
            const snapshot = await getDocs(query(collection(db, 'tips'), orderBy('category')));
            setTips(snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })));
        } catch (error) {
            console.error('Error fetching tips:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleImageUpload = async (e) => {
        const file = e.target.files?.[0];
        if (!file) return;

        setUploading(true);
        try {
            const imageUrl = await uploadToCloudinary(file);
            setFormData({ ...formData, imageUrl });
        } catch (error) {
            alert('❌ Lỗi upload ảnh: ' + error.message);
        } finally {
            setUploading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        const tipData = {
            title: formData.title,
            shortDescription: formData.shortDescription,
            icon: formData.icon,
            category: formData.category,
            steps: formData.steps.filter(s => s.trim() !== ''),
            imageUrl: formData.imageUrl || '',
        };

        try {
            if (editingTip) {
                await updateDoc(doc(db, 'tips', editingTip.id), tipData);
            } else {
                await addDoc(collection(db, 'tips'), tipData);
            }
            await fetchTips();
            closeModal();
        } catch (error) {
            console.error('Error saving tip:', error);
            alert('❌ Lỗi lưu mẹo: ' + error.message);
        }
    };

    const openDeleteModal = (tip) => {
        setDeleteModal({ open: true, tip });
    };

    const closeDeleteModal = () => {
        setDeleteModal({ open: false, tip: null });
    };

    const handleDelete = async () => {
        if (!deleteModal.tip) return;

        try {
            await deleteDoc(doc(db, 'tips', deleteModal.tip.id));
            await fetchTips();
            closeDeleteModal();
        } catch (error) {
            console.error('Error deleting tip:', error);
            alert('❌ Lỗi khi xóa mẹo: ' + error.message);
        }
    };

    const openEditModal = (tip) => {
        setEditingTip(tip);
        setFormData({
            title: tip.title,
            shortDescription: tip.shortDescription,
            icon: tip.icon,
            category: tip.category,
            steps: tip.steps?.length > 0 ? tip.steps : [''],
            imageUrl: tip.imageUrl || '',
        });
        setShowModal(true);
    };

    const closeModal = () => {
        setShowModal(false);
        setEditingTip(null);
        setFormData({ title: '', shortDescription: '', icon: '♻️', category: 'Giấy', steps: [''], imageUrl: '' });
    };

    const addStep = () => {
        setFormData({ ...formData, steps: [...formData.steps, ''] });
    };

    const updateStep = (index, value) => {
        const newSteps = [...formData.steps];
        newSteps[index] = value;
        setFormData({ ...formData, steps: newSteps });
    };

    const removeStep = (index) => {
        if (formData.steps.length === 1) return;
        const newSteps = formData.steps.filter((_, i) => i !== index);
        setFormData({ ...formData, steps: newSteps });
    };

    // Group tips by category
    const groupedTips = tips.reduce((acc, tip) => {
        const cat = tip.category || 'Khác';
        if (!acc[cat]) acc[cat] = [];
        acc[cat].push(tip);
        return acc;
    }, {});

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
                    <h1 className="text-3xl font-bold text-gray-800">Quản lý mẹo xanh</h1>
                    <p className="text-gray-500 mt-1">Thêm và quản lý các mẹo môi trường</p>
                </div>
                <button
                    onClick={() => setShowModal(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors"
                >
                    <Plus className="w-5 h-5" />
                    <span>Thêm mẹo</span>
                </button>
            </div>

            {/* Tips by Category */}
            {Object.entries(groupedTips).map(([category, categoryTips]) => (
                <div key={category} className="mb-8">
                    <h2 className="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
                        <Lightbulb className="w-5 h-5 text-yellow-500" />
                        {category}
                        <span className="text-sm font-normal text-gray-500">({categoryTips.length} mẹo)</span>
                    </h2>
                    <div className="space-y-3">
                        {categoryTips.map((tip) => (
                            <div key={tip.id} className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                                <div
                                    className="p-4 flex items-center justify-between cursor-pointer hover:bg-gray-50"
                                    onClick={() => setExpandedTip(expandedTip === tip.id ? null : tip.id)}
                                >
                                    <div className="flex items-center gap-3">
                                        <span className="text-2xl">{tip.icon}</span>
                                        <div>
                                            <h3 className="font-medium text-gray-800">{tip.title}</h3>
                                            <p className="text-sm text-gray-500">{tip.shortDescription}</p>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <button
                                            onClick={(e) => { e.stopPropagation(); openEditModal(tip); }}
                                            className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                                        >
                                            <Edit2 className="w-4 h-4" />
                                        </button>
                                        <button
                                            onClick={(e) => { e.stopPropagation(); openDeleteModal(tip); }}
                                            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                        >
                                            <Trash2 className="w-4 h-4" />
                                        </button>
                                        {expandedTip === tip.id ? <ChevronUp className="w-5 h-5 text-gray-400" /> : <ChevronDown className="w-5 h-5 text-gray-400" />}
                                    </div>
                                </div>

                                {expandedTip === tip.id && tip.steps?.length > 0 && (
                                    <div className="px-4 pb-4 border-t border-gray-100 pt-3">
                                        <p className="text-sm font-medium text-gray-700 mb-2">Các bước thực hiện:</p>
                                        <ol className="list-decimal list-inside space-y-1 text-sm text-gray-600">
                                            {tip.steps.map((step, index) => (
                                                <li key={index}>{step}</li>
                                            ))}
                                        </ol>
                                    </div>
                                )}
                            </div>
                        ))}
                    </div>
                </div>
            ))}

            {tips.length === 0 && (
                <div className="text-center py-12 text-gray-500">
                    Chưa có mẹo nào. Nhấn "Thêm mẹo" để tạo mới.
                </div>
            )}

            {/* Modal */}
            {showModal && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-lg max-h-[90vh] overflow-y-auto">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-gray-800">
                                {editingTip ? 'Sửa mẹo' : 'Thêm mẹo mới'}
                            </h3>
                            <button onClick={closeModal} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Tiêu đề</label>
                                <input
                                    type="text"
                                    value={formData.title}
                                    onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none"
                                    required
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Mô tả ngắn</label>
                                <textarea
                                    value={formData.shortDescription}
                                    onChange={(e) => setFormData({ ...formData, shortDescription: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none resize-none"
                                    rows={2}
                                    required
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Danh mục</label>
                                <select
                                    value={formData.category}
                                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                                    className="w-full px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none"
                                >
                                    {CATEGORIES.map((cat) => (
                                        <option key={cat} value={cat}>{cat}</option>
                                    ))}
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">Icon</label>
                                <div className="flex flex-wrap gap-2">
                                    {ICONS.map((icon) => (
                                        <button
                                            key={icon}
                                            type="button"
                                            onClick={() => setFormData({ ...formData, icon })}
                                            className={`w-10 h-10 text-xl rounded-lg border-2 transition-colors ${formData.icon === icon ? 'border-green-500 bg-green-50' : 'border-gray-200'
                                                }`}
                                        >
                                            {icon}
                                        </button>
                                    ))}
                                </div>
                            </div>

                            {/* Image Upload */}
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    Ảnh minh họa (tùy chọn)
                                </label>
                                <div className="flex gap-4 items-start">
                                    {/* Preview */}
                                    <div className="w-24 h-24 rounded-xl border-2 border-dashed border-gray-300 flex items-center justify-center overflow-hidden bg-gray-50">
                                        {formData.imageUrl ? (
                                            <img
                                                src={formData.imageUrl}
                                                alt="Preview"
                                                className="w-full h-full object-cover"
                                            />
                                        ) : (
                                            <span className="text-4xl">{formData.icon}</span>
                                        )}
                                    </div>

                                    {/* Upload buttons */}
                                    <div className="flex-1 space-y-2">
                                        <label className={`flex items-center justify-center gap-2 px-4 py-3 border-2 border-dashed border-gray-300 rounded-xl cursor-pointer hover:border-green-500 hover:bg-green-50 transition-colors ${uploading ? 'opacity-50 cursor-not-allowed' : ''}`}>
                                            <input
                                                type="file"
                                                accept="image/*"
                                                onChange={handleImageUpload}
                                                disabled={uploading}
                                                className="hidden"
                                            />
                                            {uploading ? (
                                                <>
                                                    <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-green-500"></div>
                                                    <span className="text-gray-600">Đang upload...</span>
                                                </>
                                            ) : (
                                                <>
                                                    <Upload className="w-5 h-5 text-gray-500" />
                                                    <span className="text-gray-600">Chọn ảnh từ máy</span>
                                                </>
                                            )}
                                        </label>

                                        {formData.imageUrl && (
                                            <button
                                                type="button"
                                                onClick={() => setFormData({ ...formData, imageUrl: '' })}
                                                className="text-sm text-red-500 hover:text-red-700"
                                            >
                                                Xóa ảnh
                                            </button>
                                        )}

                                        <p className="text-xs text-gray-400">
                                            Nếu không có ảnh, sẽ hiển thị icon
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">Các bước thực hiện</label>
                                <div className="space-y-2">
                                    {formData.steps.map((step, index) => (
                                        <div key={index} className="flex gap-2">
                                            <input
                                                type="text"
                                                value={step}
                                                onChange={(e) => updateStep(index, e.target.value)}
                                                placeholder={`Bước ${index + 1}`}
                                                className="flex-1 px-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 outline-none"
                                            />
                                            {formData.steps.length > 1 && (
                                                <button
                                                    type="button"
                                                    onClick={() => removeStep(index)}
                                                    className="p-2 text-red-600 hover:bg-red-50 rounded-lg"
                                                >
                                                    <X className="w-4 h-4" />
                                                </button>
                                            )}
                                        </div>
                                    ))}
                                </div>
                                <button
                                    type="button"
                                    onClick={addStep}
                                    className="mt-2 text-sm text-green-600 hover:text-green-700"
                                >
                                    + Thêm bước
                                </button>
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
                                    {editingTip ? 'Cập nhật' : 'Thêm mới'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Delete Confirm Modal */}
            {deleteModal.open && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-2xl p-6 w-full max-w-md">
                        <div className="flex items-center justify-between mb-4">
                            <h3 className="text-lg font-semibold text-gray-800">Xác nhận xóa</h3>
                            <button onClick={closeDeleteModal} className="text-gray-400 hover:text-gray-600">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <div className="mb-6">
                            <div className="flex items-center gap-3 p-4 bg-red-50 rounded-xl mb-4">
                                <span className="text-3xl">{deleteModal.tip?.icon}</span>
                                <div>
                                    <p className="font-medium text-gray-800">{deleteModal.tip?.title}</p>
                                    <p className="text-sm text-gray-500">{deleteModal.tip?.category}</p>
                                </div>
                            </div>
                            <p className="text-gray-600">
                                Bạn có chắc chắn muốn xóa mẹo này? Hành động này không thể hoàn tác.
                            </p>
                        </div>

                        <div className="flex gap-3">
                            <button
                                onClick={closeDeleteModal}
                                className="flex-1 py-3 border border-gray-200 text-gray-600 rounded-xl hover:bg-gray-50 transition-colors"
                            >
                                Hủy
                            </button>
                            <button
                                onClick={handleDelete}
                                className="flex-1 py-3 bg-red-500 text-white rounded-xl hover:bg-red-600 transition-colors"
                            >
                                Xóa mẹo
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
