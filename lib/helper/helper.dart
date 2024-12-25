import 'dart:convert';
import 'dart:typed_data';
import 'package:chat_app_flutter/data/api/apis_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

import 'package:intl/intl.dart';

class Helper{
  static Future<List<String>> encodeImgToBase64(List<XFile> medias) async {
    List<String> encodedMediaBase64 = [];
    for(XFile media in medias){
      final List<int> bytes = await io.File(media.path).readAsBytes();
      String base64Encoded = base64Encode(bytes);
      encodedMediaBase64.add(base64Encoded);
      // await ApisChat.sendMedia(base64Encoded: base64Encoded);
    }
    return encodedMediaBase64;
  }

  /*
  * Method to encode an img to base64
  */
  static Future<String> encodeAnImgToBase64(XFile media) async {
    final List<int> bytes = await io.File(media.path).readAsBytes();
    String base64Encoded = base64Encode(bytes);
    return base64Encoded;
  }

  /*
  * Method to encode an img to byte[]
  */
  static Future<List<int>> encodeAnImgToBytes(XFile img) async {
    final List<int> bytes = await io.File(img.path).readAsBytes();
    return bytes;
  }

  /*
  * Method to convert base64 encoded String to byte[]
  */
  static Future<List<int>> encodeAnBase64ToBytes(String base64) async {
    final List<int> bytes = base64Decode(base64);
    return bytes;
  }

  /*
  * Method to convert base64 encoded String to byte[]
  */
  static Uint8List encodeAnBase64ToBytesSync(String base64data) {
    Uint8List bytes = base64.decode(base64data);
    return bytes;
  }

  static String formatLastMessageTime(DateTime lastMessageTime){
    String formattedTime = '';
    DateTime currentTime = DateTime.now();

    if(currentTime.difference(lastMessageTime).inSeconds < 60){
      // if less than 60 second
      formattedTime = 'Just now';
    } else if(currentTime.difference(lastMessageTime).inDays < 1){
      // if than 1 day
      formattedTime = '${lastMessageTime.hour.toString().padLeft(2, '0')}:${lastMessageTime.minute.toString().padLeft(2, '0')}';
    } else if(currentTime.year > lastMessageTime.year){
      // if currentTime.year > lastMessageTime.year
      formattedTime = DateFormat('MMM dd, yyyy').format(lastMessageTime);
    } else if(currentTime.difference(lastMessageTime).inDays >= 1) {
      // if greater than 1 day
      formattedTime = DateFormat('MMM, dd').format(lastMessageTime);
    }

    return formattedTime;
  }
}