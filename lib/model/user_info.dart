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
  bool? active;

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
      this.role,
      this.active});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
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
      createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
      updateAt:
          json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
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
      'active': isActive,
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
