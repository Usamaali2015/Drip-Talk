import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'package:drip_talk/core/services/storage/storage_keys.dart';
import 'package:flutter/foundation.dart';

class ChatSessionRepository {
  ChatSessionRepository(this._secureStorage);

  final SecureStorage _secureStorage;

  Future<int?> getSavedSessionId() async {
    final value = await _secureStorage.readString(StorageKeys.chatSessionId);
    final parsedSessionId = int.tryParse(value ?? '');
    debugPrint(
      'Chat session read: rawSessionId=$value, parsedSessionId=$parsedSessionId',
    );
    return parsedSessionId;
  }

  Future<void> saveSessionId(int sessionId) {
    debugPrint('Chat session save: sessionId=$sessionId');
    return _secureStorage.writeString(
      StorageKeys.chatSessionId,
      sessionId.toString(),
    );
  }

  Future<void> clearSessionId() {
    debugPrint('Chat session clear');
    return _secureStorage.delete(StorageKeys.chatSessionId);
  }
}
