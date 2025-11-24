import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CouldAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EA),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatScreen(),
      },
    );
  }
}
