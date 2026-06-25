import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/attendance_entity.dart';
import '../models/attendance_model.dart';

/// Sumber data lokal (Drift) untuk absensi.
abstract class AttendanceLocalDataSource {
  Future<AttendanceEntity> insertAttendance(AttendanceEntity attendance);
  Future<List<AttendanceEntity>> getAttendances();
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final AppDatabase database;

  AttendanceLocalDataSourceImpl(this.database);

  @override
  Future<AttendanceEntity> insertAttendance(AttendanceEntity attendance) async {
    try {
      final row = await database
          .into(database.attendances)
          .insertReturning(attendance.toInsertCompanion());
      return row.toEntity();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<AttendanceEntity>> getAttendances() async {
    try {
      final query = database.select(database.attendances)
        ..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]);
      final rows = await query.get();
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
