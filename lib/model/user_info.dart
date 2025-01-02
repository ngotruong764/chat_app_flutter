import 'dart:typed_data';

import '../helper/helper.dart';

class UserInfo {
  int? id;
  String? email;
  String? password;
  String? verificationCode;
  DateTime? codeCreateAt;
  bool? isActive;
  String? firstname;
  String? lastname;
  String? username;
  String? phoneNumber;
  DateTime? dob;
  String? sex;
  bool? status; // true: online - false: offline
  String? profilePicture;
  String? profilePictureBase64;
  Uint8List? profilePictureBytes;
  DateTime? createAt;
  DateTime? updateAt;
  String? role;
  bool? active;
  String? deviceToken;

  UserInfo(
      {this.id,
      this.email,
      this.password,
      this.verificationCode,
      this.codeCreateAt,
      this.isActive,
      this.firstname,
      this.lastname,
      this.username,
      this.phoneNumber,
      this.dob,
      this.sex,
      this.status,
      this.profilePicture,
      this.profilePictureBase64,
      this.profilePictureBytes,
      this.createAt,
      this.updateAt,
      this.role,
      this.active,
      this.deviceToken});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    String profilePicture = json['profilePictureBase64'] ?? '';
    Uint8List profilePicturesBytes = Uint8List.fromList([]);
    if(profilePicture.isNotEmpty){
      profilePicturesBytes = Helper.encodeAnBase64ToBytesSync(profilePicture);
    }

    return  UserInfo(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      verificationCode: json['verificationCode'],
      codeCreateAt: json['codeCreateAt'] != null
          ? DateTime.parse(json['codeCreateAt'])
          : null,
      isActive: json['active'],
      firstname: json['firstName'],
      lastname: json['lastName'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      sex: json['sex'],
      status: json['status'],
      profilePicture: json['profilePicture'],
      profilePictureBase64: json['profilePictureBase64'],
      profilePictureBytes: profilePicturesBytes,
      createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
      updateAt:
          json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
      role: json['role'],
      deviceToken: json['deviceToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'verificationCode': verificationCode,
      'codeCreateAt': codeCreateAt?.toIso8601String(),
      'active': isActive,
      'firstName': firstname,
      'lastName': lastname,
      'username': username,
      'phoneNumber': phoneNumber,
      'dob': dob?.toIso8601String(),
      'sex': sex,
      'status': status,
      'profilePicture': profilePicture,
      'profilePictureBase64': profilePictureBase64,
      'createAt': createAt?.toIso8601String(),
      'updateAt': updateAt?.toIso8601String(),
      'role': role?.toString(),
      'deviceToken': deviceToken
    };
  }
}
