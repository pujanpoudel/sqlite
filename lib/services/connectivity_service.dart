import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  Stream<bool> get connectionStream async* {
    yield await isConnected();
    yield* _connectivity.onConnectivityChanged
        .map((result) => result.first != ConnectivityResult.none);
  }
}
