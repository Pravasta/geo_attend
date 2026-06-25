import 'package:geolocator/geolocator.dart';

/// Utilitas perhitungan jarak antar koordinat dan pengecekan radius.
///
/// Logika inti verifikasi absensi (apakah pengguna berada dalam radius) berada
/// di sini agar mudah diuji secara terisolasi.
class DistanceCalculator {
  const DistanceCalculator();

  /// Menghitung jarak (meter) antara dua titik koordinat menggunakan
  /// `Geolocator.distanceBetween` (formula Haversine).
  double distanceInMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Mengembalikan `true` jika [distanceMeters] berada dalam (≤) [radiusMeters].
  ///
  /// Tepat di batas radius dianggap masih di dalam (diterima).
  bool isWithinRadius(double distanceMeters, double radiusMeters) {
    return distanceMeters <= radiusMeters;
  }
}
