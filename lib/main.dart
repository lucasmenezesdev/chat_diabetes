import 'package:chat_diabetes/app/app.dart';
import 'package:chat_diabetes/app/pages/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ChatController(),
    ),
  ], child: const MyApp()));
}
