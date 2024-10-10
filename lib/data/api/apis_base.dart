import 'package:dio/dio.dart';

abstract class ApisBase{
  // create dio
  static final Dio dio = Dio();
  static const String baseURL = 'http://10.0.2.2:8081/talkie/api/v1';
  static const String socketBaseUrl = 'ws://10.0.2.2:8081/talkie/api/v1/chat';

  // USER INFO
  static const String registerAccount = '$baseURL/user-info/register';
  static const String login = '$baseURL/user-info/login';
}