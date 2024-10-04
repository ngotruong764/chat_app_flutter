class UserInfo {
  int? id;
  String email;
  String password;
  String? verificationCode;
  DateTime? codeCreateAt;
  bool? isActive;
  String? firstname;
  String? lastname;
  String? username;
  String? phoneNumber;
  bool? sex;
  bool? status;
  String? profilePicture;
  DateTime createAt;
  DateTime? updateAt;
  String? role;

  UserInfo(
      {this.id,
      required this.email,
      required this.password,
      this.verificationCode,
      this.codeCreateAt,
      this.isActive,
      this.firstname,
      this.lastname,
      this.username,
      this.phoneNumber,
      this.sex,
      this.status,
      this.profilePicture,
      required this.createAt,
      this.updateAt,
      this.role});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      verificationCode: json['verificationCode'],
      codeCreateAt: json['codeCreateAt'] != null ? DateTime.parse(json["created_date"]) : null,
      isActive: json['isActive'],
      firstname: json['firstName'],
      lastname: json['lastName'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      sex: json['sex'],
      status: json['status'],
      profilePicture: json['profilePicture'],
      createAt: DateTime.parse(json['createdAt']) ,
      updateAt: json['updateAt'] != null ? DateTime.parse(json['createdAt']) : null,
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
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'status': status,
      'profilePicture': profilePicture,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt?.toIso8601String(),
      'role': role?.toString(),
    };
  }
}
