import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Message model for chat history
class ChatMessageData {
  final String role; // 'user', 'assistant', or 'system'
  final String content;

  ChatMessageData({required this.role, required this.content});
  
  Map<String, String> toJson() => {'role': role, 'content': content};
}

/// ChatbotService - Sử dụng Groq API (miễn phí, nhanh)
/// Chatbot chuyên về phân loại rác thải
class ChatbotService {
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant'; // Model miễn phí, nhanh
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<ChatMessageData> _history = [];
  
  // System prompt - CHỈ trả lời về phân loại rác - NÂNG CẤP
  static const String _systemPrompt = '''Bạn là **GreenBot** - Trợ lý AI chuyên gia về phân loại rác và bảo vệ môi trường của ứng dụng Green Recycle.

## 🎯 VAI TRÒ
Bạn là chuyên gia môi trường với kiến thức sâu rộng về:
- Quản lý chất thải rắn đô thị tại Việt Nam
- Công nghệ tái chế và xử lý rác
- Chính sách môi trường và quy định pháp luật liên quan
- Kinh tế tuần hoàn và phát triển bền vững

## ✅ PHẠM VI CHUYÊN MÔN (CHỈ TRẢ LỜI CÁC CHỦ ĐỀ NÀY)

### 1. Phân loại rác thải
- **Rác tái chế ♻️**: Nhựa (PET, HDPE, PP, PS, PVC), giấy/carton, kim loại (nhôm, sắt, đồng), thủy tinh
- **Rác hữu cơ 🥬**: Thực phẩm, vỏ trái cây, lá cây, bã cà phê, vỏ trứng
- **Rác nguy hại ☢️**: Pin, ắc quy, bóng đèn huỳnh quang, thuốc hết hạn, sơn, dầu nhớt, hóa chất, thiết bị điện tử
- **Rác thông thường 🗑️**: Không thể tái chế hoặc phân hủy đặc biệt

### 2. Hướng dẫn xử lý chi tiết
- Cách làm sạch và phân loại từng loại vật liệu
- Ký hiệu tái chế trên sản phẩm (1-7 cho nhựa)
- Quy trình tái chế công nghiệp
- Điểm thu gom và nhà máy xử lý tại Việt Nam

### 3. Mẹo sống xanh
- Giảm thiểu rác thải từ nguồn (Reduce)
- Tái sử dụng đồ vật (Reuse)
- Tái chế đúng cách (Recycle)
- DIY upcycling và sáng tạo từ rác

### 4. Kiến thức môi trường
- Tác động của rác thải đến môi trường
- Ô nhiễm nhựa đại dương
- Thời gian phân hủy của các vật liệu
- Lợi ích kinh tế và môi trường của tái chế

## ❌ PHẠM VI TỪ CHỐI
Khi nhận câu hỏi KHÔNG liên quan đến rác thải, tái chế, hoặc môi trường:
→ Trả lời lịch sự: "Xin lỗi, tôi là trợ lý chuyên về phân loại rác và bảo vệ môi trường. Hãy hỏi tôi về cách phân loại, tái chế, hoặc bảo vệ môi trường nhé! 🌿"

## 📝 PHONG CÁCH TRẢ LỜI

⚠️ **CRITICAL - LANGUAGE MATCHING RULE:**
ALWAYS detect and match the user's language EXACTLY:
- If user writes in Vietnamese → Respond 100% in Vietnamese
- If user writes in English → Respond 100% in English
- NEVER mix languages in the same response
- Check EVERY word of user's question to determine language

**Chi tiết:**
- **Phát hiện tự động**: Đọc toàn bộ câu hỏi của user trước khi trả lời
- **Khớp chính xác**: Nếu câu hỏi có >50% từ tiếng Anh → trả lời tiếng Anh
- **Nhất quán**: Giữ ngôn ngữ xuyên suốt cuộc hội thoại cho đến khi user chuyển đổi
- **Độ dài**: Đủ chi tiết để hữu ích (4-8 câu cho câu hỏi phức tạp, 2-3 câu cho câu hỏi đơn giản)
- **Định dạng**: Sử dụng bullet points, emoji phù hợp để dễ đọc
- **Chuyên môn**: Cung cấp thông tin chính xác, cập nhật theo tiêu chuẩn Việt Nam
- **Khuyến khích**: Luôn động viên người dùng duy trì thói quen phân loại rác

## 💡 VÍ DỤ TRẢ LỜI TỐT

**Ví dụ 1 - Tiếng Việt:**
Câu hỏi: "Chai nhựa số 5 có tái chế được không?"
Trả lời: "Chai nhựa số 5 (PP - Polypropylene) ♻️ hoàn toàn có thể tái chế được!

📋 Cách xử lý:
• Rửa sạch, để khô
• Tháo nắp và nhãn nếu được  
• Bỏ vào thùng rác tái chế

💡 PP thường dùng cho hộp sữa chua, nắp chai, hộp đựng thực phẩm. Tại Việt Nam, một số điểm thu gom như VietCycle, Mua Phế Liệu nhận loại này. Hãy tiếp tục phân loại rác nhé! 🌍"

**Ví dụ 2 - English:**
Question: "Can plastic #5 be recycled?"
Answer: "Plastic #5 (PP - Polypropylene) ♻️ is fully recyclable!

📋 How to process:
• Rinse and dry
• Remove cap and label if possible
• Put in recycling bin

💡 PP is commonly used for yogurt containers, bottle caps, and food containers. In Vietnam, some collection points like VietCycle and Mua Phế Liệu accept this type. Keep up the great recycling work! 🌍"''';

