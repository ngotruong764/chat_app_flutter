import 'dart:convert';
import 'dart:developer';
import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../helper/helper.dart';
import '../../services/push_notifications_service.dart';

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
      if(response.data['responseCode'] == 200
          && response.data['userInfo'] != null){
        UserInfo userInfo = UserInfo.fromJson(response.data['userInfo']);
        ApisBase.currentUser = userInfo;
        return userInfo;
      }
      return null;
    } catch(e){
      e.printError();
      return null;
    }
  }

  // Login
  static Future<UserInfo?> confirmAccount(
      {required UserInfo userInfo}) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.confirmAccount,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'userInfo': userInfo
        },
      );
      // if success
      if (response.data['responseCode'] == 200
          && response.data['userInfo'] != null) {
        UserInfo userInfo = UserInfo.fromJson(response.data['userInfo']);
        ApisBase.currentUser = userInfo;
        return userInfo;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Login
  static Future<UserInfo?> login(
      {required UserInfo userInfo}) async {
    try {
      // Get device token
      await PushNotificationsService.getDeviceToken();
      // Constants.DEVICE_TOKEN = '';
      userInfo.deviceToken = Constants.DEVICE_TOKEN;
      //
      final response = await ApisBase.dio.post(
        ApisBase.login,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'userInfo': userInfo,
        },
      );
      // if success
      if (response.data['responseCode'] == 200
          && response.data['jwt_token'] != null
          && response.data['userInfo'] != null) {
        // get shared preferences instance
        final UserInfo user = UserInfo.fromJson(response.data['userInfo']);
        ApisBase.currentUser = user;
        final prefs = await SharedPreferences.getInstance();

        // save user info to local
        user.password = userInfo.password!;
        prefs.setString('userInfo', jsonEncode(user));

        // add jwt token to header
        ApisBase.dio.options.headers['Authorization'] =
          'Bearer ${response.data["jwt_token"]}';

        // print JWT token
        log("jwt token: ${response.data["jwt_token"]}");

        // get user avatar
        if(user.profilePicture != null){
          if(user.profilePicture!.isNotEmpty){
            String userAvatarBase64Encoded = user.profilePicture!;

            // convert user avatar to byte[]
            List<int> bytes = await Helper.encodeAnBase64ToBytes(userAvatarBase64Encoded);

            if(bytes.isNotEmpty){
              // set user avatar
              Constants.USER_AVATAR.value = bytes;
            }
          }
        }
        return user;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<void> logout(UserInfo userInfo) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.logout,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'userInfo': userInfo
        }
      );
    } catch (e) {
      log(e.toString());
    }
  }

  // update user-info
  static Future<UserInfo?> updateUserInfo(
      {required UserInfo userInfo}) async {
    try {
      final response = await ApisBase.dio.post(
        ApisBase.updateUserInfo,
        options: Options(
          contentType: 'application/json',
        ),
        data: {
          'userInfo': userInfo.toJson(),
        },
      );
      // if success
      if (response.data['responseCode'] == 200
          && response.data['userInfo'] != null) {
        print(response.data);
        UserInfo userInfo = UserInfo.fromJson(response.data['userInfo']);
        ApisBase.currentUser = userInfo;
        // convert img string to bytes
        if(ApisBase.currentUser.profilePicture != null){

        }
        return userInfo;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
