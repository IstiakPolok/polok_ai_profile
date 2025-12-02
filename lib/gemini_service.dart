import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile_data.dart';

class GeminiService {
  final String apiKey;
  final List<Map<String, String>> _chatHistory = [];

  GeminiService(this.apiKey);

  Future<String> sendMessage(String message) async {
    try {
      // Create a focused prompt with profile info and the question
      final prompt =
          '''You are answering questions about ${ProfileData.name}, a Flutter Developer.

Profile Summary:
- Name: ${ProfileData.name}
- Title: ${ProfileData.title}
- Location: ${ProfileData.location}
- Skills: Flutter, Dart, JavaScript, REST APIs, Firebase, and more
- Current Role: Flutter Developer at Join Venture AI
- Notable Project: Goliaths app (on Google Play Store)

Question: $message

Provide a brief, professional answer based on the profile information.''';

      // Send a simple request without chat history to avoid token limits
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
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
