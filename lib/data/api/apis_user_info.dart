import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class ApisUserinfo {
  // Register account
  static Future<UserInfo?> registerAccount(
      {required String username,
      required String email,
      required String password}) async {
    try{
      final response = await ApisBase.dio.post(
        ApisBase.registerAccount,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'userInfo':{
            'username': username,
            'email': email,
            'password': password,
          }
        },
      );
      if(response.data['responseCode'] == 200){

      }
    } catch(e){
      e.printError();
    }
  }
}
