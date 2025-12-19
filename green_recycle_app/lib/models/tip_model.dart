import 'package:flutter/material.dart';

class TipModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final Color categoryColor;
  final List<String> steps;

  const TipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.categoryColor,
    this.steps = const [],
  });
}

// Dữ liệu tips mẫu
class TipsData {
  static const List<TipModel> allTips = [
    // Giấy
    TipModel(
      id: '1',
      title: 'Vỏ hộp sữa giấy',
      description: 'Rửa sạch bên trong, bóp dẹp và gấp gọn trước khi bỏ thùng tái chế.',
      imageUrl: 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=400',
      category: 'Giấy',
      categoryColor: Color(0xFF4CAF50),
      steps: [
        'Mở nắp hộp sữa, đổ hết phần sữa còn lại',
        'Rửa sạch bên trong bằng nước',
        'Để khô tự nhiên hoặc lau khô',
        'Bóp dẹp hộp để tiết kiệm không gian',
        'Bỏ vào thùng tái chế giấy',
      ],
    ),
    TipModel(
      id: '2',
      title: 'Hộp carton',
      description: 'Tháo rời các lớp băng keo, gấp phẳng trước khi tái chế.',
      imageUrl: 'https://images.unsplash.com/photo-1607166452427-7e4477079cb9?w=400',
      category: 'Giấy',
      categoryColor: Color(0xFF4CAF50),
      steps: [
        'Tháo bỏ băng keo và nhãn dán nếu có',
        'Gỡ bỏ các vật liệu khác như xốp, nilon',
        'Gấp phẳng hộp carton',
        'Buộc gọn hoặc xếp chồng lên nhau',
        'Mang đến điểm thu gom hoặc bỏ thùng tái chế',
      ],
    ),
    
    // Nguy hại
    TipModel(
      id: '3',
      title: 'Pin cũ & Ắc quy',
      description: 'Tuyệt đối không vứt chung rác thải. Hãy mang đến điểm thu gom riêng.',
      imageUrl: 'https://images.unsplash.com/photo-1619641805634-98e027c16795?w=400',
      category: 'Nguy hại',
      categoryColor: Color(0xFFF44336),
      steps: [
        'KHÔNG vứt pin vào thùng rác thông thường',
        'Bọc pin bằng băng keo ở hai đầu để tránh chập điện',
        'Để riêng trong hộp nhựa hoặc túi zip',
        'Tìm điểm thu gom pin cũ gần nhất',
        'Mang đến siêu thị điện máy hoặc điểm thu gom chuyên dụng',
      ],
    ),
    TipModel(
      id: '4',
      title: 'Bóng đèn huỳnh quang',
      description: 'Chứa thủy ngân độc hại. Bọc cẩn thận và mang đến điểm thu gom chuyên dụng.',
      imageUrl: 'https://images.unsplash.com/photo-1532186651327-6ac23687d189?w=400',
      category: 'Nguy hại',
      categoryColor: Color(0xFFF44336),
      steps: [
        'Cẩn thận tháo bóng đèn, tránh làm vỡ',
        'Bọc bóng đèn bằng giấy báo hoặc bìa carton',
        'Đặt vào hộp cứng để tránh vỡ khi vận chuyển',
        'Dán nhãn "Nguy hại - Dễ vỡ"',
        'Mang đến điểm thu gom rác thải nguy hại',
      ],
    ),
    TipModel(
      id: '5',
      title: 'Thuốc hết hạn',
      description: 'Không xả xuống bồn cầu. Mang đến nhà thuốc hoặc cơ sở y tế để xử lý.',
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
      category: 'Nguy hại',
      categoryColor: Color(0xFFF44336),
      steps: [
        'Kiểm tra hạn sử dụng trên bao bì',
        'KHÔNG xả thuốc xuống bồn cầu hoặc bồn rửa',
        'Để thuốc trong bao bì gốc',
        'Mang đến nhà thuốc hoặc bệnh viện gần nhất',
        'Yêu cầu họ tiêu hủy đúng cách',
      ],
    ),
    
    // Tái chế
    TipModel(
      id: '6',
      title: 'Chai nhựa PET',
      description: 'Rửa sạch, bóp dẹp và tháo nắp trước khi bỏ vào thùng tái chế.',
      imageUrl: 'https://images.unsplash.com/photo-1602280673995-5eb9b80c0c7b?w=400',
      category: 'Tái chế',
      categoryColor: Color(0xFF2196F3),
      steps: [
        'Đổ hết nước và thức uống còn lại',
        'Rửa sạch bên trong chai',
        'Tháo nắp và nhãn dán (nếu có thể)',
        'Bóp dẹp chai để tiết kiệm không gian',
        'Bỏ vào thùng rác tái chế nhựa',
      ],
    ),
    TipModel(
      id: '7',
      title: 'Lon nhôm',
      description: 'Rửa sạch và bóp dẹp. Lon nhôm có thể tái chế vô hạn lần.',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      category: 'Tái chế',
      categoryColor: Color(0xFF2196F3),
      steps: [
        'Đổ hết đồ uống còn lại',
        'Rửa sạch bên trong lon',
        'Bóp dẹp lon để tiết kiệm không gian',
        'Thu gom riêng với các lon khác',
        'Bán ve chai hoặc bỏ thùng tái chế kim loại',
      ],
    ),
    TipModel(
      id: '8',
      title: 'Chai thủy tinh',
      description: 'Rửa sạch, tháo nắp kim loại. Phân loại theo màu nếu có thể.',
      imageUrl: 'https://images.unsplash.com/photo-1605457212508-13e1f5ac57fb?w=400',
      category: 'Tái chế',
      categoryColor: Color(0xFF2196F3),
      steps: [
        'Đổ hết nội dung bên trong',
        'Rửa sạch chai thủy tinh',
        'Tháo nắp kim loại hoặc nhựa riêng',
        'Phân loại theo màu: trong, xanh, nâu',
        'Bỏ vào thùng tái chế thủy tinh hoặc bán ve chai',
      ],
    ),
    
    // Hữu cơ
    TipModel(
      id: '9',
      title: 'Thức ăn thừa',
      description: 'Có thể ủ làm phân compost. Tránh để lẫn với túi nilon.',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      category: 'Hữu cơ',
      categoryColor: Color(0xFF8BC34A),
      steps: [
        'Phân loại thức ăn thừa riêng với rác khác',
        'Loại bỏ các bao bì nhựa, giấy bọc',
        'Cắt nhỏ thức ăn để phân hủy nhanh hơn',
        'Bỏ vào thùng rác hữu cơ hoặc thùng ủ compost',
        'Nếu ủ compost: trộn với lá khô theo tỷ lệ 1:3',
      ],
    ),
    TipModel(
      id: '10',
      title: 'Vỏ trái cây',
      description: 'Rất tốt để làm phân bón. Cắt nhỏ để phân hủy nhanh hơn.',
      imageUrl: 'https://images.unsplash.com/photo-1457296898342-cdd24585d095?w=400',
      category: 'Hữu cơ',
      categoryColor: Color(0xFF8BC34A),
      steps: [
        'Thu gom vỏ trái cây riêng',
        'Cắt nhỏ vỏ để phân hủy nhanh hơn',
        'Bỏ vào thùng rác hữu cơ',
        'Hoặc ủ làm phân compost cho cây trồng',
        'Tránh để lẫn với nhãn dán và túi nilon',
      ],
    ),
    TipModel(
      id: '11',
      title: 'Lá cây khô',
      description: 'Thu gom để ủ compost hoặc làm lớp phủ cho vườn cây.',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      category: 'Hữu cơ',
      categoryColor: Color(0xFF8BC34A),
      steps: [
        'Thu gom lá cây khô vào bao hoặc thùng',
        'Loại bỏ cành cây lớn và đá',
        'Có thể nghiền nhỏ để phân hủy nhanh',
        'Trộn với rác hữu cơ khác để ủ compost',
        'Hoặc dùng làm lớp phủ cho gốc cây',
      ],
    ),
    
    // Điện tử
    TipModel(
      id: '12',
      title: 'Điện thoại cũ',
      description: 'Xóa dữ liệu cá nhân trước khi mang đến điểm thu gom rác điện tử.',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
      category: 'Điện tử',
      categoryColor: Color(0xFF9C27B0),
      steps: [
        'Sao lưu dữ liệu quan trọng',
        'Đăng xuất tất cả tài khoản',
        'Xóa sạch dữ liệu (Factory Reset)',
        'Tháo SIM và thẻ nhớ ra',
        'Mang đến điểm thu gom e-waste hoặc cửa hàng điện thoại',
      ],
    ),
    TipModel(
      id: '13',
      title: 'Máy tính cũ',
      description: 'Tháo pin riêng. Liên hệ nhà sản xuất hoặc điểm thu gom e-waste.',
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
      category: 'Điện tử',
      categoryColor: Color(0xFF9C27B0),
      steps: [
        'Sao lưu và xóa sạch dữ liệu ổ cứng',
        'Tháo pin laptop ra (nếu có)',
        'Tháo ổ cứng nếu chứa dữ liệu nhạy cảm',
        'Liên hệ nhà sản xuất về chương trình thu hồi',
        'Hoặc mang đến điểm thu gom rác điện tử',
      ],
    ),
  ];

  // Lấy tips featured cho trang chủ (4-5 tips)
  static List<TipModel> get featuredTips => allTips.take(5).toList();

  // Lấy tips theo category
  static List<TipModel> getTipsByCategory(String category) {
    return allTips.where((tip) => tip.category == category).toList();
  }

  // Lấy danh sách categories duy nhất
  static List<String> get categories {
    return allTips.map((tip) => tip.category).toSet().toList();
  }
}

