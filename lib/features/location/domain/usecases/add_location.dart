import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

/// Menambahkan lokasi baru.
class AddLocation implements UseCase<LocationEntity, LocationEntity> {
  final LocationRepository repository;

  AddLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity>> call(LocationEntity params) {
    return repository.addLocation(params);
  }
}
