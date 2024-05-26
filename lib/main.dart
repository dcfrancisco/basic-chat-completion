import 'package:flutter/material.dart';
import 'package:mobile_ui/views/login_page.dart';
import 'package:mobile_ui/views/chat_page.dart';
import 'package:provider/provider.dart';
import 'system_message_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Light and Dark ThemeData
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  fontFamily: 'Roboto',
);

final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  fontFamily: 'Roboto',
);

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => SystemMessageProvider(),
      child: const MyApp(),
    ),
  );
}

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
