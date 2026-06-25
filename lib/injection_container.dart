import 'package:get_it/get_it.dart';

import 'core/database/app_database.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/location_service.dart';
import 'core/services/permission_service.dart';
import 'core/utils/distance_calculator.dart';

/// Service locator global aplikasi.
final GetIt sl = GetIt.instance;

/// Inisialisasi seluruh dependency aplikasi.
///
/// Pendaftaran dependency dilakukan per-fitur dan core service. Implementasi
/// detail (services, repositories, blocs) ditambahkan pada issue terkait.
Future<void> init() async {
  //! Core
  // Database lokal (Drift) — singleton agar satu koneksi dipakai bersama.
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Utils
  sl.registerLazySingleton<DistanceCalculator>(() => const DistanceCalculator());

  // Services
  sl.registerLazySingleton<PermissionService>(() => PermissionServiceImpl());
  sl.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(sl<PermissionService>()),
  );
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(),
  );

  //! Features - Location
  // Didaftarkan pada Issue #04 (domain/data) & #05 (presentation).

  //! Features - Attendance
  // Didaftarkan pada Issue #06 (domain/data) & #07 (presentation).
}
