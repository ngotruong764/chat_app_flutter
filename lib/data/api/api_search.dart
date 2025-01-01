import 'dart:developer';

import 'package:chat_app_flutter/model/user_info.dart'; // Import class UserInfo
import 'apis_base.dart';
import 'package:dio/dio.dart';

abstract class ApiSearch {
  // Hàm lấy danh sách user từ API
  static Future<List<UserInfo>> fetchUserList(String username, int currentUserId,
      {required int page, required int size}) async {
    try {
      // log("Fetching users...");
      // log('Request Parameters: username=$username, currentUserId=$currentUserId');

      // Gọi API với query parameters
      final response = await Dio().get(
        ApisBase.getListCustomerUrl,
        queryParameters: {
          'username': username,
          'currentUserId': currentUserId,
          'page': page,
          'size': size,
        },
      );

      // Log dữ liệu phản hồi
      // log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map JSON thành danh sách UserInfo
          return (response.data as List)
              .map((json) => UserInfo.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        log('Failed to fetch user list: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      log('Failed to fetch user list: $e');
      return [];
    }
  }

  // Hàm lấy thông tin cụ thể của một khách hàng
  static Future<UserInfo> fetchUserById(int userId) async {
    try {
      // Endpoint có thể cần thêm `/userId` hoặc query parameter
      final url = '${ApisBase.getListCustomerUrl}/$userId';
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return UserInfo.fromJson(data);
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching user: $e');
      throw Exception('Error fetching user: $e');
    }
  }
}
