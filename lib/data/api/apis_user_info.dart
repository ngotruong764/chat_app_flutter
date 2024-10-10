import 'dart:developer';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/storage/secure_storage.dart';
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

  // Login
  static Future<UserInfo?> confirmAccount(
      {required String? verificationCode}) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.confirmAccount,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'verificationCode': verificationCode
        },
      );
      // if success
      if (response.data['responseCode'] == 200) {
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Login
  static Future<UserInfo?> login(
      {required String? username,
      required String? email,
      required String password}) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.login,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'userInfo': {
            'username': username,
            'email': email,
            'password': password,
          }
        },
      );
      // if success
      if (response.data['responseCode'] == 200 &&
          response.data['jwt_token'] != null) {
        // get jwt token
        String jwtToken = response.data['jwt_token'];
        // store jwt_token to storage
        SecureStorage secureStorage = SecureStorage();
        secureStorage.writeSecureData('jwt_token', jwtToken);

        // print JWT token
        log("jwt token: ${response.data["jwt_token"]}");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
