import 'package:chat_app_flutter/model/user_info.dart';
import 'package:dio/dio.dart';

abstract class ApisBase{
  //
  static late UserInfo currentUser;
  // create dio
  static final Dio dio = Dio();
  static const String baseURL = 'http://10.0.2.2:8081/talkie/api/v1';
  static const String socketBaseUrl = 'ws://10.0.2.2:8081/talkie/api/v1/chat';
  static const String testApi = 'http://10.0.2.2:8081/talkie/api/v1/user-info/test';

  // USER INFO
  static const String registerAccount = '$baseURL/user-info/register';
  static const String login = '$baseURL/user-info/login';
  static const String logout = '$baseURL/user-info/logout';
  static const String confirmAccount = '$baseURL/user-info/confirm-account';
  static const String updateUserInfo = '$baseURL/user-info/update-user';

  // conservation
  static const String getListConversationUrl = '$baseURL/conservation/getListConversation';

}