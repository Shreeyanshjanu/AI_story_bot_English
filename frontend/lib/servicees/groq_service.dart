import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> generateStory(String userPrompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a creative storyteller. Always write stories in English. '
                  'Stories should be 500-800 words, engaging, vivid, with a clear '
                  'beginning, middle, and end. Use descriptive language that paints '
                  'a picture. Only return the story text, nothing else.',
            },
            {
              'role': 'user',
              'content':
                  'Write a creative and engaging English story based on this idea: '
                  '$userPrompt. The story should have a clear beginning, middle, '
                  'and ending and be easy to listen to. Only return the story text.',
            },
          ],
          'temperature': 0.8,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ??
            'Could not generate story.';
      } else {
        throw Exception('Groq error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Story generation failed: $e');
    }
  }
}