import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/message.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ApisChat {
  static late final WebSocketChannel socketChannel;
  /*
  * Connect web socket
  */
  static void connectSocket() async{
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
      print("Connected");
    } catch(e){
      log('$e');
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
      log('$e');
    }
  }

  /*
  * Receive message message
  */
  static Stream<dynamic>? listenMessage({
    required RxList<Message> messageList,
  }) {
    try {
      // listen message
      socketChannel.stream.listen((onData) {
        // convert String to message
        Message message = Message.fromJson(jsonDecode(onData));
        // add message to the list
        messageList.add(message);
      },);
      return messageList.stream;
    } catch (e) {
      log('$e');
    }
    return null;
  }

  // test api
  static Future<void> sendMedia({
    required String base64Encoded,
  }) async {
    try {
      final response = await ApisBase.dio.post(
        'http://10.0.2.2:8081/talkie/api/v1/message/test_put_s3',
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'base64': base64Encoded,
        },
      );

    } catch (e) {
      log('$e');
    }
  }
}