import 'package:chat_app_flutter/data/api/api_search.dart';
import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_conversation.dart';
import 'package:chat_app_flutter/model/conversation.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:get/get.dart';

class SearchUserController extends GetxController{
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
}