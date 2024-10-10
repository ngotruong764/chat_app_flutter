import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async{
    await flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async{
    String? data = await flutterSecureStorage.read(key: key);
    return data;
  }

  deleteSecureData(String key) async{
    await flutterSecureStorage.delete(key: key);
  }
}