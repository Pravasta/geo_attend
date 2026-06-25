import 'package:geocoding/geocoding.dart';

/// Kontrak reverse geocoding (koordinat → alamat).
abstract class GeocodingService {
  /// Mengembalikan alamat ringkas untuk [latitude]/[longitude],
  /// atau `null` bila tidak ditemukan / gagal.
  Future<String?> getAddress(double latitude, double longitude);
}

/// Implementasi [GeocodingService] menggunakan package `geocoding`.
class GeocodingServiceImpl implements GeocodingService {
  @override
  Future<String?> getAddress(double latitude, double longitude) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) return null;

    final p = placemarks.first;
    final parts = <String?>[
      p.street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
    ].where((e) => e != null && e.trim().isNotEmpty).toList();

    return parts.isEmpty ? null : parts.join(', ');
  }
}
