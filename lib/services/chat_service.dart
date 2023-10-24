import 'dart:convert';
import 'package:mobile_ui/models/message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final apiUrl =
      'https://hackathon2023-fraud-app.azurewebsites.net/chat_completion/';

  Future<String> getBotResponse(
      List<Message> systemMessages, String userInput) async {
    List<Map<String, String>> messages = [];

    // Add system messages
    for (var message in systemMessages) {
      messages.add({"role": "system", "content": message.content});
    }

    // Add user input
    messages.add({"role": "user", "content": userInput});

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"messages": messages}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("API response status code: ${response.statusCode}");

      // Assuming your API returns the bot response in a key named 'content' inside the last message object
      return jsonResponse['messages'].last['content'];
    } else {
      // Handle the error here. You can show a default error message or return the actual error.
      return 'Error: Unable to fetch bot response.';
    }
  }
}
