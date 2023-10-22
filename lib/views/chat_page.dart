import 'package:flutter/material.dart';
import 'package:mobile_ui/models/message.dart';
import 'package:mobile_ui/services/chat_service.dart';
import 'package:mobile_ui/views/widgets/message_bubble.dart';
import 'package:mobile_ui/views/widgets/chat_input.dart';
import 'sidebar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final _chatService = ChatService();
  final _scrollController = ScrollController();

  final FocusNode _inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage(String content) async {
    final userMessage = Message(sender: 'user', content: content);
    _messages.add(userMessage);

    setState(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });

    final botResponse = await _chatService.getBotResponse(_messages, content);
    final botMessage = Message(sender: 'bot', content: botResponse);
    _messages.add(botMessage);

    setState(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  void _focusInput() {
    FocusScope.of(context).requestFocus(_inputFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inputFocusNode.requestFocus();
    });
    return Scaffold(
      appBar: AppBar(title: const Text('ChatBot')),
      drawer: const Sidebar(),
      body: Container(
        color: Colors.blueGrey[900],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (ctx, index) =>
                    MessageBubble(message: _messages[index]),
                padding: const EdgeInsets.only(top: 8.0, bottom: 60.0),
              ),
            ),
            ChatInput(onSend: _sendMessage, focusNode: _inputFocusNode),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
