import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roboroots/api/user_service.dart'; // <-- Adjust path as needed

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, this.isUser = true});

  Map<String, dynamic> toJson() => {
        'message': message,
        'isUser': isUser,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        message: json['message'],
        isUser: json['isUser'] ?? true,
      );
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages().then((_) {
      if (_messages.isEmpty) {
        setState(() {
          _messages.add(ChatMessage(
            message: "Hello, I'm here to help!",
            isUser: false,
          ));
        });
        _saveMessages();
      }
    });
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('chat_messages', data);
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList('chat_messages');
    if (data != null) {
      setState(() {
        _messages.clear();
        _messages.addAll(data.map((str) {
          final map = jsonDecode(str);
          return ChatMessage.fromJson(map);
        }));
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(message: text, isUser: true));
      _isBotTyping = true;
    });
    _controller.clear();
    await _saveMessages();

    try {
      final reply = await UserService().chatbot(text);

      setState(() {
        _isBotTyping = false;
        _messages.add(ChatMessage(message: reply, isUser: false));
      });
      await _saveMessages();
    } catch (e) {
      setState(() {
        _isBotTyping = false;
        _messages.add(ChatMessage(message: "Error: $e", isUser: false));
      });
      await _saveMessages();
    }
  }

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
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == 0) {
                  return _buildMessage(
                    ChatMessage(message: "Bot is typing...", isUser: false),
                  );
                }
                final msgIdx =
                    _messages.length - 1 - (index - (_isBotTyping ? 1 : 0));
                final message = _messages[msgIdx];
                return _buildMessage(message);
              },
            ),
          ),
          const Divider(height: 1),
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
                    onSubmitted: (_) => _sendMessage(),
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
