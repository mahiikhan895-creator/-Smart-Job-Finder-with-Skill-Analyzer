// lib/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _controller;

  Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast();
    _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      _controller!.add(isOnline);
    });
    return _controller!.stream;
  }

  Future<bool> isOnline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}