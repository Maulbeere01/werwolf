import 'package:grpc/grpc.dart';
import 'auth_state.dart';

class AuthInterceptor implements ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
      ClientMethod<Q, R> method,
      Q request,
      CallOptions options,
      ClientUnaryInvoker<Q, R> invoker) {
    return invoker(method, request, _withToken(options));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    return invoker(method, requests, _withToken(options));
  }

  CallOptions _withToken(CallOptions options) {
    final token = AuthState.token;
    if (token == null) {
      print('[AUTH] No token: sending unauthenticated request');
      return options;
    }
    print('[AUTH] Attaching token to request');
    return options.mergedWith(
      CallOptions(metadata: {'authorization': 'Bearer $token'}),
    );
  }
}
