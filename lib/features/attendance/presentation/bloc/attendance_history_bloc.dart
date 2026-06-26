import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/get_attendance_history.dart';

part 'attendance_history_event.dart';
part 'attendance_history_state.dart';

/// Filter status riwayat absensi.
enum AttendanceFilter { all, accepted, rejected }

class AttendanceHistoryBloc
    extends Bloc<AttendanceHistoryEvent, AttendanceHistoryState> {
  final GetAttendanceHistory getAttendanceHistory;

  AttendanceHistoryBloc({required this.getAttendanceHistory})
      : super(const AttendanceHistoryInitial()) {
    on<LoadAttendanceHistory>(_onLoadHistory);
    on<FilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadHistory(
    LoadAttendanceHistory event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    // Pertahankan filter aktif (jika ada) saat memuat ulang.
    final currentFilter = state is AttendanceHistoryLoaded
        ? (state as AttendanceHistoryLoaded).filter
        : AttendanceFilter.all;

    emit(const AttendanceHistoryLoading());
    final result = await getAttendanceHistory(const NoParams());
    result.fold(
      (failure) => emit(AttendanceHistoryError(failure.message)),
      (history) => emit(AttendanceHistoryLoaded(history, filter: currentFilter)),
    );
  }

  void _onFilterChanged(
    FilterChanged event,
    Emitter<AttendanceHistoryState> emit,
  ) {
    final current = state;
    if (current is AttendanceHistoryLoaded) {
      emit(current.copyWith(filter: event.filter));
    }
  }
}
