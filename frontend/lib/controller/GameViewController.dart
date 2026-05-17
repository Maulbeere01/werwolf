import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/auth/auth_state.dart';
import '../generated/werwolf.pb.dart';

class GameViewController {
  static Future<String?> createLobby(LobbySettings settings) async {
    final grpc = await GrpcHandler.create();
    try {
      final request = CreateLobbyRequest()..settings = settings;
      final response = await grpc.gameClient.createLobby(request);
      AuthState.lobbyCode = response.lobbyCode;
      print('[LOBBY] Created lobby with code: ${response.lobbyCode}');
      return response.lobbyCode;
    } catch (e) {
      print('[LOBBY] Error creating lobby: $e');
      return null;
    }
  }

  static Future<String?> joinLobby(String lobbyCode) async {
    final grpc = await GrpcHandler.create();
    try {
      final request = JoinRequest()..lobbyCode = lobbyCode;
      final response = await grpc.gameClient.joinLobby(request);
      AuthState.lobbyCode = response.lobbyCode;
      print('[LOBBY] Joined lobby with code: ${response.lobbyCode}');
      return response.lobbyCode;
    } catch (e) {
      print('[LOBBY] Error joining lobby: $e');
      return null;
    }
  }
}
