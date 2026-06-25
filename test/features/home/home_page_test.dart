import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/theme/app_theme.dart';
import 'package:geo_attend/features/home/presentation/pages/home_page.dart';
import 'package:geo_attend/features/home/presentation/pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    // Hindari fetch font dari jaringan saat pengujian (pakai fallback).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('HomePage menampilkan menu utama', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HomePage()),
    );

    expect(find.text('Absensi Sekarang'), findsOneWidget);
    expect(find.text('Lokasi'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
  });

  testWidgets('SplashPage menampilkan nama app lalu menuju HomePage',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SplashPage()),
    );

    // Splash menampilkan nama aplikasi.
    expect(find.text('GeoAttend'), findsOneWidget);

    // Setelah delay, berpindah ke HomePage.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Absensi Sekarang'), findsOneWidget);
  });
}
