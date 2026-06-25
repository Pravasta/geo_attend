import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/error/failures.dart';
import 'package:geo_attend/features/attendance/domain/entities/attendance_entity.dart';
import 'package:geo_attend/features/attendance/domain/usecases/submit_attendance.dart';
import 'package:geo_attend/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockSubmitAttendance extends Mock implements SubmitAttendance {}

void main() {
  late MockSubmitAttendance submitAttendance;

  const tLocation = LocationEntity(
    id: 1,
    name: 'Kantor',
    latitude: -6.2,
    longitude: 106.8,
  );

  AttendanceEntity buildRecord(AttendanceStatus status, double distance) {
    return AttendanceEntity(
      id: 1,
      locationId: 1,
      locationName: 'Kantor',
      latitude: -6.2,
      longitude: 106.8,
      distance: distance,
      status: status,
    );
  }

  setUpAll(() => registerFallbackValue(tLocation));

  setUp(() => submitAttendance = MockSubmitAttendance());

  AttendanceBloc buildBloc() =>
      AttendanceBloc(submitAttendance: submitAttendance);

  blocTest<AttendanceBloc, AttendanceState>(
    'emit [Submitting, Accepted] saat dalam radius',
    build: () {
      when(() => submitAttendance(any())).thenAnswer(
        (_) async => Right(buildRecord(AttendanceStatus.accepted, 20)),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SubmitAttendanceEvent(tLocation)),
    expect: () => [
      const AttendanceSubmitting(),
      AttendanceAccepted(buildRecord(AttendanceStatus.accepted, 20)),
    ],
  );

  blocTest<AttendanceBloc, AttendanceState>(
    'emit [Submitting, Rejected] saat di luar radius',
    build: () {
      when(() => submitAttendance(any())).thenAnswer(
        (_) async => Right(buildRecord(AttendanceStatus.rejected, 75)),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SubmitAttendanceEvent(tLocation)),
    expect: () => [
      const AttendanceSubmitting(),
      AttendanceRejected(buildRecord(AttendanceStatus.rejected, 75)),
    ],
  );

  blocTest<AttendanceBloc, AttendanceState>(
    'emit [Submitting, Failure] saat error (izin/GPS)',
    build: () {
      when(() => submitAttendance(any())).thenAnswer(
        (_) async => const Left(LocationPermissionFailure('izin ditolak')),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SubmitAttendanceEvent(tLocation)),
    expect: () => const [
      AttendanceSubmitting(),
      AttendanceFailureState('izin ditolak'),
    ],
  );
}
