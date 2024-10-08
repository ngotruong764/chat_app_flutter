import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Tạo ChatController với GetX
class ChatController extends GetxController {
  var messages = <String>[].obs; // Danh sách tin nhắn sử dụng RxList (observable)

  // Hàm để gửi tin nhắn
  void sendMessage(String message) {
    if (message.isNotEmpty) {
      messages.add(message); // Thêm tin nhắn vào danh sách
    }
  }
}

class ChatBox extends StatelessWidget{
  ChatBox({super.key});

  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Chat between two people"),
          ),
          body: Column(
            children: [
              // Danh sách tin nhắn
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: chatController.messages.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage = index % 2 == 0; // Giả lập tin nhắn từ hai phía
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight // Tin nhắn người dùng căn phải
                            : Alignment.centerLeft,  // Tin nhắn đối phương căn trái
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(chatController.messages[index]),
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
                        // Gửi tin nhắn
                        chatController.sendMessage(messageController.text);
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

