import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('❌ Error: .env file not found');
    return;
  }

  final lines = await envFile.readAsLines();
  String? apiKey;
  
  for (var line in lines) {
    if (line.trim().startsWith('GEMINI_API_KEY=')) {
      apiKey = line.split('=')[1].trim();
      break;
    }
  }

  if (apiKey == null || apiKey.isEmpty) {
    print('❌ Error: GEMINI_API_KEY not found in .env');
    return;
  }

  print('🔑 API Key found: ${apiKey.substring(0, 5)}...${apiKey.substring(apiKey.length - 4)}');
  print('🔍 Checking available models...');

  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final models = data['models'] as List;

      print('\n✅ Available Models for your key:');
      for (var model in models) {
        final name = model['name'];
        final supportedMethods = model['supportedGenerationMethods'] as List;
        if (supportedMethods.contains('generateContent')) {
          print('  - $name');
        }
      }
    } else {
      print('\n❌ Error fetching models:');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  } catch (e) {
    print('\n❌ Exception: $e');
  }
}

