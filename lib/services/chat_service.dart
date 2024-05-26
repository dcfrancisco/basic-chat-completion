import 'dart:convert';
import 'package:mobile_ui/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  String systemMessage = 'You are a helpful assistant.';

  final String apiUrl = dotenv.env['OPENAI_API_URL'] ?? '';
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  void updateSystemMessage(String message) {
    systemMessage = message;
  }

  Future<String> getBotResponse(
      List<Message> chatHistory, String userInput) async {
    List<Map<String, String>> messages = [];

    print("chatHistory received length: ${chatHistory.length}");
    print("Sidebar system message: $systemMessage");

    messages.add({"role": "system", "content": "You are a helpful assistant."});
    messages.add({"role": "system", "content": "You are dolumGuard."});
    messages.add({
      "role": "system",
      "content":
          "Our slogan is Part Man, Part Machine, All Security: DolumGuard's Got You Covered!"
    });

    for (var message in chatHistory) {
      String role = (message.sender == 'user') ? "user" : "assistant";
      messages.add({"role": role, "content": message.content});
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": messages,
        "temperature": 1,
        "max_tokens": 123,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      }),
    );

    print("Sent to API: ${jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
          "temperature": 1,
          "max_tokens": 123,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0,
        })}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print("API response status code: ${response.statusCode}");
      print(jsonResponse);
      return jsonResponse['choices'][0]['message']['content'];
    } else {
      print("API response error status code: ${response.statusCode}");
      return 'Error: Unable to fetch bot response.';
    }
  }

  String get getSystemMessage => systemMessage;
}
