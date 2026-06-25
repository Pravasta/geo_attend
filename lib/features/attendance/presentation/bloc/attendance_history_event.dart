part of 'attendance_history_bloc.dart';

sealed class AttendanceHistoryEvent extends Equatable {
  const AttendanceHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Memuat seluruh riwayat absensi.
class LoadAttendanceHistory extends AttendanceHistoryEvent {
  const LoadAttendanceHistory();
}
