
import 'dart:developer';

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
  final ScrollController _scrollController = ScrollController();
  final FocusNode currentFocus = FocusNode();
  late final FocusScopeNode currentScopeNode;
  final _picker = ImagePicker();
  List<XFile> medias = [];
  //
  int messagePageSize = 40;
  int messagePageNumber = 0;

  void _scrollToBottom(){
    _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
  }

  /*
  * Un focus TextField
  */
  void _unFocusTextField(){
    if(!currentScopeNode.hasPrimaryFocus && currentScopeNode.focusedChild != null){
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /*
  * To open keyboard
  */
  void openKeyboard(){
    FocusScope.of(context).requestFocus(currentFocus);
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    // fetch messages
    chatController.fetchMessage(messagePageNumber, messagePageSize, widget.conversationId)
        .then((_) => _scrollToBottom(),);
    // add listener to focus node
    currentFocus.addListener(() {
      // currentScopeNode = FocusScope.of(context);
      if(currentFocus.hasFocus){
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

  Future<void> pickMedia() async{
    // clear the list before get medias
    medias.clear();
    medias = await _picker.pickMultipleMedia();
    Helper.encodeImgToBase64(medias);
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
                  stream: ApisChat.listenMessage(messageList: chatController.messageList)?.asBroadcastStream(),
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
                          controller: _scrollController,
                          itemCount: chatController.messageList.length,
                          // physics: const NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Message message = chatController.messageList[index];
                            bool isUserMessage = message.userId == ApisBase.currentUser.id; // Kiểm tra tin nhắn có phải của người dùng không
                            // if message is not empty
                            if (message.content.isNotEmpty) {
                              return Align(
                                alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft, // Tin nhắn của người dùng căn phải, tin nhắn của đối phương căn trái
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isUserMessage ? Colors.blue[200] : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(message.content),
                                ),
                              );
                            }
                            return const SizedBox.shrink(); // Return an empty widget if the message content is empty
                          },
                        )
                    );

                  },
                ),
              ),
              SizedBox(height: Get.height * 0.001),
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
                        autofocus: true,
                        focusNode: currentFocus,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // scrollToBottom
                        _scrollToBottom();
                        // Send message to a conversation
                        chatController.sendMessage(
                          ApisBase.currentUser.id!,
                          widget.conversationId,
                          widget.name,
                          messageController.text,
                          DateTime.now(),
                        );
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                        // update chat screen
                        updateChatScreen();
                        messageController.clear(); // Xóa khung nhập sau khi gửi
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

  void updateChatScreen(){
    Conversation? conversationReceivedMess = chatController.conversationList.firstWhereOrNull(
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

