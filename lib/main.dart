import 'package:flutter/material.dart';
import 'package:mobile_ui/views/login_page.dart';
import 'package:mobile_ui/views/chat_page.dart';
import 'package:mobile_ui/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'system_message_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // ...existing code...
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (_) => SystemMessageProvider(),
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
      title: 'DolumGuard AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      routes: {'/chat': (context) => const ChatPage()},
    );
  }
}
