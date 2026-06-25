import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/features/location/presentation/pages/map_picker_page.dart';

void main() {
  testWidgets(
    'MapPickerPage menampilkan pesan saat API key belum dikonfigurasi',
    (tester) async {
      // Pastikan key kosong.
      dotenv.loadFromString(envString: 'MAPS_API_KEY=', isOptional: true);

      await tester.pumpWidget(
        const MaterialApp(home: MapPickerPage()),
      );

      expect(
        find.textContaining('API key belum dikonfigurasi'),
        findsOneWidget,
      );
    },
  );
}
