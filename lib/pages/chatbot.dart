import 'package:flutter/material.dart';
import 'package:diet_apps/controllers/chatbot_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final Chatbot chatbot = Chatbot();
  bool _isTyping = false;

  void _handleSend() async {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text;
    _controller.clear();

    setState(() {
      _messages.insert(0, ChatMessage(text: userText, isUser: true, timestamp: DateTime.now()));
      _isTyping = true; // Aktifkan animasi mengetik
    });

    // Panggil Service API
    String botResponse = await chatbot.askChatbot(userText);

    setState(() {
      _isTyping = false; // Matikan animasi
      _messages.insert(0, ChatMessage(text: botResponse, isUser: false, timestamp: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.android, color: Colors.white)),
            SizedBox(width: 10),
            Text("Chatkuy AI", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildChatBubble(_messages[index]),
            ),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  // --- WIDGET TYPING INDICATOR (Lebih Menarik) ---
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 15, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const SizedBox(
          width: 30,
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  // --- WIDGET CHAT BUBBLE ---
  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(msg.isUser ? 20 : 0),
            bottomRight: Radius.circular(msg.isUser ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  // --- WIDGET INPUT AREA ---
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Tanya sesuatu...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send_rounded, color: Colors.blueAccent, size: 30),
          ),
        ],
      ),
    );
  }
}