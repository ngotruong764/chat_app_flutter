import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/conversation.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

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
}
