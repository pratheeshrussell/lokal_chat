import 'package:flutter/material.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:lokal_chat/pages/home.page.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
   Llama.libraryPath = 'libllama.so';

   runApp(const LokalChatApp());
}

class LokalChatApp extends StatelessWidget {
  const LokalChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokal Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}