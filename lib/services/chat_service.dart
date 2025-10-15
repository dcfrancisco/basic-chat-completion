import 'dart:convert';
import 'package:mobile_ui/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String apiUrl = dotenv.env['OPENAI_API_URL'] ?? '';
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  Future<String> _getEffectiveApiKey() async {
    // Prefer dotenv value; otherwise fall back to client-saved key in prefs.
    final envKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (envKey.isNotEmpty) return envKey;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_api_key') ?? '';
  }

  Future<String> getBotResponse(
    List<Message> chatHistory,
    String userInput,
    String systemMessage,
    Map<String, dynamic> settings,
  ) async {
    List<Map<String, String>> messages = [];

    // Use the provided system message from SystemMessageProvider
    messages.add({"role": "system", "content": systemMessage});

    for (var message in chatHistory) {
      String role = (message.sender == 'user') ? "user" : "assistant";
      messages.add({"role": role, "content": message.content});
    }

    // Defensive: if the latest userInput is not present in chatHistory (for
    // example, the caller passed the content separately), ensure it's included
    // as the last user message so the API sees the user's request.
    if (userInput.isNotEmpty) {
      final hasLatest =
          chatHistory.isNotEmpty &&
          chatHistory.last.sender == 'user' &&
          chatHistory.last.content == userInput;
      if (!hasLatest) {
        messages.add({"role": "user", "content": userInput});
      }
    }
    // Merge settings with defaults
    final payload = {
      "model": settings['model'] ?? 'gpt-3.5-turbo',
      "messages": messages,
      "temperature": settings['temperature'] ?? 1,
      "max_tokens": settings['max_tokens'] ?? 123,
      "top_p": settings['top_p'] ?? 1,
      "frequency_penalty": settings['frequency_penalty'] ?? 0,
      "presence_penalty": settings['presence_penalty'] ?? 0,
    };

    // Basic validation before sending the request
    if (apiUrl.isEmpty) {
      return 'Error: OPENAI_API_URL is not set.';
    }
    final effectiveApiKey = await _getEffectiveApiKey();
    if (effectiveApiKey.isEmpty) {
      return 'Error: OPENAI_API_KEY is not set.';
    }
    final uri = Uri.tryParse(apiUrl);
    if (uri == null ||
        !(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      return 'Error: OPENAI_API_URL is invalid: $apiUrl';
    }

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $effectiveApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(responseBody);
          // Handle chat-completions style responses
          if (jsonResponse is Map && jsonResponse['choices'] != null) {
            final choice = jsonResponse['choices'][0];
            if (choice is Map && choice['message'] != null) {
              return choice['message']['content'] ?? '';
            }
            // fallback to 'text' field
            return choice['text'] ?? jsonResponse.toString();
          }
          // Unknown but valid JSON response
          return jsonResponse.toString();
        } catch (e) {
          // Response not JSON
          return 'Error: Unable to parse API response as JSON. Raw response: $responseBody';
        }
      }

      // Non-200 response
      return 'Error ${response.statusCode}: ${responseBody}';
    } catch (e) {
      return 'Error: Exception while calling API: $e';
    }
  }

  /// Lightweight test to verify API reachability and basic auth.
  /// Sends a minimal request (if URL accepts GET returns quick, otherwise
  /// sends a small POST payload) and returns a human-readable result.
  Future<String> testConnection() async {
    if (apiUrl.isEmpty) return 'Error: OPENAI_API_URL is not set.';
    final effectiveApiKey = await _getEffectiveApiKey();
    if (effectiveApiKey.isEmpty) return 'Error: OPENAI_API_KEY is not set.';
    final uri = Uri.tryParse(apiUrl);
    if (uri == null) return 'Error: OPENAI_API_URL is invalid.';

    try {
      // Try GET first (some proxy endpoints may respond to GET for health).
      final getResp = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $effectiveApiKey'},
      );
      if (getResp.statusCode >= 200 && getResp.statusCode < 300) {
        return 'OK (${getResp.statusCode}): ${getResp.reasonPhrase ?? ''}';
      }

      // If GET is not accepted, send a very small POST similar to chat.
      final payload = jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'healthcheck'},
          {'role': 'user', 'content': 'ping'},
        ],
        'max_tokens': 1,
      });

      final postResp = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $effectiveApiKey',
          'Content-Type': 'application/json',
        },
        body: payload,
      );

      final body = postResp.body;
      if (postResp.statusCode >= 200 && postResp.statusCode < 300) {
        return 'OK (${postResp.statusCode})';
      }
      return 'Error ${postResp.statusCode}: ${body}';
    } catch (e) {
      return 'Error: Exception while testing connection: $e';
    }
  }
}
