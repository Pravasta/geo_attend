import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/captured_location.dart';
import '../entities/location_entity.dart';

/// Kontrak repository untuk fitur Manajemen Lokasi.
abstract class LocationRepository {
  /// Mengambil seluruh lokasi tersimpan (terbaru lebih dulu).
  Future<Either<Failure, List<LocationEntity>>> getLocations();

  /// Menambahkan lokasi baru; mengembalikan lokasi dengan `id` terisi.
  Future<Either<Failure, LocationEntity>> addLocation(LocationEntity location);

  /// Memperbarui lokasi yang sudah ada.
  Future<Either<Failure, LocationEntity>> updateLocation(
    LocationEntity location,
  );

  /// Menghapus lokasi berdasarkan [id].
  Future<Either<Failure, Unit>> deleteLocation(int id);

  /// Geotagging: mengambil koordinat GPS saat ini + alamat (jika ada koneksi).
  Future<Either<Failure, CapturedLocation>> captureCurrentLocation();
}
