import 'package:flutter/material.dart';
import 'package:mobile_ui/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color botColor = Colors.transparent;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: message.sender == 'user'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.sender == 'bot') ...[
            CircleAvatar(
              child: Icon(Icons.android),
              backgroundColor: isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
            SizedBox(width: 10),
          ],
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: message.sender == 'user'
                    ? Colors.grey[850]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                message.content,
                style: TextStyle(color: textColor),
                textAlign:
                    message.sender == 'user' ? TextAlign.right : TextAlign.left,
              ),
            ),
          ),
          if (message.sender == 'user') ...[
            SizedBox(width: 10),
            CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: isDarkMode ? Colors.blueGrey : Colors.blue[200],
            ),
          ],
        ],
      ),
    );
  }
}
