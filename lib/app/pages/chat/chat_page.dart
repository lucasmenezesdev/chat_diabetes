import 'package:chat_diabetes/app/pages/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Column(
                children: [
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                ],
              ),
              controller: controller.scrollController,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: controller.messages[index].isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: controller.messages[index].isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.messages[index].isUser ? "Você" : "Bot",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            controller.messages[index].text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    if (index == controller.messages.length - 1 &&
                        controller.isLoading == true)
                      const Column(
                        children: [
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0d77cd),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Digitando...',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 40, right: 40, bottom: 40, top: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onSubmitted: (_) {
                      controller.sendMessage(
                          text: controller.inputController.text);
                    },
                    controller: controller.inputController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Digite sua mensagem",
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.mic,
                                color: controller.isRecording == true
                                    ? Colors.red
                                    : Colors.white),
                            onPressed: () async {
                              controller.isRecording == true
                                  ? await controller.stopRecording()
                                  : controller.startRecording();

                              if (controller.isRecording == false) {
                                // controller.playAudio();
                                controller.sendAudio();

                                // print(controller.audioData);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0d77cd),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () {
                                controller.sendMessage(
                                    text: controller.inputController.text);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
