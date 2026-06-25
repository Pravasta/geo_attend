import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../entities/attendance_entity.dart';

/// Kontrak repository untuk fitur Absensi.
abstract class AttendanceRepository {
  /// Melakukan absensi terhadap [location].
  ///
  /// Mengambil posisi pengguna, menghitung jarak ke titik lokasi, menentukan
  /// status (accepted bila ≤ radius, rejected bila > radius), lalu menyimpan
  /// catatan (baik diterima maupun ditolak) sebagai bukti.
  Future<Either<Failure, AttendanceEntity>> submitAttendance(
    LocationEntity location,
  );

  /// Mengambil seluruh riwayat absensi (terbaru lebih dulu).
  Future<Either<Failure, List<AttendanceEntity>>> getAttendanceHistory();
}
