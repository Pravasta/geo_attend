import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

/// Mengambil seluruh lokasi tersimpan.
class GetLocations implements UseCase<List<LocationEntity>, NoParams> {
  final LocationRepository repository;

  GetLocations(this.repository);

  @override
  Future<Either<Failure, List<LocationEntity>>> call(NoParams params) {
    return repository.getLocations();
  }
}
