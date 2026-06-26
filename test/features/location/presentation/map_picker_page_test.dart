import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/features/location/presentation/pages/map_picker_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'MapPickerPage menampilkan pesan & tombol GPS saat API key belum ada',
    (tester) async {
      // Pastikan key kosong.
      dotenv.loadFromString(envString: 'MAPS_API_KEY=', isOptional: true);

      await tester.pumpWidget(
        const MaterialApp(home: MapPickerPage()),
      );

      expect(find.text('Peta belum tersedia'), findsOneWidget);
      expect(find.text('Gunakan GPS Saja'), findsOneWidget);
    },
  );
}
