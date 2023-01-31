import 'package:aptos_wallet/services/mnemonics_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> writeSecureData(MnemoniceData newItem) async {
    await _secureStorage.write(key: newItem.key, value: newItem.value);
    debugPrint('writeSecureData: ${newItem.key} ${newItem.value}');
  }

  Future<String?> readSecureData(String key) async {
    debugPrint('readSecureData $key');
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    debugPrint('deleteSecureData $key');
    await _secureStorage.delete(key: key);
  }

  Future<bool> containsKeyInSecureData(String key) async {
    debugPrint('containsKeyInSecureData $key');
    return await _secureStorage.containsKey(key: key);
  }
}
