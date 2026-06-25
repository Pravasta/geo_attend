import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

/// Menghapus lokasi berdasarkan id.
class DeleteLocation implements UseCase<Unit, int> {
  final LocationRepository repository;

  DeleteLocation(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return repository.deleteLocation(params);
  }
}
