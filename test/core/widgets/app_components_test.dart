import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('AppButton', () {
    testWidgets('memanggil onPressed saat ditekan', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Simpan', onPressed: () => tapped = true)),
      );

      await tester.tap(find.byType(AppButton));
      expect(tapped, isTrue);
    });

    testWidgets('state loading menampilkan indikator & tidak memanggil onPressed',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AppButton(
          label: 'Simpan',
          loading: true,
          onPressed: () => tapped = true,
        )),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(tapped, isFalse);
    });

    testWidgets('disabled saat onPressed null', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppButton(label: 'Nonaktif', onPressed: null)),
      );
      // Tidak melempar error saat ditekan.
      await tester.tap(find.byType(AppButton));
      expect(find.text('Nonaktif'), findsOneWidget);
    });
  });

  group('StatusBadge', () {
    testWidgets('accepted menampilkan Diterima', (tester) async {
      await tester.pumpWidget(_wrap(const StatusBadge(accepted: true)));
      expect(find.text('Diterima'), findsOneWidget);
    });

    testWidgets('rejected menampilkan Ditolak', (tester) async {
      await tester.pumpWidget(_wrap(const StatusBadge(accepted: false)));
      expect(find.text('Ditolak'), findsOneWidget);
    });
  });

  group('EmptyStateView', () {
    testWidgets('menampilkan judul, pesan & aksi', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(EmptyStateView(
        icon: Icons.location_off,
        title: 'Belum ada lokasi',
        message: 'Tambahkan lokasi.',
        actionLabel: 'Tambah',
        actionIcon: Icons.add,
        onAction: () => tapped = true,
      )));

      expect(find.text('Belum ada lokasi'), findsOneWidget);
      expect(find.text('Tambahkan lokasi.'), findsOneWidget);
      await tester.tap(find.text('Tambah'));
      expect(tapped, isTrue);
    });
  });
}
