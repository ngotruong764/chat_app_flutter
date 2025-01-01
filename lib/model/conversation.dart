import 'dart:typed_data';

import 'package:chat_app_flutter/helper/helper.dart';

 class Conversation{
  int? id;
  String? conservationName;
  String? lastMessage;
  DateTime? lastMessageTime;
  int? userLastMessageId;
  String? userLastMessageName; // user name
  String? conservationAvatarBase64;
  Uint8List? conservationAvatarBytes;

  Conversation({
    this.id,
    this.conservationName,
    this.lastMessage,
    this.lastMessageTime,
    this.userLastMessageId,
    this.userLastMessageName,
    this.conservationAvatarBase64,
    this.conservationAvatarBytes,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    String conservationAvatarBase64 = json['conservationAvatar'] ?? '';
    Uint8List conservationAvatarBytes = Uint8List.fromList([]);
    if(conservationAvatarBase64.isNotEmpty){
      conservationAvatarBytes = Helper.encodeAnBase64ToBytesSync(conservationAvatarBase64);
    }
    return  Conversation(
      id: json['conversationId'] ?? -1,
      conservationName: json['conversationName'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null ? DateTime.parse(json['lastMessageTime']) : null,
      userLastMessageId: json['userLastMessageId'],
      userLastMessageName: json['userLastMessageName'] ,
      conservationAvatarBase64: conservationAvatarBase64,
      conservationAvatarBytes: conservationAvatarBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationName': conservationName,
      'lastMessage': lastMessageTime,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
    };
  }
}