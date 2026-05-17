import 'package:werwolf/GrpcHandler.dart';
import '../generated/werwolf.pb.dart';

class LoginViewController  {

  static Future<bool> loginUser(String username, String password) async {
    final grpc = await GrpcHandler.create();

    try {
      var request = LoginRequest();
      request.username = username;
      request.password = password;

      await grpc.userClient.login(request);

      print("Erfolg");
      return true;
    } catch (e) {
      print("Fehler: $e");
      return false;
    }
  }
}