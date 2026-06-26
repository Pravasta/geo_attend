import 'package:get_it/get_it.dart';

import 'core/database/app_database.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/geocoding_service.dart';
import 'core/services/location_service.dart';
import 'core/services/permission_service.dart';
import 'core/utils/distance_calculator.dart';
import 'features/location/data/datasources/location_local_datasource.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/domain/usecases/add_location.dart';
import 'features/location/domain/usecases/capture_current_location.dart';
import 'features/location/domain/usecases/delete_location.dart';
import 'features/location/domain/usecases/get_locations.dart';
import 'features/location/domain/usecases/update_location.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/attendance/data/datasources/attendance_local_datasource.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/domain/usecases/get_attendance_history.dart';
import 'features/attendance/domain/usecases/submit_attendance.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_history_bloc.dart';
import 'features/home/presentation/cubit/home_cubit.dart';

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
  sl.registerLazySingleton<GeocodingService>(() => GeocodingServiceImpl());

  //! Features - Location
  // Data sources
  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(sl<AppDatabase>()),
  );
  // Repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      localDataSource: sl<LocationLocalDataSource>(),
      locationService: sl<LocationService>(),
      geocodingService: sl<GeocodingService>(),
      connectivityService: sl<ConnectivityService>(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetLocations(sl<LocationRepository>()));
  sl.registerLazySingleton(() => AddLocation(sl<LocationRepository>()));
  sl.registerLazySingleton(() => UpdateLocation(sl<LocationRepository>()));
  sl.registerLazySingleton(() => DeleteLocation(sl<LocationRepository>()));
  sl.registerLazySingleton(
    () => CaptureCurrentLocation(sl<LocationRepository>()),
  );
  // BLoC (factory: instance baru tiap halaman agar state tidak tercampur).
  sl.registerFactory(
    () => LocationBloc(
      getLocations: sl<GetLocations>(),
      addLocation: sl<AddLocation>(),
      updateLocation: sl<UpdateLocation>(),
      deleteLocation: sl<DeleteLocation>(),
      captureCurrentLocation: sl<CaptureCurrentLocation>(),
    ),
  );

  //! Features - Attendance
  // Data sources
  sl.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLocalDataSourceImpl(sl<AppDatabase>()),
  );
  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      localDataSource: sl<AttendanceLocalDataSource>(),
      locationService: sl<LocationService>(),
      distanceCalculator: sl<DistanceCalculator>(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => SubmitAttendance(sl<AttendanceRepository>()));
  sl.registerLazySingleton(
    () => GetAttendanceHistory(sl<AttendanceRepository>()),
  );
  // BLoC (factory).
  sl.registerFactory(
    () => AttendanceBloc(submitAttendance: sl<SubmitAttendance>()),
  );
  sl.registerFactory(
    () => AttendanceHistoryBloc(
      getAttendanceHistory: sl<GetAttendanceHistory>(),
    ),
  );

  //! Features - Home
  sl.registerFactory(
    () => HomeCubit(
      getLocations: sl<GetLocations>(),
      getAttendanceHistory: sl<GetAttendanceHistory>(),
    ),
  );
}
