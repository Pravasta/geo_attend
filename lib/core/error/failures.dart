import 'package:equatable/equatable.dart';

/// Representasi kegagalan pada lapisan domain.
///
/// Dikembalikan melalui `Either<Failure, T>` agar error tertangani secara
/// eksplisit tanpa melempar exception ke lapisan presentation.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Kegagalan terkait operasi database lokal.
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Terjadi kesalahan pada database.']);
}

/// Kegagalan karena izin lokasi tidak diberikan.
class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure([
    super.message = 'Izin lokasi tidak diberikan.',
  ]);
}

/// Kegagalan karena layanan lokasi (GPS) tidak aktif.
class LocationServiceFailure extends Failure {
  const LocationServiceFailure([
    super.message = 'Layanan lokasi (GPS) tidak aktif.',
  ]);
}

/// Kegagalan umum saat mengambil posisi GPS.
class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Gagal mendapatkan lokasi.']);
}

/// Kegagalan karena tidak ada koneksi internet.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet.']);
}

/// Kegagalan yang tidak terduga / belum terkategori.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Terjadi kesalahan yang tidak terduga.',
  ]);
}
