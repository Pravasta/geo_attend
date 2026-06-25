import 'package:drift/drift.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/attendance_entity.dart';

/// Konversi [AttendanceStatus] ↔ string penyimpanan database.
extension AttendanceStatusMapper on AttendanceStatus {
  String get dbValue => this == AttendanceStatus.accepted
      ? AppConstants.statusAccepted
      : AppConstants.statusRejected;
}

AttendanceStatus attendanceStatusFromDb(String value) {
  return value == AppConstants.statusAccepted
      ? AttendanceStatus.accepted
      : AttendanceStatus.rejected;
}

/// Mapper antara baris Drift (`Attendance`) dan domain ([AttendanceEntity]).
extension AttendanceRowMapper on Attendance {
  AttendanceEntity toEntity() {
    return AttendanceEntity(
      id: id,
      locationId: locationId,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      distance: distance,
      status: attendanceStatusFromDb(status),
      timestamp: timestamp,
    );
  }
}

extension AttendanceEntityMapper on AttendanceEntity {
  AttendancesCompanion toInsertCompanion() {
    return AttendancesCompanion(
      locationId: Value(locationId),
      locationName: Value(locationName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      distance: Value(distance),
      status: Value(status.dbValue),
    );
  }
}
