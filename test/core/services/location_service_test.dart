import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/exceptions.dart';
import 'package:geo_attend/core/services/location_service.dart';
import 'package:geo_attend/core/services/permission_service.dart';
import 'package:geolocator/geolocator.dart' hide LocationServiceDisabledException;
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPermissionService extends Mock implements PermissionService {}

class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

Position _fakePosition() {
  return Position(
    latitude: -6.200000,
    longitude: 106.816666,
    timestamp: DateTime(2026, 6, 25),
    accuracy: 5,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

void main() {
  late MockPermissionService mockPermission;
  late MockGeolocatorPlatform mockGeolocator;
  late LocationServiceImpl service;

  setUp(() {
    mockPermission = MockPermissionService();
    mockGeolocator = MockGeolocatorPlatform();
    service = LocationServiceImpl(mockPermission, geolocator: mockGeolocator);
  });

  test('getCurrentPosition melempar exception saat GPS mati', () async {
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => false);

    expect(
      () => service.getCurrentPosition(),
      throwsA(isA<LocationServiceDisabledException>()),
    );
  });

  test('getCurrentPosition melempar exception saat izin ditolak', () async {
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermission.hasLocationPermission())
        .thenAnswer((_) async => false);
    when(() => mockPermission.requestLocationPermission())
        .thenAnswer((_) async => false);

    expect(
      () => service.getCurrentPosition(),
      throwsA(isA<LocationPermissionDeniedException>()),
    );
  });

  test('getCurrentPosition mengembalikan Position saat semua terpenuhi',
      () async {
    final position = _fakePosition();
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermission.hasLocationPermission())
        .thenAnswer((_) async => true);
    when(() => mockGeolocator.getCurrentPosition(
        locationSettings: any(named: 'locationSettings'))).thenAnswer(
      (_) async => position,
    );

    final result = await service.getCurrentPosition();

    expect(result, position);
  });

  test('getCurrentPosition meminta izin jika belum diberikan lalu berhasil',
      () async {
    final position = _fakePosition();
    when(() => mockGeolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermission.hasLocationPermission())
        .thenAnswer((_) async => false);
    when(() => mockPermission.requestLocationPermission())
        .thenAnswer((_) async => true);
    when(() => mockGeolocator.getCurrentPosition(
        locationSettings: any(named: 'locationSettings'))).thenAnswer(
      (_) async => position,
    );

    final result = await service.getCurrentPosition();

    expect(result, position);
    verify(() => mockPermission.requestLocationPermission()).called(1);
  });
}
