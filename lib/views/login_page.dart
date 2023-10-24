import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_ui/system_message_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the SystemMessageProvider instance
    final systemMessageProvider =
        Provider.of<SystemMessageProvider>(context, listen: false);

    // Set the default system message
    systemMessageProvider.updateSystemMessage('You are a helpful assistant.');

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/chat');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
