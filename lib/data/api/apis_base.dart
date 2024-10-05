import 'package:dio/dio.dart';

abstract class ApisBase{
  // create dio
  static final Dio dio = Dio();
  static const String baseURL = 'http://10.0.2.2:8081/talkie/api/v1';

  // USER INFO
  static const String registerAccount = '$baseURL/user-info/register';
}