import 'package:chat_app_flutter/data/api/apis_chat.dart';
import 'package:chat_app_flutter/data/api/apis_conversation.dart';
import 'package:chat_app_flutter/model/attachment.dart';
import 'package:get/get.dart';

import '../../../model/conversation.dart';
import '../../../model/message.dart';

class ChatController extends GetxController{
  int pageSize = 20;
  int pageNumber = 0;
  bool isLastPage = false;

  RxList<Conversation> conversationList = <Conversation>[].obs;
  // list for message of a conversation
  RxList<Message> messageList = <Message>[].obs;

  // message when we send 1 or many attachment
  final String AN_ATTACHMENT_MESS = "Send an attachment";
  final String ATTACHMENTS_MESS = "Send attachments";

  //
  @override
  void onInit() async{
    super.onInit();
    fetchInitData();
  }

  void fetchInitData() async{
    await fetchConversationList(pageNumber, pageSize);
  }

  /*
  * Fetch conversation list
  */
  Future<void> fetchConversationList(int pageNumber, int pageSize) async {
    await ApisConversation.getListConversation(
        pageNumber: pageNumber,
        pageSize: pageSize,
        conversationList: conversationList);
  }

  /*
  * Fetch messages of a conversation
  */
  Future<void> fetchMessage(int pageNumber, int pageSize, int conversationId, int? addPosition) async {
    // clear message list before get value
    // messageList.clear();
    //
    isLastPage = await ApisConversation.fetchConversationMessage(
      pageNumber: pageNumber,
      pageSize: pageSize,
      conversationId: conversationId,
      messageList: messageList,
      addPosition: addPosition,
      isLastPage: isLastPage,
    );
  }

  /*
  * Send messages of a conversation
  */
  // void sendMessage(int userId, int conversationId, String conversationName, String content, DateTime currentTime) {
  //   Message message = Message(userId: userId, conversationId: conversationId, content: content,
  //       messageTime: currentTime, conversationName: conversationName);
  //   // add this temporary message
  //   messageList.add(message);
  //   // send message to a conversation
  //   ApisChat.sendMessageSocket(message: message);
  //
  // }

  void sendMessage(int userId, int conversationId, String conversationName, String content, DateTime currentTime, List<Attachment> attachments) {
    Message message = Message(
      userId: userId,
      conversationId: conversationId,
      content: content,
      messageTime: currentTime,
      conversationName: conversationName,
      attachments: attachments,
    );
    // add this temporary message
    messageList.add(message);
    // send message to a conversation
    ApisChat.sendMessageSocket(message: message);
  }
}