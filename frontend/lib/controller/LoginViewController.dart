import 'package:werwolf/grpc_handler.dart';
import '../generated/werwolf.pb.dart';

class LoginViewController  {

  //Kontrolliert, ob Email-Adresse das richtige Format hat
  static String? validateMail (String? value) {
    if (value == null || value.isEmpty) {
      return "Bitte gib eine gültige E-Mail Adresse ein";
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if(!emailRegExp.hasMatch(value)) {
      return "Ungültiges E-Mail Format";
    }
    return null;
  }

  static Future<void> loginUser(String username, String password) async {
    final grpc = await GrpcHandler.create();

    try {
      var request = LoginRequest();
      request.username = username;
      request.password = password;

      //await wartet bis Antwort vom Server
      await grpc.userClient.login(request);

      print("Erfolg");
    } catch (e) {
      print("Fehler: $e");
    }
  }
}