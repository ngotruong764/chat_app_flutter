import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/helper/helper.dart';
import 'package:chat_app_flutter/model/attachment.dart';
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
  static Future<bool> fetchConversationMessage({
    required int pageNumber,
    required int pageSize,
    required int conversationId,
    required RxList<Message> messageList,
    int? addPosition,
    required bool isLastPage,
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

        if(addPosition == null){
          // clear message list before get value
          messageList.clear();
          messageList.addAll(responseList.map((json) => Message.fromJson(json)).toList());
        } else {
          messageList.insertAll(addPosition, responseList.map((json) => Message.fromJson(json)).toList());
        }

        // sort the message list by messageTime ( to ensure the message is in the correct order)
        // messageList.sort((msg1, msg2) => msg1.messageTime.compareTo(msg2.messageTime));

        if(response.data['lastPage'] != null){
          isLastPage = response.data['lastPage'];
        }

        // convert attachment content base64 to byte[]
        if(messageList.isNotEmpty){
          for(Message message in messageList){
            for(Attachment attachment in message.attachments!){
              if(attachment.attachmentContent!.isNotEmpty){
                List<int> bytes = await Helper.encodeAnBase64ToBytes(attachment.attachmentContent!);
                if(bytes.isNotEmpty){
                  attachment.attachmentContentByte = bytes;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      log('$e');
    }
    return isLastPage;
  }
}
