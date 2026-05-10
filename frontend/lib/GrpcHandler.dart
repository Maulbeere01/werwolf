import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import '../generated/werwolf.pbgrpc.dart';

class GrpcHandler {
  late GameServiceClient gameClient;
  late UserServiceClient userClient;

  GrpcHandler._internal(ClientChannel channel) {
    // Initialisiere die Stubs
    gameClient = GameServiceClient(channel);
    userClient = UserServiceClient(channel);
  }

  static Future<GrpcHandler> create() async {
    const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    final configPath = appEnv == 'prod'
        ? 'assets/config.prod.json'
        : 'assets/config.json';

    // assets/config laden
    final String response = await rootBundle.loadString(configPath);
    final data = json.decode(response);
    final useTls = data['use_tls'] == true;

    // Client erstellen mit den Daten aus der JSON
    final channel = ClientChannel(
      data['server_ip'],
      port: data['server_port'],
      options: ChannelOptions(
        credentials: useTls
            ? const ChannelCredentials.secure()
            : const ChannelCredentials.insecure(),
      ),
    );

    print("gRPC connected to ${data['server_ip']}:${data['server_port']} ($appEnv)");

    return GrpcHandler._internal(channel);
  }
}