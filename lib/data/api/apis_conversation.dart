import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/conversation.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../model/message.dart';

class ApisConversation {
  /*
  * get the latest 20 conversations of a person
  */
  static Future<void> getListConversation({required int pageNumber
    , required int pageSize, required RxList conversationList}) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.getListConversationUrl,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      if(response.data['responseCode'] == 200){
        List<dynamic> conversationDTOList = response.data['conversationDTOList'];
        conversationList.addAll(conversationDTOList.map((json) => Conversation.fromJson(json)).toList());
      }
    } catch (e) {
      log('error: $e');
    }
  }

  /*
  * Fetch messages of a conversation
  */
  static Future<void> fetchConversationMessage({
    required int pageNumber,
    required int pageSize,
    required int conversationId,
    required RxList<Message> messageList,
  }) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.fetchConversationMessageUrl,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'conversationId': conversationId,
        },
      );
      if (response.data['responseCode'] == 200) {
        List<dynamic> responseList = response.data['messageDTOList'];
        messageList.addAll(responseList.map((json) => Message.fromJson(json)).toList());
      }
    } catch (e) {
      log('$e');
    }
  }
}
