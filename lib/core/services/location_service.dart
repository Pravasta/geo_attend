// Sembunyikan exception bawaan geolocator yang namanya bentrok dengan milik
// aplikasi (core/error/exceptions.dart).
import 'package:geolocator/geolocator.dart' hide LocationServiceDisabledException;

import '../error/exceptions.dart';
import 'permission_service.dart';

/// Kontrak pengambilan lokasi GPS perangkat.
abstract class LocationService {
  /// Apakah layanan lokasi (GPS) perangkat aktif.
  Future<bool> isLocationServiceEnabled();

  /// Mengambil posisi GPS pengguna saat ini.
  ///
  /// Melempar [LocationServiceDisabledException] bila GPS mati, atau
  /// [LocationPermissionDeniedException] bila izin tidak diberikan.
  Future<Position> getCurrentPosition();
}

/// Implementasi [LocationService] menggunakan `geolocator`.
class LocationServiceImpl implements LocationService {
  final GeolocatorPlatform _geolocator;
  final PermissionService _permissionService;

  LocationServiceImpl(
    this._permissionService, {
    GeolocatorPlatform? geolocator,
  }) : _geolocator = geolocator ?? GeolocatorPlatform.instance;

  @override
  Future<bool> isLocationServiceEnabled() {
    return _geolocator.isLocationServiceEnabled();
  }

  @override
  Future<Position> getCurrentPosition() async {
    if (!await isLocationServiceEnabled()) {
      throw LocationServiceDisabledException();
    }

    if (!await _permissionService.hasLocationPermission()) {
      final granted = await _permissionService.requestLocationPermission();
      if (!granted) {
        throw LocationPermissionDeniedException();
      }
    }

    return _geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
