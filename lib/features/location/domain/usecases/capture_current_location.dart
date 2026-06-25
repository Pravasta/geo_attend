import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/captured_location.dart';
import '../repositories/location_repository.dart';

/// Geotagging: mengambil koordinat GPS saat ini (+ alamat bila ada koneksi).
class CaptureCurrentLocation implements UseCase<CapturedLocation, NoParams> {
  final LocationRepository repository;

  CaptureCurrentLocation(this.repository);

  @override
  Future<Either<Failure, CapturedLocation>> call(NoParams params) {
    return repository.captureCurrentLocation();
  }
}
