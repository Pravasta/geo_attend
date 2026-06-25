import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/failures.dart';
import 'package:geo_attend/core/usecases/usecase.dart';
import 'package:geo_attend/features/location/domain/entities/captured_location.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';
import 'package:geo_attend/features/location/domain/repositories/location_repository.dart';
import 'package:geo_attend/features/location/domain/usecases/add_location.dart';
import 'package:geo_attend/features/location/domain/usecases/capture_current_location.dart';
import 'package:geo_attend/features/location/domain/usecases/delete_location.dart';
import 'package:geo_attend/features/location/domain/usecases/get_locations.dart';
import 'package:geo_attend/features/location/domain/usecases/update_location.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late MockLocationRepository repository;

  setUp(() => repository = MockLocationRepository());

  const tLocation = LocationEntity(name: 'Kantor', latitude: -6.2, longitude: 106.8);

  setUpAll(() {
    registerFallbackValue(tLocation);
  });

  test('GetLocations mendelegasikan ke repository', () async {
    when(() => repository.getLocations())
        .thenAnswer((_) async => const Right([tLocation]));

    final result = await GetLocations(repository)(const NoParams());

    expect(result.isRight(), isTrue);
    verify(() => repository.getLocations()).called(1);
  });

  test('AddLocation mendelegasikan ke repository', () async {
    when(() => repository.addLocation(any()))
        .thenAnswer((_) async => const Right(tLocation));

    final result = await AddLocation(repository)(tLocation);

    expect(result.isRight(), isTrue);
    verify(() => repository.addLocation(tLocation)).called(1);
  });

  test('UpdateLocation mendelegasikan ke repository', () async {
    when(() => repository.updateLocation(any()))
        .thenAnswer((_) async => const Right(tLocation));

    await UpdateLocation(repository)(tLocation);

    verify(() => repository.updateLocation(tLocation)).called(1);
  });

  test('DeleteLocation mendelegasikan ke repository', () async {
    when(() => repository.deleteLocation(any()))
        .thenAnswer((_) async => const Right(unit));

    await DeleteLocation(repository)(1);

    verify(() => repository.deleteLocation(1)).called(1);
  });

  test('CaptureCurrentLocation mendelegasikan ke repository', () async {
    when(() => repository.captureCurrentLocation()).thenAnswer(
      (_) async => const Right(
        CapturedLocation(latitude: -6.2, longitude: 106.8, address: 'Jakarta'),
      ),
    );

    final result = await CaptureCurrentLocation(repository)(const NoParams());

    expect(result.isRight(), isTrue);
    verify(() => repository.captureCurrentLocation()).called(1);
  });

  test('usecase meneruskan Left(Failure) dari repository', () async {
    when(() => repository.getLocations())
        .thenAnswer((_) async => const Left(DatabaseFailure()));

    final result = await GetLocations(repository)(const NoParams());

    expect(result.isLeft(), isTrue);
  });
}
