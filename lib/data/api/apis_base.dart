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
  static const String socketBaseVideoCallUrl = 'ws://10.0.2.2:8081/talkie/api/v1/video';

  // local - IOS
  // static const String baseURL = 'http://localhost:8081/talkie/api/v1';
  // static const String socketBaseUrl = 'ws://localhost:8081/talkie/api/v1/chat';

  // AUTH
  static const String login = '$baseURL/user-info/login';
  static const String logout = '$baseURL/user-info/logout';
  static const String pushVerificationCodeUrl = '$baseURL/user-info/pushVerificationCode';

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