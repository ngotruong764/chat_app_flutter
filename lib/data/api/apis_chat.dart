import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/conversation.dart';
import 'package:chat_app_flutter/model/message.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ApisChat {
  static late final WebSocketChannel socketChannel;
  static late final Stream socketChannelStreamBroadcast;
  /*
  * Connect web socket
  */
  static Future<void> connectSocket() async{
    try{
      // get this user id
      int userId = ApisBase.currentUser.id ?? 0;
      // final wsUrl = Uri.parse(ApisBase.socketBaseUrl)
      //     .replace(
      //   queryParameters: {
      //     'userId': userId,
      //   },
      // );
      final wsUrl = Uri.parse('${ApisBase.socketBaseUrl}?userId=$userId');
      final channel = WebSocketChannel.connect(wsUrl);
      // wait for socket ready
      await channel.ready;
      socketChannel = channel;
      //  broad cast channel
      socketChannelStreamBroadcast = socketChannel.stream.asBroadcastStream();
      //
      // socketChannel.closeCode;
      log("Connected");
    } catch(e){
      log('Error connect socket: $e');
    }
  }

  /*
  * Method to disconnect socket
  */
  static void disconnectSocket(){
    try{
      socketChannel.sink.close();
    } catch(e){
      log('Error disconnect socket: $e');
    }
  }

  /*
  * Send message
  */
  static void sendMessageSocket({
    required Message message,
  }) async {
    try {
      // send message
      socketChannel.sink.add(jsonEncode(message.toJson()));
    } catch (e) {
      log('Error send message socket: $e');
    }
  }

  /*
  * Receive message in chat box
  */
  static Stream<dynamic>? listenMessage({
    required RxList<Message> messageList,
  }) {
    try {
      // listen message
      // socketChannel.stream.listen((onData) {
      socketChannelStreamBroadcast.listen((onData) {
        // convert String to message
        Message message = Message.fromJson(jsonDecode(onData));
        // add message to the list
        messageList.add(message);
      },);
      return messageList.stream;
    } catch (e) {
      log('Error listen message: $e');
    }
    return null;
  }

  /*
  * Receive message in chat screed
  */
  static Stream<dynamic>? listenMessageInChatScreen({
    required RxList<Conversation> conversationList,
  }) {
    try {
      // listen message
      // Stream socketStreamBroadcast = socketChannel.stream.asBroadcastStream();
      socketChannelStreamBroadcast.listen(
        (onData) {
          // convert String to message
          Message message = Message.fromJson(jsonDecode(onData));

          // get conversation id
          int conversationId = message.conversationId;

          Conversation? conversationReceivedMess =
              conversationList.firstWhereOrNull(
                  (conversation) => conversation.id!.isEqual(conversationId));

          if (conversationReceivedMess != null) {
            // remove old conversation
            conversationList.removeWhere(
                (conversation) => conversation.id!.isEqual(conversationId));

            // add new conversation
            conversationReceivedMess.lastMessage = message.content; // update message
            conversationReceivedMess.lastMessageTime = message.messageTime; // update time
            conversationList.insert(0, conversationReceivedMess);
          }
        },
      );
      return conversationList.stream.asBroadcastStream();
    } catch (e) {
      log('Error listen message in chat: $e');
    }
    return null;
  }
}