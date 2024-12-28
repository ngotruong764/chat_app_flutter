import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_chat.dart';
import 'package:chat_app_flutter/helper/helper.dart';
import 'package:chat_app_flutter/model/attachment.dart';
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
    required this.conversation,
  });

  final int conversationId;
  final String name;
  final String imageUrl;
  final String message;
  final Conversation conversation;

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
  List<XFile> medias = []; // Dùng để lưu ảnh đã chọn nhưng chưa gửi
  RxBool isLoadMore = false.obs;

  // pagination parameter
  int messagePageSize = 50;
  int messagePageNumber = 0;

  // declare stream to listen to message
  late final Stream? messageStream;

  void _scrollToBottom() {
    if(_scrollController.hasClients){
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  // Open keyboard
  void openKeyboard() {
    FocusScope.of(context).requestFocus(currentFocus);
    _scrollToBottom();
  }

  Future<void> pickMedia() async {
    medias.clear();
    medias = await _picker.pickMultipleMedia();
    if (medias.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // update current conversation id
    Constants.CURRENT_CONVERSATION_ID = widget.conversationId;

    // init FocusScopeNode
    currentScopeNode = FocusScopeNode();

    // after loading message --> go to the bottom to get the newest message
    chatController
        .fetchMessage(messagePageNumber, messagePageSize, widget.conversationId, null)
        .then(
          (value) => Future.delayed(
        const Duration(milliseconds: 500),
            () => _scrollToBottom(),
      ),
    );

    // when open keyboard --> go to the bottom of the chat box
    currentFocus.addListener(() {
      if (currentFocus.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
              () => _scrollToBottom(),
        );
      }
    });

    // get the stream of message
    messageStream = ApisChat.listenMessage(
        messageList: chatController.messageList);


    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollToBottom();
    // });

    // Add a listener to scroll to the bottom when new messages are added
    // chatController.messageList.listen((List<Message> messages) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _scrollToBottom();
    //   });
    // });

    // add listener to ScrollController
    _scrollController.addListener(() {
      // if scroll controller is assigned to our widget
      if(_scrollController.hasClients){
        // if we scroll to the top, and not isLastPage --> load more messages
        if(_scrollController.offset <= _scrollController.position.minScrollExtent
            && !_scrollController.position.outOfRange && !chatController.isLastPage){
          _loadMoreMessage();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _unFocusTextField();
    currentFocus.dispose();
    Constants.CURRENT_CONVERSATION_ID = -1;
  }

  void _unFocusTextField() {
    currentFocus.unfocus();
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
              // const CircleAvatar(
              //   radius: 20,
              //   child: Icon(Icons.account_circle),
              // ),
              _displayConservationAvatar(widget.conversation, context),
              const SizedBox(width: 10),
              Text(widget.name),
            ],
          ),
        ),
        body: Column(
          children: [
            // display load at the top center when we load more object
            Obx(() {
              if (isLoadMore.value) {
                return const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            }),
            Expanded(
              child: StreamBuilder(
                stream: messageStream,
                initialData: chatController.messageList,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Text("No messages");
                  }
                  // display messages
                  return Obx(
                        () =>
                        ListView.builder(
                          // shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: chatController.messageList.length,
                          itemBuilder: (context, index) {
                            Message message = chatController.messageList[index];
                            bool isUserMessage =
                                message.userId == ApisBase.currentUser.id;

                            // render message content
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

                            // render attachment
                            if(message.attachments!.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: message.attachments!.length,
                                itemBuilder: (context, index) {
                                  Attachment attachment = message
                                      .attachments![index];
                                  if (attachment.attachmentContentByte!
                                      .isNotEmpty) {
                                    return Align(
                                      alignment:
                                      isUserMessage
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                Dialog(
                                                  child: Image.memory(
                                                    Uint8List.fromList(attachment
                                                        .attachmentContentByte!), // Hiển thị ảnh từ file
                                                  ),
                                                ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          constraints: const BoxConstraints(
                                            maxWidth: 150,
                                            // Giới hạn chiều rộng ảnh
                                            maxHeight: 150, // Giới hạn chiều cao ảnh
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            // Bo góc ảnh
                                            child: Image.memory(
                                              Uint8List.fromList(attachment
                                                  .attachmentContentByte!),
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
                              );
                            }
                            // if (message.attachments!.isNotEmpty) {
                            //   return Align(
                            //     alignment: isUserMessage
                            //         ? Alignment.centerRight
                            //         : Alignment.centerLeft,
                            //     child: GestureDetector(
                            //       onTap: () {
                            //         showDialog(
                            //           context: context,
                            //           builder: (_) => Dialog(
                            //             child: Image.memory(
                            //               Uint8List.fromList(message.attachments![0].attachmentContentByte!), // Hiển thị ảnh từ file
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //       child: Container(
                            //         margin: const EdgeInsets.symmetric(
                            //             vertical: 5, horizontal: 10),
                            //         constraints: const BoxConstraints(
                            //           maxWidth: 150, // Giới hạn chiều rộng ảnh
                            //           maxHeight: 150, // Giới hạn chiều cao ảnh
                            //         ),
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(10),
                            //           border:
                            //           Border.all(color: Colors.grey.shade300),
                            //         ),
                            //         child: ClipRRect(
                            //           borderRadius: BorderRadius.circular(10),
                            //           // Bo góc ảnh
                            //           child: Image.memory(
                            //             Uint8List.fromList(message.attachments![0].attachmentContentByte!),
                            //             // Hiển thị ảnh từ File
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   );
                            // }

                            return const SizedBox.shrink();
                          },
                        ),
                  );
                  // return Obx(
                  //   () => SingleChildScrollView(
                  //     controller: _scrollController,
                  //     padding: EdgeInsets.only(top: Get.height),
                  //     child: IntrinsicHeight(
                  //       child: Column(
                  //         children: chatController.messageList.map((message) {
                  //           bool isUserMessage =
                  //               message.userId == ApisBase.currentUser.id;
                  //
                  //           List<Widget> messageWidgets = [];
                  //
                  //           // Render message content
                  //           if (message.content.isNotEmpty) {
                  //             messageWidgets.add(
                  //               Align(
                  //                 alignment: isUserMessage
                  //                     ? Alignment.centerRight
                  //                     : Alignment.centerLeft,
                  //                 child: Container(
                  //                   padding: const EdgeInsets.all(10),
                  //                   margin: const EdgeInsets.symmetric(
                  //                       vertical: 5, horizontal: 10),
                  //                   decoration: BoxDecoration(
                  //                     color: isUserMessage
                  //                         ? Colors.blue[200]
                  //                         : Colors.grey[300],
                  //                     borderRadius: BorderRadius.circular(10),
                  //                   ),
                  //                   child: Text(message.content),
                  //                 ),
                  //               ),
                  //             );
                  //           }
                  //
                  //           // Render attachments
                  //           if (message.attachments!.isNotEmpty) {
                  //             messageWidgets.addAll(
                  //               message.attachments!.map((attachment) {
                  //                 if (attachment
                  //                     .attachmentContentByte!.isNotEmpty) {
                  //                   return Align(
                  //                     alignment: isUserMessage
                  //                         ? Alignment.centerRight
                  //                         : Alignment.centerLeft,
                  //                     child: GestureDetector(
                  //                       onTap: () {
                  //                         showDialog(
                  //                           context: context,
                  //                           builder: (_) => Dialog(
                  //                             child: Image.memory(
                  //                               Uint8List.fromList(attachment
                  //                                   .attachmentContentByte!),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       },
                  //                       child: Container(
                  //                         margin: const EdgeInsets.symmetric(
                  //                             vertical: 5, horizontal: 10),
                  //                         constraints: const BoxConstraints(
                  //                           maxWidth: 150,
                  //                           maxHeight: 150,
                  //                         ),
                  //                         decoration: BoxDecoration(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                           border: Border.all(
                  //                               color: Colors.grey.shade300),
                  //                         ),
                  //                         child: ClipRRect(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                           child: Image.memory(
                  //                             Uint8List.fromList(attachment
                  //                                 .attachmentContentByte!),
                  //                             fit: BoxFit.cover,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 }
                  //                 return const SizedBox.shrink();
                  //               }).toList(),
                  //             );
                  //           }
                  //
                  //           return Column(
                  //             children: messageWidgets,
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ),
                  // );
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
                                        child: const CircleAvatar(
                                          radius: 12,
                                          // Kích thước nút xóa
                                          backgroundColor: Colors.red,
                                          // Màu nền nút xóa
                                          child: Icon(
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

                  // send button
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      DateTime currentTime = DateTime.now();
                      List<Attachment> attachments = [];
                      // Gửi ảnh nếu có trong danh sách `medias`
                      if (medias.isNotEmpty) {
                        attachments.clear();
                        // convert img to attachment
                        attachments = await imgToAttachments();
                        //
                        chatController.sendMessage(
                          ApisBase.currentUser.id!,
                          widget.conversationId,
                          widget.name,
                          '', // Không có nội dung tin nhắn
                          currentTime,
                          attachments,
                        );
                        // Xóa danh sách ảnh sau khi gửi
                        setState(() {
                          medias.clear(); // Xóa tất cả ảnh trong danh sách
                        });
                      } else {
                        if (messageController.text.trim().isNotEmpty) {
                          attachments.clear();
                          chatController.sendMessage(
                            ApisBase.currentUser.id!,
                            widget.conversationId,
                            widget.name,
                            messageController.text.trim(), // Nội dung tin nhắn
                            currentTime,
                            attachments,
                          );
                        }
                      }

                      // scroll to bottom after sending message
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      // update chat screen (outside of chat box)
                      updateChatScreen(attachments, messageController.text, currentTime);

                      messageController.clear();
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

  /*
  * Method to display avatar of conservation
  */
  Widget _displayConservationAvatar(
      Conversation conservation, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (conservation.conservationAvatarBytes!.isNotEmpty) {
      return Container(
        width: width * 0.1,
        height: width * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(conservation.conservationAvatarBytes!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return SizedBox(
      width: width * 0.1,
      height: width * 0.1,
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.account_circle,
          color: Colors.grey,
        ),
      ),
    );
  }

  /*
  * Method is used to render message
  */
  Widget _renderMedia(Message message, bool isUserMessage) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: message.attachments!.length,
      itemBuilder: (context, index) {
        Attachment attachment = message.attachments![index];
        if (attachment.attachmentContentByte!.isNotEmpty) {
          return Align(
            alignment:
            isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Image.memory(
                      Uint8List.fromList(attachment
                          .attachmentContentByte!), // Hiển thị ảnh từ file
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                constraints: const BoxConstraints(
                  maxWidth: 150, // Giới hạn chiều rộng ảnh
                  maxHeight: 150, // Giới hạn chiều cao ảnh
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Bo góc ảnh
                  child: Image.memory(
                    Uint8List.fromList(attachment.attachmentContentByte!),
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
    );
  }

  /*
  * Method to convert XFile to Attachment object
  */
  Future<List<Attachment>> imgToAttachments() async {
    List<Attachment> attachments = [];
    for (XFile media in medias) {
      List<String> splitPath = media.path.split('/');
      String fileName =
          '${ApisBase.currentUser.id!}_${DateTime.now().microsecondsSinceEpoch}_${splitPath.last}';
      String fileType = 'image';
      // fileUrl has the format conversation_img/conversation_id/fileName
      String fileUrl = 'conversation_img/${widget.conversationId}/$fileName';

      // get attachment content (base64 encoded)
      String attachmentContent = await Helper.encodeAnImgToBase64(media);
      List<int> attachmentContentByte = Helper.encodeAnBase64ToBytesSync(attachmentContent).toList();

      // create Attachment object
      Attachment attachment = Attachment(
        fileUrl: fileUrl,
        fileType: fileType,
        fileName: fileName,
        attachmentContent: attachmentContent,
        attachmentContentByte: attachmentContentByte,
      );

      // add to list
      attachments.add(attachment);
    }
    return attachments;
  }

  /*
  * Method to load more message
  */
  void _loadMoreMessage(){
    // load more message
    isLoadMore.value = true;

    // load messages( increase page number)
    chatController.fetchMessage(messagePageNumber++, messagePageSize, widget.conversationId, 0)
        .then((_) => isLoadMore.value = false);
  }

  /*
  * Method to update ChatScreen( Screen which is outside of Chatbox) when we sent a message
  */
  void updateChatScreen(List<Attachment> attachments, String messageContent, DateTime currentTime) {
    Conversation? conversationReceivedMess = chatController.conversationList
        .firstWhereOrNull(
            (conversation) => conversation.id!.isEqual(widget.conversationId));
    if (conversationReceivedMess != null) {
      // remove old conversation
      chatController.conversationList.removeWhere(
              (conversation) => conversation.id!.isEqual(widget.conversationId));

      // add new conversation
      if(messageController.text.isEmpty && attachments.isNotEmpty){
        // if user send attachment, and message do not have content -> display message by default
        if(attachments.length == 1){
          conversationReceivedMess.lastMessage = chatController.AN_ATTACHMENT_MESS;
        } else {
          conversationReceivedMess.lastMessage = chatController.ATTACHMENTS_MESS;
        }
      } else{
        // if message has content
        conversationReceivedMess.lastMessage = messageContent;
      }
      conversationReceivedMess.lastMessageTime = currentTime;
      chatController.conversationList.insert(0, conversationReceivedMess);
    }
  }
}