import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../attendance/domain/entities/attendance_entity.dart';
import '../../../attendance/domain/usecases/get_attendance_history.dart';
import '../../../location/domain/usecases/get_locations.dart';

part 'home_state.dart';

/// Memuat ringkasan dashboard: jumlah lokasi, jumlah absensi, absensi terakhir.
///
/// Menggunakan kembali usecase yang sudah ada (tanpa data layer baru).
class HomeCubit extends Cubit<HomeState> {
  final GetLocations getLocations;
  final GetAttendanceHistory getAttendanceHistory;

  HomeCubit({
    required this.getLocations,
    required this.getAttendanceHistory,
  }) : super(const HomeLoading());

  Future<void> load() async {
    emit(const HomeLoading());

    final locationsResult = await getLocations(const NoParams());
    final historyResult = await getAttendanceHistory(const NoParams());

    final locationCount = locationsResult.fold((_) => 0, (list) => list.length);
    final history = historyResult.fold(
      (_) => <AttendanceEntity>[],
      (list) => list,
    );

    emit(HomeLoaded(
      HomeSummary(
        locationCount: locationCount,
        attendanceCount: history.length,
        // Riwayat sudah terurut terbaru lebih dulu.
        lastAttendance: history.isNotEmpty ? history.first : null,
      ),
    ));
  }
}
