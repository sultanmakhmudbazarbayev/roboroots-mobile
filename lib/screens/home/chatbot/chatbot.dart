import 'package:flutter/material.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:http/http.dart' as http;

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, this.isUser = true});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  // Replace with your API endpoint URL.
  final String apiUrl = 'https://robo.responcy.net/chatbot';

  @override
  void initState() {
    super.initState();
    // Add the initial bot message.
    _messages.add(ChatMessage(
      message: "Hello, I'm here to help!",
      isUser: false,
    ));
  }

  // This function is triggered when the user taps the send button.
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add the user message.
      _messages.add(ChatMessage(message: text, isUser: true));
      // Show the typing indicator.
      _messages.add(ChatMessage(message: "Bot is typing...", isUser: false));
    });
    _controller.clear();

    try {
      // Make the POST request sending the user input in the request body.
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'input': text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['reply'] ?? 'Sorry, no reply received.';
        setState(() {
          // Remove the typing indicator and add the actual bot reply.
          _messages.removeWhere((msg) => msg.message == "Bot is typing...");
          _messages.add(ChatMessage(message: reply, isUser: false));
        });
      } else {
        setState(() {
          _messages.removeWhere((msg) => msg.message == "Bot is typing...");
          _messages.add(ChatMessage(
              message:
                  "Error: Server returned status code ${response.statusCode}",
              isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.removeWhere((msg) => msg.message == "Bot is typing...");
        _messages.add(ChatMessage(message: "Error: $e", isUser: false));
      });
    }
  }

  // Builds a chat bubble for a given message.
  Widget _buildMessage(ChatMessage message) {
    final alignment =
        message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = message.isUser ? Colors.blue[100] : Colors.grey[300];
    final borderRadius = message.isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
            ),
            child: Text(message.message),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Display the messages.
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Reverse the list to show the most recent message at the bottom.
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          const Divider(height: 1),
          // Input field and send button.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
