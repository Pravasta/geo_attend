import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/exceptions.dart';
import 'package:geo_attend/core/error/failures.dart';
import 'package:geo_attend/core/services/location_service.dart';
import 'package:geo_attend/core/utils/distance_calculator.dart';
import 'package:geo_attend/features/attendance/data/datasources/attendance_local_datasource.dart';
import 'package:geo_attend/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:geo_attend/features/attendance/domain/entities/attendance_entity.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart' hide LocationServiceDisabledException;
import 'package:mocktail/mocktail.dart';

class MockAttendanceLocalDataSource extends Mock
    implements AttendanceLocalDataSource {}

class MockLocationService extends Mock implements LocationService {}

class MockDistanceCalculator extends Mock implements DistanceCalculator {}

Position _fakePosition() => Position(
      latitude: -6.21,
      longitude: 106.81,
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
  late MockAttendanceLocalDataSource dataSource;
  late MockLocationService locationService;
  late MockDistanceCalculator distanceCalculator;
  late AttendanceRepositoryImpl repository;

  const tLocation = LocationEntity(
    id: 1,
    name: 'Kantor',
    latitude: -6.2,
    longitude: 106.8,
    radius: 50,
  );

  setUpAll(() {
    registerFallbackValue(
      const AttendanceEntity(
        locationName: 'x',
        latitude: 0,
        longitude: 0,
        distance: 0,
        status: AttendanceStatus.accepted,
      ),
    );
  });

  setUp(() {
    dataSource = MockAttendanceLocalDataSource();
    locationService = MockLocationService();
    distanceCalculator = MockDistanceCalculator();
    repository = AttendanceRepositoryImpl(
      localDataSource: dataSource,
      locationService: locationService,
      distanceCalculator: distanceCalculator,
    );

    // insertAttendance mengembalikan entity yang sama (dengan id).
    when(() => dataSource.insertAttendance(any())).thenAnswer((invocation) async {
      final entity = invocation.positionalArguments[0] as AttendanceEntity;
      return AttendanceEntity(
        id: 99,
        locationId: entity.locationId,
        locationName: entity.locationName,
        latitude: entity.latitude,
        longitude: entity.longitude,
        distance: entity.distance,
        status: entity.status,
      );
    });
  });

  group('submitAttendance — verifikasi radius', () {
    test('distance 30 m (<= 50) -> accepted & tersimpan', () async {
      when(() => locationService.getCurrentPosition())
          .thenAnswer((_) async => _fakePosition());
      when(() => distanceCalculator.distanceInMeters(
            startLatitude: any(named: 'startLatitude'),
            startLongitude: any(named: 'startLongitude'),
            endLatitude: any(named: 'endLatitude'),
            endLongitude: any(named: 'endLongitude'),
          )).thenReturn(30);
      when(() => distanceCalculator.isWithinRadius(30, 50)).thenReturn(true);

      final result = await repository.submitAttendance(tLocation);

      result.fold(
        (_) => fail('should be Right'),
        (att) {
          expect(att.status, AttendanceStatus.accepted);
          expect(att.distance, 30);
        },
      );
      verify(() => dataSource.insertAttendance(any())).called(1);
    });

    test('distance 50 m (batas) -> accepted', () async {
      when(() => locationService.getCurrentPosition())
          .thenAnswer((_) async => _fakePosition());
      when(() => distanceCalculator.distanceInMeters(
            startLatitude: any(named: 'startLatitude'),
            startLongitude: any(named: 'startLongitude'),
            endLatitude: any(named: 'endLatitude'),
            endLongitude: any(named: 'endLongitude'),
          )).thenReturn(50);
      when(() => distanceCalculator.isWithinRadius(50, 50)).thenReturn(true);

      final result = await repository.submitAttendance(tLocation);

      result.fold(
        (_) => fail('should be Right'),
        (att) => expect(att.status, AttendanceStatus.accepted),
      );
    });

    test('distance 80 m (> 50) -> rejected & tetap tersimpan (bukti)', () async {
      when(() => locationService.getCurrentPosition())
          .thenAnswer((_) async => _fakePosition());
      when(() => distanceCalculator.distanceInMeters(
            startLatitude: any(named: 'startLatitude'),
            startLongitude: any(named: 'startLongitude'),
            endLatitude: any(named: 'endLatitude'),
            endLongitude: any(named: 'endLongitude'),
          )).thenReturn(80);
      when(() => distanceCalculator.isWithinRadius(80, 50)).thenReturn(false);

      final result = await repository.submitAttendance(tLocation);

      result.fold(
        (_) => fail('should be Right'),
        (att) {
          expect(att.status, AttendanceStatus.rejected);
          expect(att.distance, 80);
        },
      );
      verify(() => dataSource.insertAttendance(any())).called(1);
    });
  });

  group('submitAttendance — error', () {
    test('GPS mati -> Left(LocationServiceFailure)', () async {
      when(() => locationService.getCurrentPosition())
          .thenThrow(LocationServiceDisabledException());

      final result = await repository.submitAttendance(tLocation);

      result.fold(
        (l) => expect(l, isA<LocationServiceFailure>()),
        (_) => fail('should be Left'),
      );
      verifyNever(() => dataSource.insertAttendance(any()));
    });

    test('izin ditolak -> Left(LocationPermissionFailure)', () async {
      when(() => locationService.getCurrentPosition())
          .thenThrow(LocationPermissionDeniedException());

      final result = await repository.submitAttendance(tLocation);

      result.fold(
        (l) => expect(l, isA<LocationPermissionFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  group('getAttendanceHistory', () {
    test('mengembalikan Right(list) saat sukses', () async {
      when(() => dataSource.getAttendances()).thenAnswer((_) async => []);

      final result = await repository.getAttendanceHistory();

      expect(result.isRight(), isTrue);
    });

    test('mengembalikan Left(DatabaseFailure) saat exception', () async {
      when(() => dataSource.getAttendances())
          .thenThrow(DatabaseException('error'));

      final result = await repository.getAttendanceHistory();

      result.fold(
        (l) => expect(l, isA<DatabaseFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });
}
