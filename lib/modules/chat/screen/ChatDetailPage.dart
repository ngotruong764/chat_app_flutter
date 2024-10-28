import 'package:chat_app_flutter/modules/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailPage extends StatefulWidget {
  final int conversationId;
  final String name;
  final String imageUrl;
  final String message;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
    required this.name,
    required this.imageUrl,
    required this.message,
  });

  @override
  State<ChatDetailPage> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Last message:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.message,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
