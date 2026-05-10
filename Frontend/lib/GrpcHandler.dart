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
    // assets/config laden
    final String response = await rootBundle.loadString('assets/config.json');
    final data = json.decode(response);

    // Client erstellen mit den Daten aus der JSON
    final channel = ClientChannel(
      data['server_ip'],
      port: data['server_port'],
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    print("gRPC connected to ${data['server_ip']}:${data['server_port']}");

    return GrpcHandler._internal(channel);
  }
}