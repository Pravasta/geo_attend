import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const _PlaceholderHomePage(),
    );
  }
}

/// Halaman sementara untuk Issue #01.
/// Akan digantikan oleh HomePage sesungguhnya pada issue presentation.
class _PlaceholderHomePage extends StatelessWidget {
  const _PlaceholderHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 64),
              SizedBox(height: 16),
              Text(
                'GeoAttend siap dikembangkan.\n'
                'Setup project (Issue #01) berhasil.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
