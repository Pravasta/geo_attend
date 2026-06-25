import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/exceptions.dart';
import 'package:geo_attend/core/error/failures.dart';
import 'package:geo_attend/core/services/connectivity_service.dart';
import 'package:geo_attend/core/services/geocoding_service.dart';
import 'package:geo_attend/core/services/location_service.dart';
import 'package:geo_attend/features/location/data/datasources/location_local_datasource.dart';
import 'package:geo_attend/features/location/data/repositories/location_repository_impl.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart' hide LocationServiceDisabledException;
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocationLocalDataSource {}

class MockLocationService extends Mock implements LocationService {}

class MockGeocodingService extends Mock implements GeocodingService {}

class MockConnectivityService extends Mock implements ConnectivityService {}

Position _fakePosition() => Position(
      latitude: -6.2,
      longitude: 106.8,
      timestamp: DateTime(2026, 6, 25),
      accuracy: 5,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

void main() {
  late MockLocalDataSource localDataSource;
  late MockLocationService locationService;
  late MockGeocodingService geocodingService;
  late MockConnectivityService connectivityService;
  late LocationRepositoryImpl repository;

  setUp(() {
    localDataSource = MockLocalDataSource();
    locationService = MockLocationService();
    geocodingService = MockGeocodingService();
    connectivityService = MockConnectivityService();
    repository = LocationRepositoryImpl(
      localDataSource: localDataSource,
      locationService: locationService,
      geocodingService: geocodingService,
      connectivityService: connectivityService,
    );
  });

  const tLocation = LocationEntity(
    name: 'Kantor',
    latitude: -6.2,
    longitude: 106.8,
  );

  group('getLocations', () {
    test('mengembalikan Right(list) saat sukses', () async {
      when(() => localDataSource.getLocations())
          .thenAnswer((_) async => [tLocation]);

      final result = await repository.getLocations();

      result.fold(
        (_) => fail('should be Right'),
        (list) => expect(list, [tLocation]),
      );
    });

    test('mengembalikan Left(DatabaseFailure) saat exception', () async {
      when(() => localDataSource.getLocations())
          .thenThrow(DatabaseException('error'));

      final result = await repository.getLocations();

      expect(result, isA<Left<Failure, List<LocationEntity>>>());
      result.fold(
        (l) => expect(l, isA<DatabaseFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  group('deleteLocation', () {
    test('mengembalikan Right(unit) saat sukses', () async {
      when(() => localDataSource.deleteLocation(any()))
          .thenAnswer((_) async {});

      final result = await repository.deleteLocation(1);

      expect(result, const Right<Failure, Unit>(unit));
    });
  });

  group('captureCurrentLocation', () {
    test('Right dengan alamat saat online & geocoding sukses', () async {
      when(() => locationService.getCurrentPosition())
          .thenAnswer((_) async => _fakePosition());
      when(() => connectivityService.isConnected())
          .thenAnswer((_) async => true);
      when(() => geocodingService.getAddress(any(), any()))
          .thenAnswer((_) async => 'Jakarta');

      final result = await repository.captureCurrentLocation();

      result.fold(
        (_) => fail('should be Right'),
        (captured) {
          expect(captured.latitude, -6.2);
          expect(captured.address, 'Jakarta');
        },
      );
    });

    test('Right tanpa alamat saat offline (tidak panggil geocoding)', () async {
      when(() => locationService.getCurrentPosition())
          .thenAnswer((_) async => _fakePosition());
      when(() => connectivityService.isConnected())
          .thenAnswer((_) async => false);

      final result = await repository.captureCurrentLocation();

      result.fold(
        (_) => fail('should be Right'),
        (captured) => expect(captured.address, isNull),
      );
      verifyNever(() => geocodingService.getAddress(any(), any()));
    });

    test('Left(LocationServiceFailure) saat GPS mati', () async {
      when(() => locationService.getCurrentPosition())
          .thenThrow(LocationServiceDisabledException());

      final result = await repository.captureCurrentLocation();

      result.fold(
        (l) => expect(l, isA<LocationServiceFailure>()),
        (_) => fail('should be Left'),
      );
    });

    test('Left(LocationPermissionFailure) saat izin ditolak', () async {
      when(() => locationService.getCurrentPosition())
          .thenThrow(LocationPermissionDeniedException());

      final result = await repository.captureCurrentLocation();

      result.fold(
        (l) => expect(l, isA<LocationPermissionFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });
}
