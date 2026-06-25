import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

/// Melakukan absensi terhadap sebuah lokasi (verifikasi radius).
class SubmitAttendance implements UseCase<AttendanceEntity, LocationEntity> {
  final AttendanceRepository repository;

  SubmitAttendance(this.repository);

  @override
  Future<Either<Failure, AttendanceEntity>> call(LocationEntity params) {
    return repository.submitAttendance(params);
  }
}
