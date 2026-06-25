// Exception pada lapisan data/service.
// Akan ditangkap oleh repository dan dikonversi menjadi Failure.

/// Dilempar saat operasi database gagal.
class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database error']);

  @override
  String toString() => 'DatabaseException: $message';
}

/// Dilempar saat izin lokasi ditolak.
class LocationPermissionDeniedException implements Exception {
  final String message;
  LocationPermissionDeniedException([this.message = 'Location permission denied']);

  @override
  String toString() => 'LocationPermissionDeniedException: $message';
}

/// Dilempar saat layanan lokasi (GPS) tidak aktif.
class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException([this.message = 'Location service disabled']);

  @override
  String toString() => 'LocationServiceDisabledException: $message';
}
