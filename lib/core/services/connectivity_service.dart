import 'package:connectivity_plus/connectivity_plus.dart';

/// Kontrak pengecekan konektivitas internet.
abstract class ConnectivityService {
  /// Apakah perangkat terhubung ke jaringan (wifi/seluler/ethernet).
  Future<bool> isConnected();
}

/// Implementasi [ConnectivityService] menggunakan `connectivity_plus`.
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
