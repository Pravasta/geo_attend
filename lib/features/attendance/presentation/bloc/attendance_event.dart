part of 'attendance_bloc.dart';

sealed class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Melakukan absensi terhadap lokasi terpilih.
class SubmitAttendanceEvent extends AttendanceEvent {
  final LocationEntity location;

  const SubmitAttendanceEvent(this.location);

  @override
  List<Object?> get props => [location];
}
