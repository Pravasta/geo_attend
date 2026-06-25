import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_local_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource localDataSource;
  final LocationService locationService;
  final DistanceCalculator distanceCalculator;

  AttendanceRepositoryImpl({
    required this.localDataSource,
    required this.locationService,
    required this.distanceCalculator,
  });

  @override
  Future<Either<Failure, AttendanceEntity>> submitAttendance(
    LocationEntity location,
  ) async {
    try {
      // 1. Ambil posisi pengguna saat ini.
      final position = await locationService.getCurrentPosition();

      // 2. Hitung jarak pengguna ke titik lokasi.
      final distance = distanceCalculator.distanceInMeters(
        startLatitude: location.latitude,
        startLongitude: location.longitude,
        endLatitude: position.latitude,
        endLongitude: position.longitude,
      );

      // 3. Tentukan status: di dalam radius -> accepted, di luar -> rejected.
      final isWithin =
          distanceCalculator.isWithinRadius(distance, location.radius);
      final status =
          isWithin ? AttendanceStatus.accepted : AttendanceStatus.rejected;

      // 4. Simpan catatan (baik diterima maupun ditolak) sebagai bukti.
      final entity = AttendanceEntity(
        locationId: location.id,
        locationName: location.name,
        latitude: position.latitude,
        longitude: position.longitude,
        distance: distance,
        status: status,
      );
      final saved = await localDataSource.insertAttendance(entity);
      return Right(saved);
    } on LocationServiceDisabledException {
      return const Left(LocationServiceFailure());
    } on LocationPermissionDeniedException {
      return const Left(LocationPermissionFailure());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(LocationFailure('Gagal melakukan absensi.'));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceEntity>>>
      getAttendanceHistory() async {
    try {
      return Right(await localDataSource.getAttendances());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
