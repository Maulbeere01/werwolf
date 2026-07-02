import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:werwolf/auth/auth_interceptor.dart';
import 'package:werwolf/generated/werwolf.pbgrpc.dart';

/// Holds the single shared gRPC channel and its service clients.
///
/// Use [instance] everywhere: the channel (and its TCP/TLS connection) is
/// created lazily on first use and then reused for the whole app lifetime. The
/// [AuthInterceptor] reads the current token per request, so a long-lived
/// client always sends the up-to-date credentials.
class GrpcHandler {
  late final GameServiceClient gameClient;
  late final UserServiceClient userClient;
  final ClientChannel _channel;

  GrpcHandler._internal(this._channel) {
    final interceptors = [AuthInterceptor()];
    gameClient = GameServiceClient(_channel, interceptors: interceptors);
    userClient = UserServiceClient(_channel, interceptors: interceptors);
  }

  static GrpcHandler? _instance;
  static Future<GrpcHandler>? _pending;

  /// The shared handler. Opens the channel once on first call; subsequent calls
  /// return the same instance. Concurrent first calls share one initialization.
  static Future<GrpcHandler> instance() {
    final existing = _instance;
    if (existing != null) return Future.value(existing);
    return _pending ??= _create().then((handler) {
      _instance = handler;
      _pending = null;
      return handler;
    });
  }

  /// Closes the channel and clears the singleton. The next [instance] call
  /// opens a fresh connection. Use when tearing down the session.
  static Future<void> reset() async {
    final inst = _instance;
    _instance = null;
    _pending = null;
    await inst?._channel.shutdown();
  }

  static Future<GrpcHandler> _create() async {
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
