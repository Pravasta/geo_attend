/// Konstanta global aplikasi GeoAttend.
class AppConstants {
  AppConstants._();

  /// Nama aplikasi.
  static const String appName = 'GeoAttend';

  /// Radius default (meter) untuk verifikasi absensi.
  /// Absensi diterima jika jarak pengguna ke titik lokasi <= nilai ini.
  static const double defaultRadiusMeters = 50.0;

  /// Nama file database lokal (Drift/SQLite).
  static const String databaseName = 'geo_attend.sqlite';

  /// Status absensi.
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';
}
