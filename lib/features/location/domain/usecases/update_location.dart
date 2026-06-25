import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

/// Memperbarui lokasi yang sudah ada.
class UpdateLocation implements UseCase<LocationEntity, LocationEntity> {
  final LocationRepository repository;

  UpdateLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity>> call(LocationEntity params) {
    return repository.updateLocation(params);
  }
}
