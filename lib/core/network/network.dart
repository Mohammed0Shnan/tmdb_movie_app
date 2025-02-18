import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';  // For InternetAddress.lookup

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<Map<ConnectivityResult, bool>> get connectivityStream;
  void disposeStream();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl._internal();

  static final NetworkInfoImpl _instance = NetworkInfoImpl._internal();

  static NetworkInfoImpl get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<Map<ConnectivityResult, bool>> _controller = StreamController.broadcast();

  @override
  Stream<Map<ConnectivityResult, bool>> get connectivityStream => _controller.stream;

  @override
  void disposeStream() => _controller.close();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result.first == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

}
