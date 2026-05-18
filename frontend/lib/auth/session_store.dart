import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_state.dart';

class SessionStore {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'jwt_token';
  static const _keyUserId = 'user_id';
  static const _keyLobbyCode = 'lobby_code';

  static Future<void> save() async {
    final token = AuthState.token;
    final userId = AuthState.userId;
    final lobbyCode = AuthState.lobbyCode;

    try {
      await Future.wait([
        token != null
            ? _storage.write(key: _keyToken, value: token)
            : _storage.delete(key: _keyToken),
        userId != null
            ? _storage.write(key: _keyUserId, value: userId)
            : _storage.delete(key: _keyUserId),
        lobbyCode != null
            ? _storage.write(key: _keyLobbyCode, value: lobbyCode)
            : _storage.delete(key: _keyLobbyCode),
      ]);
    } on PlatformException catch (e) {
      assert(() {
        print('[SessionStore] save skipped: ${e.message}');
        return true;
      }());
    }
  }

  static Future<void> load() async {
    try {
      AuthState.token = await _storage.read(key: _keyToken);
      AuthState.userId = await _storage.read(key: _keyUserId);
      AuthState.lobbyCode = await _storage.read(key: _keyLobbyCode);
    } on PlatformException catch (e) {
      assert(() {
        // ignore: avoid_print
        print('[SessionStore] load skipped: ${e.message}');
        return true;
      }());
    }
  }

  static Future<void> clearLobbyCode() async {
    AuthState.lobbyCode = null;
    await save();
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } on PlatformException catch (_) {}
    AuthState.token = null;
    AuthState.userId = null;
    AuthState.lobbyCode = null;
  }
}
