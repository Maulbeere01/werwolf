import 'package:werwolf/services/grpc_handler.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

class GameViewController {
  static Future<String?> createLobby(LobbySettings settings) async {
    final grpc = await GrpcHandler.instance();
    try {
      final request = CreateLobbyRequest()..settings = settings;
      final response = await grpc.gameClient.createLobby(request);
      AuthState.lobbyCode = response.lobbyCode;
      await SessionStore.save();
      print('[LOBBY] Created lobby with code: ${response.lobbyCode}');
      return response.lobbyCode;
    } catch (e) {
      print('[LOBBY] Error creating lobby: $e');
      return null;
    }
  }

  static Future<bool> performAction(GameAction action) async {
    final grpc = await GrpcHandler.instance();
    try {
      await grpc.gameClient.performAction(action);
      return true;
    } catch (e) {
      print('[ACTION] Error performing action: $e');
      return false;
    }
  }

  static Future<String?> joinLobby(String lobbyCode) async {
    final grpc = await GrpcHandler.instance();
    try {
      final request = JoinRequest()..lobbyCode = lobbyCode;
      final response = await grpc.gameClient.joinLobby(request);
      AuthState.lobbyCode = response.lobbyCode;
      await SessionStore.save();
      print('[LOBBY] Joined lobby with code: ${response.lobbyCode}');
      return response.lobbyCode;
    } catch (e) {
      print('[LOBBY] Error joining lobby: $e');
      return null;
    }
  }
}
