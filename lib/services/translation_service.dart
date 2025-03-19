import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _apiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
  static const String _baseUrl =
      'https://translation.googleapis.com/language/translate/v2';

  static Future<String> translateToFilipino(String text) async {
    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
      body: {'q': text, 'source': 'en', 'target': 'tl', 'format': 'text'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Failed to translate text');
    }
  }
}
