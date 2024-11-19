import 'dart:convert';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_chat.dart';
import 'package:chat_app_flutter/helper/helper.dart';
import 'package:chat_app_flutter/model/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../controller/chat_controller.dart';

class ChatBox extends StatefulWidget{
  const ChatBox({
    super.key,
    required this.conversationId,
    required this.name,
    required this.imageUrl,
    required this.message,
  });

  final int conversationId;
  final String name;
  final String imageUrl;
  final String message;

  @override
  State<StatefulWidget> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox>{
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();
  final _picker = ImagePicker();
  List<XFile> medias = [];
  //
  int messagePageSize = 40;
  int messagePageNumber = 0;

  @override
  void initState() {
    super.initState();
    // fetch messages
    chatController.fetchMessage(messagePageNumber, messagePageSize, widget.conversationId);
  }

  @override
  void dispose() {
    super.dispose();
    ApisChat.socketChannel.stream;
  }

  Future<void> pickMedia() async{
    // clear the list before get medias
    medias.clear();
    medias = await _picker.pickMultipleMedia();
    Helper.encodeImgToBase64(medias);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              // backgroundImage: NetworkImage(widget.imageUrl),
              radius: 20,
              // backgroundImage: NetworkImage(widget.imageUrl),
              child: Icon(Icons.account_circle),
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: StreamBuilder(
              // stream to listen
              // stream: chatController.messageList.stream,
              // stream: ApisChat.socketChannel.stream,
              stream: ApisChat.listenMessage(messageList: chatController.messageList),
              initialData: chatController.messageList,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // waiting for data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // if has no data
                if (!snapshot.hasData) {
                  return const Text("Have no messages");
                }
                // if has data
                // Message message = Message.fromJson(jsonDecode(snapshot.data));
                // chatController.messageList.add(message);
                return Obx(() =>
                    ListView.builder(
                      itemCount: chatController.messageList.length,
                      itemBuilder: (context, index) {
                        Message message = chatController.messageList[index];
                        bool isUserMessage = message.userId ==
                            ApisBase.currentUser
                                .id; // Kiểm tra tin nhắn có phải của người dùng không
                        return Align(
                          alignment: isUserMessage
                              ? Alignment
                              .centerRight // Tin nhắn của người dùng căn phải
                              : Alignment.centerLeft,
                          // Tin nhắn của đối phương căn trái
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isUserMessage ? Colors.blue[200] : Colors
                                  .grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(message.content),
                          ),
                        );
                      },
                    )
                );
              },
            ),
            // child: Obx(() {
            //   return ListView.builder(
            //     itemCount: chatController.messageList.length,
            //     itemBuilder: (context, index) {
            //       Message message = chatController.messageList[index];
            //       bool isUserMessage = message.userId == ApisBase.currentUser.id; // Kiểm tra tin nhắn có phải của người dùng không
            //       return Align(
            //         alignment: isUserMessage
            //             ? Alignment.centerRight // Tin nhắn của người dùng căn phải
            //             : Alignment.centerLeft,  // Tin nhắn của đối phương căn trái
            //         child: Container(
            //           padding: const EdgeInsets.all(10),
            //           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //           decoration: BoxDecoration(
            //             color: isUserMessage ? Colors.blue[200] : Colors.grey[300],
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: Text(message.content),
            //         ),
            //       );
            //     },
            //   );
            // }),
          ),
          // Khung nhập và nút gửi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: ()async {
                    // pick (image + video)
                    await pickMedia();
                  },
                ),
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
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Send message to a conversation
                    chatController.sendMessage(
                      ApisBase.currentUser.id!,
                      widget.conversationId,
                      messageController.text,
                      DateTime.now(),
                    );
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

