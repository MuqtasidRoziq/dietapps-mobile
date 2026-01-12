import 'package:flutter/material.dart';

// 1. Model Sederhana untuk Pesan
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text, 
    required this.isUser, 
    required this.timestamp
  });
}

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = []; // Tempat menyimpan chat sementara

  // Data Dummy untuk respon Bot
  final Map<String, String> _botResponses = {
    "halo": "Halo juga! Ada yang bisa saya bantu?",
    "siapa": "Saya adalah Chatkuy, asisten virtual pintarmu.",
    "bantuan": "Anda bisa bertanya apa saja kepada saya.",
    "default": "Maaf, saya belum mengerti maksud Anda. Bisa diulangi?"
  };

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;

    // Tambah pesan user
    setState(() {
      _messages.insert(0, ChatMessage(
        text: _controller.text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    String userText = _controller.text.toLowerCase();
    _controller.clear();

    // Simulasi delay bot berpikir
    Future.delayed(const Duration(milliseconds: 800), () {
      String response = _botResponses.entries
          .firstWhere((e) => userText.contains(e.key), 
          orElse: () => MapEntry("", _botResponses["default"]!))
          .value;

      setState(() {
        _messages.insert(0, ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      
      // Di sini nanti Anda bisa menambahkan logika JWT & Shared Preferences
      // untuk menyimpan history chat ini secara aman.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text(
          "Chatkuy",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 2. Area Pesan (ListView)
          Expanded(
            child: ListView.builder(
              reverse: true, // Agar chat terbaru ada di bawah
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),
          
          // Input Area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _handleSend(),
                      decoration: InputDecoration(
                        hintText: "Silakan tanya di sini...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _handleSend,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Widget Bubble Chat
  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blue[400] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(msg.isUser ? 15 : 0),
            bottomRight: Radius.circular(msg.isUser ? 0 : 15),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}