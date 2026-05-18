import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:werwolf/auth/auth_interceptor.dart';
import '../generated/werwolf.pbgrpc.dart';

class GrpcHandler {
  late GameServiceClient gameClient;
  late UserServiceClient userClient;

  GrpcHandler._internal(ClientChannel channel) {
    final interceptors = [AuthInterceptor()];
    gameClient = GameServiceClient(channel, interceptors: interceptors);
    userClient = UserServiceClient(channel, interceptors: interceptors);
  }

  static Future<GrpcHandler> create() async {
    const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    final configPath = appEnv == 'prod'
        ? 'assets/config.prod.json'
        : 'assets/config.json';

    final String response = await rootBundle.loadString(configPath);
    final data = json.decode(response);
    final useTls = data['use_tls'] == true;

    final channel = ClientChannel(
      data['server_ip'],
      port: data['server_port'],
      options: ChannelOptions(
        credentials: useTls
            ? const ChannelCredentials.secure()
            : const ChannelCredentials.insecure(),
        // ping server every 60 s; drop the connection after 20 s without a reply
        // mirrors server keepalive so both ends detect silent failures
        keepAlive: const ClientKeepAliveOptions(
          pingInterval: Duration(seconds: 60),
          timeout: Duration(seconds: 20),
          permitWithoutCalls: true,
        ),
      ),
    );

    print("gRPC connected to ${data['server_ip']}:${data['server_port']} ($appEnv)");

    return GrpcHandler._internal(channel);
  }
}