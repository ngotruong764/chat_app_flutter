class Message{
  int? id; // message id
  int userId;
  String? senderName;
  int conversationId;
  String content;
  DateTime messageTime;

  Message({
    this.id,
    required this.userId,
    this.senderName,
    required this.conversationId,
    required this.content,
    required this.messageTime
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return  Message(
      id: json['conversationId'] ?? -1,
      userId: json['userId'] ?? -1,
      senderName: json['senderName'] ?? '',
      conversationId: json['conversationId'] ?? -1,
      content: json['content'],
      messageTime: DateTime.parse(json['messageTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'conversationId': conversationId,
      'content': content,
      'messageTime': messageTime.toIso8601String(),
    };
  }
}