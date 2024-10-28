class Conversation{
  int? id;
  String? conservationName;
  String? lastMessage;
  DateTime? lastMessageTime;

  Conversation({
    this.id,
    this.conservationName,
    this.lastMessage,
    this.lastMessageTime
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return  Conversation(
      id: json['conversationId'] ?? -1,
      conservationName: json['conversationName'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null ? DateTime.parse(json['lastMessageTime']) : null,
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