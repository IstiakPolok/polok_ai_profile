import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile_data.dart';

class GeminiService {
  final String apiKey;
  final List<Map<String, String>> _chatHistory = [];

  GeminiService(this.apiKey);

  Future<String> sendMessage(String message) async {
    try {
      if (apiKey == "YOUR_GROQ_API_KEY_HERE" || apiKey.isEmpty) {
        return "⚠️ API Key Missing: Please add your Groq API key to the `.env` file.\n\n"
            "1. Go to console.groq.com\n"
            "2. Create an API key\n"
            "3. Paste it in `.env` like this:\n"
            "   GEMINI_API_KEY=gsk_...\n\n"
            "Then restart the app!";
      }

      // Create a focused prompt with profile info and the question
      final profileContext = ProfileData.getProfileContext();
      final prompt =
          '''You are answering questions about ${ProfileData.name}, a Flutter Developer.

$profileContext

Question: $message

Provide a brief, professional answer based on the profile information provided above. If asked about social media or projects, refer to the details in the profile.''';

      // Send a simple request without chat history to avoid token limits
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiMessage = data['choices'][0]['message']['content'];
        return aiMessage;
      } else {
        // Log error details
        final errorBody = response.body;
        print('Error ${response.statusCode}: $errorBody');
        return 'Sorry, I couldn\'t generate a response. Status: ${response.statusCode}\nError: $errorBody';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  void resetChat() {
    _chatHistory.clear();
  }
}
