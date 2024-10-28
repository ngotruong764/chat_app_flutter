import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ApisChat {
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
      print("Connected");
    } catch(e){
      log('$e');
    }
  }
}