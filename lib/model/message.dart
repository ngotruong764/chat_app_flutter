import 'package:chat_app_flutter/model/attachment.dart';

class Message {
  int? id; // message id
  int userId;
  String? senderName;
  int conversationId;
  String? conversationName;
  String content;
  List<Attachment>? attachments; // when receive response --> never null , but can empty --> need to check empty only
  DateTime messageTime;
  // String mediaUrl;

  Message({
    this.id,
    required this.userId,
    this.senderName,
    this.conversationName,
    required this.conversationId,
    required this.content,
    required this.messageTime,
    this.attachments,
    // this.mediaUrl = '',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // get Attachment list
    List<Attachment> attachments = [];
    List<dynamic> attachmentsJson = json['attachments'] ?? [];
    if(attachmentsJson.isNotEmpty){
      attachments.addAll(attachmentsJson.map((json) => Attachment.fromJson(json)).toList());
    }

    return Message(
      id: json['conversationId'] ?? -1,
      userId: json['userId'] ?? -1,
      senderName: json['senderName'] ?? '',
      conversationId: json['conversationId'] ?? -1,
      content: json['content'] ?? '',
      messageTime: DateTime.parse(json['messageTime']),
      // mediaUrl: json['mediaUrl'] ?? '',
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'conversationId': conversationId,
      'conversationName': conversationName,
      'content': content,
      'attachments': attachments,
      // 'mediaUrl': mediaUrl,
      'messageTime': messageTime.toIso8601String(),
    };
  }
}
