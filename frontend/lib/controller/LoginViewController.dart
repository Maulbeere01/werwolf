import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/auth/auth_state.dart';
import '../generated/werwolf.pb.dart';

class LoginViewController  {

  static Future<bool> loginUser(String username, String password) async {
    final grpc = await GrpcHandler.create();

    try {
      var request = LoginRequest();
      request.username = username;
      request.password = password;

      final response = await grpc.userClient.login(request);
      AuthState.token = response.token;

      print('[LOGIN] Success — userId=${response.profile.userId}, username=${response.profile.username}');
      print('[LOGIN] Token: ${response.token.substring(0, 20)}...');
      return true;
    } catch (e) {
      print('[LOGIN] Error: $e');
      return false;
    }
  }
}