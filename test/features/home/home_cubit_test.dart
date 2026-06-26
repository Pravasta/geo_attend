import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/usecases/usecase.dart';
import 'package:geo_attend/features/attendance/domain/entities/attendance_entity.dart';
import 'package:geo_attend/features/attendance/domain/usecases/get_attendance_history.dart';
import 'package:geo_attend/features/home/presentation/cubit/home_cubit.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';
import 'package:geo_attend/features/location/domain/usecases/get_locations.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLocations extends Mock implements GetLocations {}

class MockGetAttendanceHistory extends Mock implements GetAttendanceHistory {}

void main() {
  late MockGetLocations getLocations;
  late MockGetAttendanceHistory getHistory;

  const tLocation =
      LocationEntity(name: 'Kantor', latitude: -6.2, longitude: 106.8);
  final tAttendance = AttendanceEntity(
    id: 1,
    locationId: 1,
    locationName: 'Kantor',
    latitude: -6.2,
    longitude: 106.8,
    distance: 10,
    status: AttendanceStatus.accepted,
    timestamp: DateTime(2026, 6, 26, 8, 2),
  );

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    getLocations = MockGetLocations();
    getHistory = MockGetAttendanceHistory();
  });

  HomeCubit build() => HomeCubit(
        getLocations: getLocations,
        getAttendanceHistory: getHistory,
      );

  blocTest<HomeCubit, HomeState>(
    'load() menghitung ringkasan dari usecase',
    build: () {
      when(() => getLocations(any()))
          .thenAnswer((_) async => const Right([tLocation, tLocation]));
      when(() => getHistory(any()))
          .thenAnswer((_) async => Right([tAttendance]));
      return build();
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const HomeLoading(),
      isA<HomeLoaded>()
          .having((s) => s.summary.locationCount, 'locationCount', 2)
          .having((s) => s.summary.attendanceCount, 'attendanceCount', 1)
          .having((s) => s.summary.lastAttendance, 'lastAttendance', tAttendance),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'load() tetap menghasilkan ringkasan kosong saat data kosong',
    build: () {
      when(() => getLocations(any())).thenAnswer((_) async => const Right([]));
      when(() => getHistory(any())).thenAnswer((_) async => const Right([]));
      return build();
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const HomeLoading(),
      isA<HomeLoaded>()
          .having((s) => s.summary.locationCount, 'locationCount', 0)
          .having((s) => s.summary.lastAttendance, 'lastAttendance', null),
    ],
  );
}
