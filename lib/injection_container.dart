import 'package:get_it/get_it.dart';

/// Service locator global aplikasi.
final GetIt sl = GetIt.instance;

/// Inisialisasi seluruh dependency aplikasi.
///
/// Pendaftaran dependency dilakukan per-fitur dan core service. Implementasi
/// detail (database, services, repositories, blocs) ditambahkan pada issue
/// terkait (#02 dan seterusnya).
Future<void> init() async {
  //! Core
  // Didaftarkan pada Issue #02 (database) & #03 (services).

  //! Features - Location
  // Didaftarkan pada Issue #04 (domain/data) & #05 (presentation).

  //! Features - Attendance
  // Didaftarkan pada Issue #06 (domain/data) & #07 (presentation).
}
