import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Kontrak dasar untuk seluruh use case.
///
/// [T] adalah tipe hasil sukses, [Params] adalah tipe parameter input.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Digunakan untuk use case yang tidak membutuhkan parameter.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
