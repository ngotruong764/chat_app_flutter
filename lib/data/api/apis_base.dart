import 'package:chat_app_flutter/model/user_info.dart';
import 'package:dio/dio.dart';

abstract class ApisBase{
  //
  static late UserInfo currentUser;
  // create dio
  static final Dio dio = Dio();
  // local - Android
  static const String baseURL = 'http://10.0.2.2:8081/talkie/api/v1';
  static const String socketBaseUrl = 'ws://10.0.2.2:8081/talkie/api/v1/chat';

  // local - IOS
  // static const String baseURL = 'http://localhost:8081/talkie/api/v1';
  // static const String socketBaseUrl = 'ws://localhost:8081/talkie/api/v1/chat';

  // server
  // static const String baseURL = 'http://13.229.78.79:8080/talkie/api/v1';
  // static const String socketBaseUrl = 'ws://13.229.78.79:8080/talkie/api/v1/chat';

  // // server
  // static const String baseURL = 'chat-app-688219525.ap-southeast-1.elb.amazonaws.com/talkie/api/v1';
  // static const String socketBaseUrl = 'chat-app-688219525.ap-southeast-1.elb.amazonaws.com/talkie/api/v1/chat';

  // AUTH
  static const String login = '$baseURL/user-info/login';
  static const String logout = '$baseURL/user-info/logout';

  // USER INFO
  static const String registerAccount = '$baseURL/user-info/register';
  static const String confirmAccount = '$baseURL/user-info/confirm-account';
  static const String updateUserInfo = '$baseURL/user-info/update-user';

  // conservation
  static const String getListConversationUrl = '$baseURL/conservation/getListConversation';
  static const String fetchConversationMessageUrl = '$baseURL/conservation/fetchConversationMessage';
  static const String fetchConversationOrCreateUrl = '$baseURL/conservation/fetchConversationOrCreate';
  // static const String getListCustomerUrl = '$baseURL/user-info/searchUserByUsername';
  static const String getListCustomerUrl = '$baseURL/user-info/searchUsersByUsername';
  static const String createConversation = '$baseURL/conservation/createConversation';



}