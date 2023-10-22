import 'package:flutter/material.dart';
import 'package:mobile_ui/models/message.dart';
import 'package:mobile_ui/services/chat_service.dart';
import 'package:mobile_ui/views/widgets/message_bubble.dart';
import 'package:mobile_ui/views/widgets/chat_input.dart';
import 'sidebar.dart';
import 'package:provider/provider.dart';
import 'package:mobile_ui/system_message_provider.dart';

class ChatPage extends StatefulWidget {
<<<<<<< HEAD
  const ChatPage({Key? key}) : super(key: key);
=======
  const ChatPage({super.key});
>>>>>>> 91f88bf (Initial commit)

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final _chatService = ChatService();
  final _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _sidebarFocusNode = FocusNode();

<<<<<<< HEAD
  bool _isSending =
      false; // Add this variable to track if a message is being sent
=======
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }
>>>>>>> 91f88bf (Initial commit)

  void _sendMessage(String content) async {
    final userMessage = Message(sender: 'user', content: content);

    setState(() {
<<<<<<< HEAD
      _messages.add(userMessage);
      _isSending = true; // Set to true when a message is being sent
=======
>>>>>>> 91f88bf (Initial commit)
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });

    final botResponse = await _chatService.getBotResponse(_messages, content);
<<<<<<< HEAD

    final botMessage = Message(sender: 'assistant', content: botResponse);

    setState(() {
      _messages.add(botMessage);
      _isSending = false; // Set back to false when the message is sent
=======
    final botMessage = Message(sender: 'bot', content: botResponse);
    _messages.add(botMessage);

    setState(() {
>>>>>>> 91f88bf (Initial commit)
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
    final systemMessageProvider = Provider.of<SystemMessageProvider>(context);
    final systemMessage = systemMessageProvider.systemMessage;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inputFocusNode.requestFocus();
    });
    return Scaffold(
      appBar: AppBar(title: const Text('ChatBot')),
<<<<<<< HEAD
      drawer: Sidebar(
        onSystemMessageUpdated: (systemMessage) {
          systemMessageProvider.updateSystemMessage(systemMessage);
        },
      ),
=======
      drawer: const Sidebar(),
>>>>>>> 91f88bf (Initial commit)
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
