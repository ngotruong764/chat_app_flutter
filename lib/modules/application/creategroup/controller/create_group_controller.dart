import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chat_app_flutter/data/api/api_search.dart';
import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_conversation.dart';
import 'package:chat_app_flutter/model/conversation.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController{
  UserInfo currentUser = ApisBase.currentUser;

  /*
  * Method to find user by username or email
  */
  Future<List<UserInfo>> findUserByUserNameOrEmail(String value, int currentUserId, int pageNo, int pageSize) async{
    print(pageNo);
    List<UserInfo> searchedUser = await ApiSearch.fetchUserList(value, currentUserId, page: pageNo, size: pageSize );
    return searchedUser;
  }

  /*
  * Method to find conversation
  */
  Future<Conversation?> findConversation(int conversationPartner) async{
    Conversation? conversation = await ApisConversation.findConversationOfTwoPeople(conversationPartnerId: conversationPartner);
    return conversation;
  }

  Future<int?> createGroup(List<UserInfo> users) async {
    try {
      final List<int> participantIds = users.map((user) => user.id!).toList();
      final Uri uri = Uri.parse(ApisBase.createConversation).replace(
        queryParameters: {
          'userId': currentUser.id!.toString(),
          'participantIds': participantIds.map((id) => Uri.encodeComponent(id.toString())).join(','),
        },
      );
      print("URL is: ${uri}");
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          return jsonResponse['id'];
        } catch(e) {
          print('Error parsing json: $e');
          print('Response body: ${response.body}');
          return null;
        }

      } else {
        print('Failed to create group ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error create group: $e');
      return null;
    }
  }
}
