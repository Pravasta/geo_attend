part of 'home_cubit.dart';

/// Ringkasan data untuk dashboard home.
class HomeSummary extends Equatable {
  final int locationCount;
  final int attendanceCount;
  final AttendanceEntity? lastAttendance;

  const HomeSummary({
    required this.locationCount,
    required this.attendanceCount,
    this.lastAttendance,
  });

  @override
  List<Object?> get props => [locationCount, attendanceCount, lastAttendance];
}

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeSummary summary;

  const HomeLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}
