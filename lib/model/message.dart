class Message {
  int? id; // message id
  int userId;
  String? senderName;
  int conversationId;
  String? conversationName;
  String content;
  List<dynamic>? attachments;
  DateTime messageTime;
  String mediaUrl;

  Message({
    this.id,
    required this.userId,
    this.senderName,
    this.conversationName,
    required this.conversationId,
    required this.content,
    required this.messageTime,
    this.attachments,
    this.mediaUrl = '',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['conversationId'] ?? -1,
      userId: json['userId'] ?? -1,
      senderName: json['senderName'] ?? '',
      conversationId: json['conversationId'] ?? -1,
      content: json['content'] ?? '',
      messageTime: DateTime.parse(json['messageTime']),
      mediaUrl: json['mediaUrl'] ?? '',
      attachments: json['attachments'] ?? [],
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
      'mediaUrl': mediaUrl,
      'messageTime': messageTime.toIso8601String(),
    };
  }
}
