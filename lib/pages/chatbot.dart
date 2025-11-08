import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text("Chatbot", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)),
            ),
            
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            label: Text("silahkan tanya tanya disini"),
          ),
        ),
      ),
    );
  }
}