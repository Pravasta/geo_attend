// Smoke test untuk GeoAttend.
//
// Memastikan halaman daftar lokasi dapat dibangun (memakai LocationBloc dari
// service locator dengan usecase yang di-mock).

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/usecases/usecase.dart';
import 'package:geo_attend/features/location/domain/usecases/add_location.dart';
import 'package:geo_attend/features/location/domain/usecases/capture_current_location.dart';
import 'package:geo_attend/features/location/domain/usecases/delete_location.dart';
import 'package:geo_attend/features/location/domain/usecases/get_locations.dart';
import 'package:geo_attend/features/location/domain/usecases/update_location.dart';
import 'package:geo_attend/features/location/presentation/bloc/location_bloc.dart';
import 'package:geo_attend/features/location/presentation/pages/location_list_page.dart';
import 'package:geo_attend/injection_container.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLocations extends Mock implements GetLocations {}

class MockAddLocation extends Mock implements AddLocation {}

class MockUpdateLocation extends Mock implements UpdateLocation {}

class MockDeleteLocation extends Mock implements DeleteLocation {}

class MockCaptureCurrentLocation extends Mock
    implements CaptureCurrentLocation {}

void main() {
  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    final getLocations = MockGetLocations();
    when(() => getLocations(any())).thenAnswer((_) async => const Right([]));

    sl.registerFactory<LocationBloc>(
      () => LocationBloc(
        getLocations: getLocations,
        addLocation: MockAddLocation(),
        updateLocation: MockUpdateLocation(),
        deleteLocation: MockDeleteLocation(),
        captureCurrentLocation: MockCaptureCurrentLocation(),
      ),
    );
  });

  tearDown(() => sl.reset());

  testWidgets('LocationListPage menampilkan judul & empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationListPage()));
    await tester.pumpAndSettle();

    expect(find.text('Manajemen Lokasi'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
    expect(find.textContaining('Belum ada lokasi'), findsOneWidget);
  });
}
