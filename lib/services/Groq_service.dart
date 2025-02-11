import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqService {
  final String? apiKey = dotenv.env['Groq_Api'];
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<String?> sendMessage(String message) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['choices'][0]['message']['content'];
      } else {
        print("Error: ${response.reasonPhrase}");
        return "Failed to get response.";
      }
    } catch (e) {
      print("Exception: $e");
      return "Error: $e";
    }
  }
}
