import 'dart:typed_data';

import 'package:chat_app_flutter/helper/helper.dart';

class Attachment{
  int? id; // attachment id
  String? fileName;
  String? fileType;
  String? fileUrl;
  int? messageId;
  String? attachmentContent;
  List<int>? attachmentContentByte = [];

  Attachment({
    this.id,
    this.fileName,
    this.fileType,
    this.fileUrl,
    this.messageId,
    this.attachmentContent,
    this.attachmentContentByte,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    String attachmentContent = json['attachmentContent'] ?? '';
    Uint8List contentUint8List = Uint8List(0);
    // decode base64 to Uint8List
    if(attachmentContent.isNotEmpty){
      contentUint8List = Helper.encodeAnBase64ToBytesSync(attachmentContent);
    }

    return Attachment(
      id: json['conversationId'] ?? -1,
      fileName: json['fileName'],
      fileType: json['fileType'],
      fileUrl: json['fileUrl'],
      messageId: json[''],
      attachmentContent: attachmentContent,
      attachmentContentByte: contentUint8List.isEmpty ? [] : contentUint8List.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'attachmentContent': attachmentContent,
    };
  }
}