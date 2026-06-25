import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/database/app_database.dart';
import 'package:geo_attend/features/attendance/data/datasources/attendance_local_datasource.dart';
import 'package:geo_attend/features/attendance/domain/entities/attendance_entity.dart';

void main() {
  late AppDatabase db;
  late AttendanceLocalDataSourceImpl dataSource;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = AttendanceLocalDataSourceImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  AttendanceEntity buildAttendance({
    required AttendanceStatus status,
    double distance = 10,
  }) {
    return AttendanceEntity(
      locationId: null,
      locationName: 'Kantor',
      latitude: -6.2,
      longitude: 106.8,
      distance: distance,
      status: status,
    );
  }

  test('insertAttendance menyimpan dan mengembalikan entity dengan id', () async {
    final result = await dataSource.insertAttendance(
      buildAttendance(status: AttendanceStatus.accepted),
    );

    expect(result.id, isNotNull);
    expect(result.status, AttendanceStatus.accepted);
    expect(result.locationName, 'Kantor');
  });

  test('insertAttendance menyimpan record rejected (sebagai bukti)', () async {
    final result = await dataSource.insertAttendance(
      buildAttendance(status: AttendanceStatus.rejected, distance: 80),
    );

    expect(result.status, AttendanceStatus.rejected);
    expect(result.distance, 80);
  });

  test('getAttendances mengembalikan seluruh riwayat', () async {
    await dataSource
        .insertAttendance(buildAttendance(status: AttendanceStatus.accepted));
    await dataSource
        .insertAttendance(buildAttendance(status: AttendanceStatus.rejected));

    final result = await dataSource.getAttendances();

    expect(result, hasLength(2));
  });
}
