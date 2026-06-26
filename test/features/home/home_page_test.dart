import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/theme/app_theme.dart';
import 'package:geo_attend/core/usecases/usecase.dart';
import 'package:geo_attend/features/attendance/domain/usecases/get_attendance_history.dart';
import 'package:geo_attend/features/home/presentation/cubit/home_cubit.dart';
import 'package:geo_attend/features/home/presentation/pages/home_page.dart';
import 'package:geo_attend/features/home/presentation/pages/splash_page.dart';
import 'package:geo_attend/features/location/domain/usecases/get_locations.dart';
import 'package:geo_attend/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLocations extends Mock implements GetLocations {}

class MockGetAttendanceHistory extends Mock implements GetAttendanceHistory {}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    final getLocations = MockGetLocations();
    final getHistory = MockGetAttendanceHistory();
    when(() => getLocations(any())).thenAnswer((_) async => const Right([]));
    when(() => getHistory(any())).thenAnswer((_) async => const Right([]));

    sl.registerFactory<HomeCubit>(
      () => HomeCubit(
        getLocations: getLocations,
        getAttendanceHistory: getHistory,
      ),
    );
  });

  tearDown(() => sl.reset());

  testWidgets('HomePage menampilkan aksi & menu', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HomePage()),
    );
    await tester.pump(); // selesaikan load()
    await tester.pump();

    expect(find.text('Absensi Sekarang'), findsOneWidget);
    // "Lokasi" muncul di kartu ringkasan & menu.
    expect(find.text('Lokasi'), findsWidgets);
    expect(find.text('Riwayat'), findsOneWidget);
  });

  testWidgets('SplashPage menampilkan nama app lalu menuju HomePage',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SplashPage()),
    );
    expect(find.text('GeoAttend'), findsOneWidget);

    // Fire delay navigasi (2200ms) lalu bangun HomePage.
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump();
    await tester.pump();

    expect(find.text('Absensi Sekarang'), findsOneWidget);
  });
}
