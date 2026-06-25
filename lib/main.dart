import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'features/location/presentation/pages/location_list_page.dart';
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
      // Sementara membuka halaman Lokasi; HomePage dengan navigasi penuh
      // dibuat pada Issue #09.
      home: const LocationListPage(),
    );
  }
}
