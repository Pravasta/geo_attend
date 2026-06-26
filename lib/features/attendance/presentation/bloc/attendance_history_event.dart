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

/// Mengubah filter status yang ditampilkan.
class FilterChanged extends AttendanceHistoryEvent {
  final AttendanceFilter filter;

  const FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
