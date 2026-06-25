part of 'attendance_bloc.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

/// Sedang memproses absensi (mengambil GPS & verifikasi).
class AttendanceSubmitting extends AttendanceState {
  const AttendanceSubmitting();
}

/// Absensi diterima (dalam radius).
class AttendanceAccepted extends AttendanceState {
  final AttendanceEntity record;

  const AttendanceAccepted(this.record);

  @override
  List<Object?> get props => [record];
}

/// Absensi ditolak (di luar radius).
class AttendanceRejected extends AttendanceState {
  final AttendanceEntity record;

  const AttendanceRejected(this.record);

  @override
  List<Object?> get props => [record];
}

/// Gagal melakukan absensi (izin/GPS/database).
class AttendanceFailureState extends AttendanceState {
  final String message;

  const AttendanceFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
