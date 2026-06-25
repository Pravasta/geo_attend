import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/captured_location.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  final LocationService locationService;
  final GeocodingService geocodingService;
  final ConnectivityService connectivityService;

  LocationRepositoryImpl({
    required this.localDataSource,
    required this.locationService,
    required this.geocodingService,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, List<LocationEntity>>> getLocations() async {
    try {
      return Right(await localDataSource.getLocations());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> addLocation(
    LocationEntity location,
  ) async {
    try {
      return Right(await localDataSource.addLocation(location));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> updateLocation(
    LocationEntity location,
  ) async {
    try {
      return Right(await localDataSource.updateLocation(location));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLocation(int id) async {
    try {
      await localDataSource.deleteLocation(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CapturedLocation>> captureCurrentLocation() async {
    try {
      final position = await locationService.getCurrentPosition();

      // Alamat opsional: hanya dicoba bila ada koneksi, dan kegagalannya tidak
      // membatalkan geotagging (koordinat tetap valid tanpa alamat).
      String? address;
      if (await connectivityService.isConnected()) {
        try {
          address = await geocodingService.getAddress(
            position.latitude,
            position.longitude,
          );
        } catch (_) {
          address = null;
        }
      }

      return Right(CapturedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ));
    } on LocationServiceDisabledException {
      return const Left(LocationServiceFailure());
    } on LocationPermissionDeniedException {
      return const Left(LocationPermissionFailure());
    } catch (e) {
      return const Left(LocationFailure());
    }
  }
}
