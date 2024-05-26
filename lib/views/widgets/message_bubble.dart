import 'package:flutter/material.dart';
import 'package:mobile_ui/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color botColor = Colors.transparent;
    Color textColor = Colors.white; // isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: message.sender == 'user'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.sender == 'bot') ...[
            CircleAvatar(
              backgroundColor: isDarkMode ? Colors.grey[600] : Colors.grey[300],
              child: const Icon(Icons.android),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: message.sender == 'user'
                    ? Colors.grey[850]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Roboto',
                ),
                textAlign:
                    message.sender == 'user' ? TextAlign.right : TextAlign.left,
              ),
            ),
          ),
          if (message.sender == 'user') ...[
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: isDarkMode ? Colors.blueGrey : Colors.blue[200],
              child: const Icon(Icons.person),
            ),
          ],
        ],
      ),
    );
  }
}
