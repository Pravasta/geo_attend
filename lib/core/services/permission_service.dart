import 'package:permission_handler/permission_handler.dart';

/// Kontrak pengelolaan izin lokasi.
abstract class PermissionService {
  /// Apakah izin lokasi sudah diberikan.
  Future<bool> hasLocationPermission();

  /// Meminta izin lokasi; mengembalikan `true` bila diberikan.
  Future<bool> requestLocationPermission();

  /// Apakah izin lokasi ditolak permanen (perlu diaktifkan via pengaturan).
  Future<bool> isPermanentlyDenied();

  /// Membuka halaman pengaturan aplikasi agar pengguna bisa mengaktifkan izin.
  Future<bool> openSettings();
}

/// Implementasi [PermissionService] menggunakan `permission_handler`.
class PermissionServiceImpl implements PermissionService {
  final Permission _locationPermission;

  PermissionServiceImpl([this._locationPermission = Permission.location]);

  @override
  Future<bool> hasLocationPermission() async {
    final status = await _locationPermission.status;
    return status.isGranted;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final status = await _locationPermission.request();
    return status.isGranted;
  }

  @override
  Future<bool> isPermanentlyDenied() async {
    final status = await _locationPermission.status;
    return status.isPermanentlyDenied;
  }

  @override
  Future<bool> openSettings() => openAppSettings();
}
