import 'package:chat_diabetes/app/pages/chat/chat_page.dart';
import 'package:chat_diabetes/app/pages/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 34, 34),
          background: Color.fromARGB(255, 61, 61, 61),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Layout(),
    );
  }
}
