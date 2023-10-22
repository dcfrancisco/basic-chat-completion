import 'package:flutter/material.dart';
import 'package:mobile_ui/views/login_page.dart';
import 'package:mobile_ui/views/chat_page.dart';
import 'package:provider/provider.dart';
import 'system_message_provider.dart';

// Light and Dark ThemeData
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

<<<<<<< HEAD
void main() => runApp(
      ChangeNotifierProvider(
        create: (context) =>
            SystemMessageProvider(), // Create an instance of your provider
        child: const MyApp(),
      ),
    );
=======
void main() => runApp(const MyApp());
>>>>>>> 91f88bf (Initial commit)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBot App',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      routes: {
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}
