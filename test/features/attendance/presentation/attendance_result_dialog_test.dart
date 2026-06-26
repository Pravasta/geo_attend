import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/theme/app_theme.dart';
import 'package:geo_attend/features/attendance/domain/entities/attendance_entity.dart';
import 'package:geo_attend/features/attendance/presentation/widgets/attendance_result_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

AttendanceEntity _record(AttendanceStatus status, double distance) {
  return AttendanceEntity(
    id: 1,
    locationId: 1,
    locationName: 'Kantor Pusat',
    latitude: -6.2,
    longitude: 106.8,
    distance: distance,
    status: status,
    timestamp: DateTime(2026, 6, 26, 8, 2),
  );
}

Widget _wrap(AttendanceEntity record) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: AttendanceResultDialog(record: record)),
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('dialog accepted menampilkan berhasil & jarak', (tester) async {
    await tester.pumpWidget(_wrap(_record(AttendanceStatus.accepted, 12)));
    await tester.pump();

    expect(find.text('Absensi Berhasil'), findsOneWidget);
    expect(find.textContaining('12 m dari titik lokasi'), findsOneWidget);
    expect(find.textContaining('Dalam radius 50 m'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
  });

  testWidgets('dialog rejected menampilkan ditolak & di luar radius',
      (tester) async {
    await tester.pumpWidget(_wrap(_record(AttendanceStatus.rejected, 128)));
    await tester.pump();

    expect(find.text('Absensi Ditolak'), findsOneWidget);
    expect(find.textContaining('128 m dari titik lokasi'), findsOneWidget);
    expect(find.textContaining('Di luar radius 50 m'), findsOneWidget);
    expect(find.text('Tutup'), findsOneWidget);
  });
}
