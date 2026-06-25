import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/failures.dart';
import 'package:geo_attend/core/usecases/usecase.dart';
import 'package:geo_attend/features/attendance/domain/entities/attendance_entity.dart';
import 'package:geo_attend/features/attendance/domain/usecases/get_attendance_history.dart';
import 'package:geo_attend/features/attendance/presentation/bloc/attendance_history_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAttendanceHistory extends Mock implements GetAttendanceHistory {}

void main() {
  late MockGetAttendanceHistory getAttendanceHistory;

  final tHistory = [
    AttendanceEntity(
      id: 1,
      locationId: 1,
      locationName: 'Kantor',
      latitude: -6.2,
      longitude: 106.8,
      distance: 12,
      status: AttendanceStatus.accepted,
      timestamp: DateTime(2026, 6, 25, 8, 0),
    ),
    AttendanceEntity(
      id: 2,
      locationId: 1,
      locationName: 'Kantor',
      latitude: -6.2,
      longitude: 106.8,
      distance: 90,
      status: AttendanceStatus.rejected,
      timestamp: DateTime(2026, 6, 24, 9, 0),
    ),
  ];

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() => getAttendanceHistory = MockGetAttendanceHistory());

  AttendanceHistoryBloc buildBloc() =>
      AttendanceHistoryBloc(getAttendanceHistory: getAttendanceHistory);

  blocTest<AttendanceHistoryBloc, AttendanceHistoryState>(
    'emit [Loading, Loaded] saat ada riwayat',
    build: () {
      when(() => getAttendanceHistory(any()))
          .thenAnswer((_) async => Right(tHistory));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadAttendanceHistory()),
    expect: () => [
      const AttendanceHistoryLoading(),
      AttendanceHistoryLoaded(tHistory),
    ],
  );

  blocTest<AttendanceHistoryBloc, AttendanceHistoryState>(
    'emit [Loading, Loaded([])] saat riwayat kosong',
    build: () {
      when(() => getAttendanceHistory(any()))
          .thenAnswer((_) async => const Right([]));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadAttendanceHistory()),
    expect: () => const [
      AttendanceHistoryLoading(),
      AttendanceHistoryLoaded([]),
    ],
  );

  blocTest<AttendanceHistoryBloc, AttendanceHistoryState>(
    'emit [Loading, Error] saat gagal',
    build: () {
      when(() => getAttendanceHistory(any()))
          .thenAnswer((_) async => const Left(DatabaseFailure('gagal')));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadAttendanceHistory()),
    expect: () => const [
      AttendanceHistoryLoading(),
      AttendanceHistoryError('gagal'),
    ],
  );
}
