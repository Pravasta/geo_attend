import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_constants.dart';
import 'features/attendance/presentation/pages/attendance_history_page.dart';
import 'features/attendance/presentation/pages/attendance_page.dart';
import 'features/location/presentation/pages/location_list_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Muat konfigurasi environment (.env). Bersifat opsional agar aplikasi tetap
  // berjalan meski file/key belum tersedia (peta diaktifkan pada Issue #11).
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Abaikan: lanjut tanpa env (fitur peta akan menampilkan pesan bila key kosong).
  }
  await di.init();
  runApp(const GeoAttendApp());
}

class GeoAttendApp extends StatelessWidget {
  const GeoAttendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Home sementara dengan navigasi dasar; HomePage final dibuat di Issue #09.
      home: const _TempHomePage(),
    );
  }
}

/// Home sementara untuk navigasi antar fitur sebelum HomePage final (Issue #09).
class _TempHomePage extends StatelessWidget {
  const _TempHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.location_on, size: 72, color: Colors.indigo),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AttendancePage()),
                ),
                icon: const Icon(Icons.fingerprint),
                label: const Text('Absensi'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LocationListPage()),
                ),
                icon: const Icon(Icons.edit_location_alt),
                label: const Text('Manajemen Lokasi'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AttendanceHistoryPage(),
                  ),
                ),
                icon: const Icon(Icons.history),
                label: const Text('Riwayat Absensi'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
