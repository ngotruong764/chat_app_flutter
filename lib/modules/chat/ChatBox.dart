import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Tạo ChatController với GetX
class ChatController extends GetxController {
  var messagesMap = <String, List<Map<String, dynamic>>>{
    '1': [
      {'isMine': true, 'message': 'Hi Alice!'},
      {'isMine': false, 'message': 'Hello! How are you?'},
      {'isMine': true, 'message': 'I am good, thanks!'},
    ],
    '2': [
      {'isMine': true, 'message': 'Hi Bob!'},
      {'isMine': false, 'message': 'Hey! What’s up?'},
      {'isMine': true, 'message': 'Just working on a project.'},
    ],
  }.obs;


  void sendMessage(String userId, String message) {
    if (message.isNotEmpty) {
      messagesMap.putIfAbsent(userId, () => []).add({'isMine': true, 'message': message});
    }
  }

  List<Map<String, dynamic>> getMessages(String userId) {
    return messagesMap[userId] ?? [];
  }
}

class ChatBox extends StatelessWidget{
  ChatBox({required this.userId, Key? key, required this.name, required this.imageUrl, required this.message}) : super(key: key);

  final String userId;
  final String name;
  final String imageUrl;
  final String message;

  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(name),
          ],
        ),
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: Obx(() {
              var messages = chatController.getMessages(userId);
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage = messages[index]['isMine']; // Kiểm tra tin nhắn có phải của người dùng không
                  return Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight // Tin nhắn của người dùng căn phải
                        : Alignment.centerLeft,  // Tin nhắn của đối phương căn trái
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(messages[index]['message']),
                    ),
                  );
                },
              );
            }),
          ),
          // Khung nhập và nút gửi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Gửi tin nhắn cho userId cụ thể
                    chatController.sendMessage(userId, messageController.text);
                    messageController.clear(); // Xóa khung nhập sau khi gửi
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

