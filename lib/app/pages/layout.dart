import 'package:chat_diabetes/app/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 243, 230),
      body: Center(
        child: Row(
          children: [
            Container(
              color: const Color.fromARGB(255, 34, 34, 34),
              width: 200,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 80,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: ChatPage())
          ],
        ),
      ),
    );
  }
}
