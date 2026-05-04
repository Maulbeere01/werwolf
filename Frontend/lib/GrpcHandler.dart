import 'package:grpc/grpc.dart';
import '../generated/werwolf.pbgrpc.dart';

class GrpcHandler {
  late GameServiceClient gameClient;
  late UserServiceClient userClient;

  GrpcHandler() {
    //Client erstellen
    final channel = ClientChannel(
      '192.168.178.105',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    // Initialisiere die Stubs
    gameClient = GameServiceClient(channel);
    userClient = UserServiceClient(channel);
  }
}