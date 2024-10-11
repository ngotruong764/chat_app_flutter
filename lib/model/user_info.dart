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
  bool? status;
  String? profilePicture;
  DateTime? createAt;
  DateTime? updateAt;
  String? role;

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
      this.createAt,
      this.updateAt,
      this.role});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      verificationCode: json['verificationCode'],
      codeCreateAt: json['codeCreateAt'] != null
          ? DateTime.parse(json["created_date"])
          : null,
      isActive: json['isActive'],
      firstname: json['firstName'],
      lastname: json['lastName'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      dob: json['dob'] != null ? DateTime.parse(json["dob"]) : null,
      sex: json['sex'],
      status: json['status'],
      profilePicture: json['profilePicture'],
      createAt: DateTime.parse(json['createdAt']),
      updateAt:
          json['updateAt'] != null ? DateTime.parse(json['createdAt']) : null,
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'verificationCode': verificationCode,
      'codeCreateAt': codeCreateAt?.toIso8601String(),
      'isActive': isActive,
      'firstName': firstname,
      'lastName': lastname,
      'username': username,
      'phoneNumber': phoneNumber,
      'dob': dob?.toIso8601String(),
      'sex': sex,
      'status': status,
      'profilePicture': profilePicture,
      'createAt': createAt?.toIso8601String(),
      'updateAt': updateAt?.toIso8601String(),
      'role': role?.toString(),
    };
  }
}
