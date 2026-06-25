import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/failures.dart';
import 'package:geo_attend/core/usecases/usecase.dart';
import 'package:geo_attend/features/location/domain/entities/captured_location.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';
import 'package:geo_attend/features/location/domain/usecases/add_location.dart';
import 'package:geo_attend/features/location/domain/usecases/capture_current_location.dart';
import 'package:geo_attend/features/location/domain/usecases/delete_location.dart';
import 'package:geo_attend/features/location/domain/usecases/get_locations.dart';
import 'package:geo_attend/features/location/domain/usecases/update_location.dart';
import 'package:geo_attend/features/location/presentation/bloc/location_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLocations extends Mock implements GetLocations {}

class MockAddLocation extends Mock implements AddLocation {}

class MockUpdateLocation extends Mock implements UpdateLocation {}

class MockDeleteLocation extends Mock implements DeleteLocation {}

class MockCaptureCurrentLocation extends Mock
    implements CaptureCurrentLocation {}

void main() {
  late MockGetLocations getLocations;
  late MockAddLocation addLocation;
  late MockUpdateLocation updateLocation;
  late MockDeleteLocation deleteLocation;
  late MockCaptureCurrentLocation captureCurrentLocation;

  const tLocation =
      LocationEntity(name: 'Kantor', latitude: -6.2, longitude: 106.8);
  const tCaptured =
      CapturedLocation(latitude: -6.2, longitude: 106.8, address: 'Jakarta');

  setUpAll(() {
    registerFallbackValue(tLocation);
    registerFallbackValue(const NoParams());
  });

  LocationBloc buildBloc() => LocationBloc(
        getLocations: getLocations,
        addLocation: addLocation,
        updateLocation: updateLocation,
        deleteLocation: deleteLocation,
        captureCurrentLocation: captureCurrentLocation,
      );

  setUp(() {
    getLocations = MockGetLocations();
    addLocation = MockAddLocation();
    updateLocation = MockUpdateLocation();
    deleteLocation = MockDeleteLocation();
    captureCurrentLocation = MockCaptureCurrentLocation();
  });

  group('LoadLocations', () {
    blocTest<LocationBloc, LocationState>(
      'emit [Loading, Loaded] saat sukses',
      build: () {
        when(() => getLocations(any()))
            .thenAnswer((_) async => const Right([tLocation]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadLocations()),
      expect: () => const [
        LocationLoading(),
        LocationLoaded([tLocation]),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emit [Loading, Error] saat gagal',
      build: () {
        when(() => getLocations(any()))
            .thenAnswer((_) async => const Left(DatabaseFailure('gagal')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadLocations()),
      expect: () => const [
        LocationLoading(),
        LocationError('gagal'),
      ],
    );
  });

  group('CaptureCoordinate', () {
    blocTest<LocationBloc, LocationState>(
      'emit [InProgress, CoordinateCaptured] saat sukses',
      build: () {
        when(() => captureCurrentLocation(any()))
            .thenAnswer((_) async => const Right(tCaptured));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const CaptureCoordinate()),
      expect: () => const [
        LocationOperationInProgress(),
        CoordinateCaptured(tCaptured),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emit [InProgress, Error] saat izin ditolak',
      build: () {
        when(() => captureCurrentLocation(any())).thenAnswer(
          (_) async => const Left(LocationPermissionFailure('izin ditolak')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const CaptureCoordinate()),
      expect: () => const [
        LocationOperationInProgress(),
        LocationError('izin ditolak'),
      ],
    );
  });

  group('AddLocationEvent', () {
    blocTest<LocationBloc, LocationState>(
      'emit [InProgress, OperationSuccess] saat sukses',
      build: () {
        when(() => addLocation(any()))
            .thenAnswer((_) async => const Right(tLocation));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AddLocationEvent(tLocation)),
      expect: () => const [
        LocationOperationInProgress(),
        LocationOperationSuccess('Lokasi berhasil ditambahkan.'),
      ],
    );
  });

  group('UpdateLocationEvent', () {
    blocTest<LocationBloc, LocationState>(
      'emit [InProgress, OperationSuccess] saat sukses',
      build: () {
        when(() => updateLocation(any()))
            .thenAnswer((_) async => const Right(tLocation));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const UpdateLocationEvent(tLocation)),
      expect: () => const [
        LocationOperationInProgress(),
        LocationOperationSuccess('Lokasi berhasil diperbarui.'),
      ],
    );
  });

  group('DeleteLocationEvent', () {
    blocTest<LocationBloc, LocationState>(
      'emit [OperationSuccess] saat sukses',
      build: () {
        when(() => deleteLocation(any()))
            .thenAnswer((_) async => const Right(unit));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const DeleteLocationEvent(1)),
      expect: () => const [
        LocationOperationSuccess('Lokasi berhasil dihapus.'),
      ],
    );
  });
}
