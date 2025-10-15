import 'package:flutter/material.dart';
import 'package:mobile_ui/models/message.dart';
import 'package:mobile_ui/services/chat_service.dart';
import 'package:mobile_ui/views/widgets/message_bubble.dart';
import 'package:mobile_ui/views/widgets/chat_input.dart';
import 'sidebar.dart';
import 'package:provider/provider.dart';
import 'package:mobile_ui/system_message_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final _chatService = ChatService();
  final _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _inputFocusNode.requestFocus(),
    );
  }

  void _sendMessage(String content) async {
    final systemMessageProvider = Provider.of<SystemMessageProvider>(
      context,
      listen: false,
    );
    final userMessage = Message(sender: 'user', content: content);

    setState(() {
      _messages.add(userMessage);
      _scrollToBottom();
    });

    final botResponse = await _chatService.getBotResponse(
      _messages,
      content,
      systemMessageProvider.systemMessage,
      systemMessageProvider.apiSettings,
    );

    final botMessage = Message(sender: 'assistant', content: botResponse);

    setState(() {
      _messages.add(botMessage);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    // A small delay ensures the list has been updated before scrolling.
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemMessageProvider>(
      builder: (context, systemMessageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DolumGuard AI'),
                Text(
                  'Persona: ${systemMessageProvider.selectedPersona}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          drawer: Sidebar(
            onSystemMessageUpdated: (systemMessage) {
              // This callback is now handled directly by the provider,
              // but we keep it in case of future need.
            },
          ),
          body: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (ctx, index) =>
                        MessageBubble(message: _messages[index]),
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  ),
                ),
                ChatInput(onSend: _sendMessage, focusNode: _inputFocusNode),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }
}
