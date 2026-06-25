// Smoke test untuk GeoAttend.
//
// Memastikan aplikasi dapat dibangun dan menampilkan halaman placeholder
// setelah setup project (Issue #01).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:geo_attend/main.dart';

void main() {
  testWidgets('GeoAttendApp builds and shows placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GeoAttendApp());

    // Judul aplikasi tampil pada AppBar.
    expect(find.text('GeoAttend'), findsOneWidget);
    // Ikon lokasi placeholder tampil.
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });
}
