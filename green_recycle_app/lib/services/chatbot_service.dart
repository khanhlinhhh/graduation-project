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
  
  // System prompt - CHỈ trả lời về phân loại rác
  static const String _systemPrompt = '''Bạn là GreenBot - trợ lý phân loại rác của ứng dụng Green Recycle.

🎯 NHIỆM VỤ DUY NHẤT: Hỗ trợ người dùng về phân loại rác và tái chế.

✅ BẠN CHỈ ĐƯỢC TRẢ LỜI các câu hỏi về:
- Cách phân loại rác (tái chế ♻️, hữu cơ 🥬, nguy hại ☢️, thông thường 🗑️)
- Vật liệu nào có thể tái chế (nhựa, giấy, kim loại, thủy tinh...)
- Cách xử lý rác nguy hại (pin, bóng đèn, thuốc hết hạn...)
- Điểm thu gom rác tái chế
- Mẹo giảm thiểu rác thải

❌ TỪ CHỐI LỊCH SỰ các câu hỏi KHÔNG liên quan đến rác/tái chế.
Khi nhận câu hỏi không liên quan, trả lời: "Xin lỗi, tôi chỉ có thể hỗ trợ về phân loại rác và tái chế thôi ạ! 🌿"

📝 QUY TẮC:
- Luôn trả lời bằng tiếng Việt
- Ngắn gọn, dễ hiểu (tối đa 3-4 câu)
- Sử dụng emoji phù hợp''';

  ChatbotService() {
    // Initialize with system prompt
    _history.add(ChatMessageData(role: 'system', content: _systemPrompt));
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
      _history.add(ChatMessageData(role: 'user', content: message));

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
      'Chai nhựa bỏ ở đâu?',
      'Làm sao phân loại rác?',
      'Pin cũ xử lý thế nào?',
      'Mẹo giảm rác thải',
    ];
  }

  bool get isAuthenticated => _auth.currentUser != null;
}
