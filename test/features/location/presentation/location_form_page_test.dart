import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/theme/app_theme.dart';
import 'package:geo_attend/features/location/domain/usecases/add_location.dart';
import 'package:geo_attend/features/location/domain/usecases/capture_current_location.dart';
import 'package:geo_attend/features/location/domain/usecases/delete_location.dart';
import 'package:geo_attend/features/location/domain/usecases/get_locations.dart';
import 'package:geo_attend/features/location/domain/usecases/update_location.dart';
import 'package:geo_attend/features/location/presentation/bloc/location_bloc.dart';
import 'package:geo_attend/features/location/presentation/pages/location_form_page.dart';
import 'package:geo_attend/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLocations extends Mock implements GetLocations {}

class MockAddLocation extends Mock implements AddLocation {}

class MockUpdateLocation extends Mock implements UpdateLocation {}

class MockDeleteLocation extends Mock implements DeleteLocation {}

class MockCaptureCurrentLocation extends Mock
    implements CaptureCurrentLocation {}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() {
    sl.registerFactory<LocationBloc>(
      () => LocationBloc(
        getLocations: MockGetLocations(),
        addLocation: MockAddLocation(),
        updateLocation: MockUpdateLocation(),
        deleteLocation: MockDeleteLocation(),
        captureCurrentLocation: MockCaptureCurrentLocation(),
      ),
    );
  });

  tearDown(() => sl.reset());

  testWidgets('Form lokasi menampilkan tombol GPS & Peta serta simpan',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LocationFormPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tambah Lokasi'), findsOneWidget);
    expect(find.text('Ambil Koordinat (GPS)'), findsOneWidget);
    expect(find.text('Pilih di Peta'), findsOneWidget);
    expect(find.text('Simpan Lokasi'), findsOneWidget);
  });
}
