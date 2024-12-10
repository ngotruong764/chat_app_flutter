import 'dart:convert';
import 'package:chat_app_flutter/data/api/apis_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class Helper{
  static Future<List<String>> encodeImgToBase64(List<XFile> medias) async {
    List<String> encodedMediaBase64 = [];
    for(XFile media in medias){
      final List<int> bytes = await io.File(media.path).readAsBytes();
      String base64Encoded = base64Encode(bytes);
      encodedMediaBase64.add(base64Encoded);
      await ApisChat.sendMedia(base64Encoded: base64Encoded);
    }
    return encodedMediaBase64;
  }

  static Future<List<int>> encodeAnImgToBytes(XFile img) async {
    List<String> encodedMediaBase64 = [];
    final List<int> bytes = await io.File(img.path).readAsBytes();
    return bytes;
  }
}