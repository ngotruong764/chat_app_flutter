import 'dart:developer';
import 'dart:io';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_chat.dart';
import 'package:chat_app_flutter/helper/helper.dart';
import 'package:chat_app_flutter/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/conversation.dart';
import '../controller/chat_controller.dart';

class ChatBox extends StatefulWidget {
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

class _ChatBoxState extends State<ChatBox> {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode currentFocus = FocusNode();
  late final FocusScopeNode currentScopeNode;
  final _picker = ImagePicker();
  List<XFile> medias = [];
  //
  int messagePageSize = 40;
  int messagePageNumber = 0;

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  /*
  * Un focus TextField
  */

  void _unFocusTextField() {
    if (!currentScopeNode.hasPrimaryFocus &&
        currentScopeNode.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /*
  * To open keyboard
  */
  void openKeyboard() {
    FocusScope.of(context).requestFocus(currentFocus);
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    // fetch messages
    chatController
        .fetchMessage(messagePageNumber, messagePageSize, widget.conversationId)
        .then(
          (_) => _scrollToBottom(),
        );
    // add listener to focus node
    currentFocus.addListener(() {
      // currentScopeNode = FocusScope.of(context);
      if (currentFocus.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollToBottom(),
        );
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      currentScopeNode = FocusScope.of(context);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    super.dispose();
    ApisChat.socketChannel.stream.asBroadcastStream();
    ApisChat.listenMessage(messageList: chatController.messageList);
    // un focus text field
    _unFocusTextField();
    currentFocus.dispose();
    // currentScopeNode.dispose();
    log('dispose ChatBox');
  }

  Future<void> pickMedia() async {
    // clear the list before get medias
    medias.clear();
    medias = await _picker.pickMultipleMedia();
    Helper.encodeImgToBase64(medias);
  }

 
  @override
  void initState() {
    super.initState();
    chatController.fetchMessage(
        messagePageNumber, messagePageSize, widget.conversationId);
    currentFocus.addListener(() {
      if (currentFocus.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollToBottom(),
        );
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      currentScopeNode = FocusScope.of(context);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    super.dispose();
    ApisChat.socketChannel.stream.asBroadcastStream();
    ApisChat.listenMessage(messageList: chatController.messageList);
    _unFocusTextField();
    currentFocus.dispose();
  }

  void _unFocusTextField() {
    if (!currentScopeNode.hasPrimaryFocus &&
        currentScopeNode.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unFocusTextField,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.account_circle),
              ),
              const SizedBox(width: 10),
              Text(widget.name),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ApisChat.listenMessage(
                        messageList: chatController.messageList)
                    ?.asBroadcastStream(),
                initialData: chatController.messageList,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Text("No messages");
                  }
                  return Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      itemCount: chatController.messageList.length,
                      itemBuilder: (context, index) {
                        Message message = chatController.messageList[index];
                        bool isUserMessage =
                            message.userId == ApisBase.currentUser.id;

                        if (message.content.isNotEmpty) {
                          return Align(
                            alignment: isUserMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isUserMessage
                                    ? Colors.blue[200]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message.content),
                            ),
                          );
                        }

                        if (message.mediaUrl.isNotEmpty) {
                          return Align(
                            alignment: isUserMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Image.file(
                                      File(message
                                          .mediaUrl), // Hiển thị ảnh từ file
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                constraints: const BoxConstraints(
                                  maxWidth: 150, // Giới hạn chiều rộng ảnh
                                  maxHeight: 150, // Giới hạn chiều cao ảnh
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  // Bo góc ảnh
                                  child: Image.file(
                                    File(message.mediaUrl),
                                    // Hiển thị ảnh từ File
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Get.height * 0.001),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_outlined),
                    onPressed: pickMedia,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hiển thị danh sách ảnh nếu có
                        if (medias.isNotEmpty)
                          SizedBox(
                            height: 80, // Chiều cao cố định cho vùng thumbnail
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // Cuộn theo chiều ngang
                              itemCount: medias.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    // Hiển thị ảnh thumbnail
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      // Bo góc thumbnail
                                      child: Image.file(
                                        File(medias[index].path),
                                        width: 70,
                                        // Kích thước cố định cho thumbnail
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Nút xóa ảnh
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            medias.removeAt(
                                                index); // Xóa ảnh khỏi danh sách
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 12,
                                          // Kích thước nút xóa
                                          backgroundColor: Colors.red,
                                          // Màu nền nút xóa
                                          child: const Icon(
                                            Icons.close, // Icon xóa
                                            color: Colors.white, // Màu icon
                                            size: 16, // Kích thước icon
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        // Thanh nhập tin nhắn
                        TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Enter your message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          autofocus: true,
                          focusNode: currentFocus,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Gửi ảnh nếu có trong danh sách `medias`
                      if (medias.isNotEmpty) {
                        for (var media in medias) {
                          chatController.sendMessage(
                            ApisBase.currentUser.id!,
                            widget.conversationId,
                            widget.name,
                            '', // Không có nội dung tin nhắn
                            DateTime.now(),
                            mediaUrl: media.path, // Đường dẫn ảnh
                          );
                        }
                        // Xóa danh sách ảnh sau khi gửi
                        setState(() {
                          medias.clear(); // Xóa tất cả ảnh trong danh sách
                        });
                      } else {
                        if (messageController.text.trim().isNotEmpty) {
                          chatController.sendMessage(
                            ApisBase.currentUser.id!,
                            widget.conversationId,
                            widget.name,
                            messageController.text.trim(), // Nội dung tin nhắn
                            DateTime.now(),
                          );
                          // Xóa nội dung trong TextField
                          messageController.clear();
                        }
                      }

                      // Sau khi gửi xong, cuộn xuống dưới và xóa nội dung tin nhắn
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      updateChatScreen();
                      messageController.clear();
                      medias.clear();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateChatScreen() {
    Conversation? conversationReceivedMess = chatController.conversationList
        .firstWhereOrNull(
            (conversation) => conversation.id!.isEqual(widget.conversationId));
    if (conversationReceivedMess != null) {
      // remove old conversation
      chatController.conversationList.removeWhere(
          (conversation) => conversation.id!.isEqual(widget.conversationId));
      // add new conversation
      conversationReceivedMess.lastMessage = messageController.text;
      chatController.conversationList.insert(0, conversationReceivedMess);
    }
  }
}
