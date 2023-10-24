import 'dart:convert';
import 'package:mobile_ui/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ui/views/sidebar.dart';

class ChatService {
  String systemMessage = 'You are a helpful very assistant.';

  final apiUrl =
      'https://hackathon2023-fraud-app.azurewebsites.net/chat_completion/';

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
      // Assign 'user' and 'assistant' roles appropriately
      String role = (message.sender == 'user') ? "user" : "assistant";
      messages.add({"role": role, "content": message.content});
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"messages": messages}),
    );

    print("Sent to API: ${jsonEncode({"messages": messages})}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("API response status code: ${response.statusCode}");

      // Modify this part based on the format of the API response you are getting
      return jsonResponse['response'];
    } else {
      print("API response error status code: ${response.statusCode}");
      return 'Error: Unable to fetch bot response.';
    }
  }

  String get getSystemMessage => systemMessage;
}
