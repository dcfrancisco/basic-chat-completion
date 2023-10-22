import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final FocusNode focusNode;

  const ChatInput({super.key, required this.onSend, required this.focusNode});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();

  void _submit() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200] // Light theme
              : Colors.grey[800], // Dark theme
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(),
                focusNode: widget.focusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Send a message...',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submit,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.blue // Light theme
                  : Colors.blueAccent, // Dark theme
              hoverColor: Colors.transparent,
              splashRadius: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
