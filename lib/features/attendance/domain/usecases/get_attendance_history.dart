import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

/// Mengambil seluruh riwayat absensi.
class GetAttendanceHistory
    implements UseCase<List<AttendanceEntity>, NoParams> {
  final AttendanceRepository repository;

  GetAttendanceHistory(this.repository);

  @override
  Future<Either<Failure, List<AttendanceEntity>>> call(NoParams params) {
    return repository.getAttendanceHistory();
  }
}