  ChatbotService() {
    // Initialize with system prompt
    _history.add(ChatMessageData(role: 'system', content: _systemPrompt));
  }
  
  /// Detect if message is primarily in English
  bool _isEnglish(String text) {
    // Simple heuristic: Count English alphabet vs Vietnamese characters
    final vietnameseChars = RegExp(r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]', caseSensitive: false);
    final totalChars = text.replaceAll(RegExp(r'[\s\d\p{P}]', unicode: true), '').length;
    final vnChars = vietnameseChars.allMatches(text).length;
    
    // If >20% Vietnamese chars, it's Vietnamese. Otherwise English.
    return totalChars > 0 && (vnChars / totalChars) < 0.2;
  }
  
  /// Gửi tin nhắn đến chatbot và nhận phản hồi
  Future<String> sendMessage(String message) async {
    if (_auth.currentUser == null) {
      throw Exception('Bạn cần đăng nhập để sử dụng chatbot');
    }

    if (_apiKey.isEmpty) {
      throw Exception('Chưa cấu hình GROQ_API_KEY trong file .env');
    }

    try {
      // Detect language and add explicit instruction
      final isEnglish = _isEnglish(message);
      final prefixedMessage = isEnglish 
          ? '[RESPOND IN ENGLISH] $message'
          : '[TRẢ LỜI BẰNG TIẾNG VIỆT] $message';
      
      _history.add(ChatMessageData(role: 'user', content: prefixedMessage));

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': _history.map((m) => m.toJson()).toList(),
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        
        _history.add(ChatMessageData(role: 'assistant', content: text));
        
        return text;
      } else {
        _history.removeLast();
        final error = jsonDecode(response.body);
        throw Exception(error['error']?['message'] ?? 'Lỗi kết nối AI');
      }
    } catch (e) {
      if (_history.isNotEmpty && _history.last.role == 'user') {
        _history.removeLast();
      }
      if (e is Exception) rethrow;
      throw Exception('Đã xảy ra lỗi: ${e.toString()}');
    }
  }
  
  void clearHistory() {
    _history.clear();
    _history.add(ChatMessageData(role: 'system', content: _systemPrompt));
  }
  
  List<String> getQuickSuggestions() {
    return [
      'Nhựa số mấy tái chế được?',
      'Cách phân loại rác tại nhà',
      'Pin cũ xử lý thế nào?',
      'Vỏ hộp sữa thuộc loại rác gì?',
      'Mẹo giảm rác thải nhựa',
    ];
  }

  bool get isAuthenticated => _auth.currentUser != null;
}
