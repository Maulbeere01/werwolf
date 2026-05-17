import 'package:werwolf/GrpcHandler.dart';
import '../generated/werwolf.pb.dart';

class GameViewController {
  static Future<String?> createLobby(LobbySettings settings) async {
    final grpc = await GrpcHandler.create();
    try {
      final request = CreateLobbyRequest()..settings = settings;
      final response = await grpc.gameClient.createLobby(request);
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
      print('[LOBBY] Joined lobby with code: ${response.lobbyCode}');
      return response.lobbyCode;
    } catch (e) {
      print('[LOBBY] Error joining lobby: $e');
      return null;
    }
  }
}
