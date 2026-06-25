import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../location/domain/entities/location_entity.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/submit_attendance.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final SubmitAttendance submitAttendance;

  AttendanceBloc({required this.submitAttendance})
      : super(const AttendanceInitial()) {
    on<SubmitAttendanceEvent>(_onSubmitAttendance);
  }

  Future<void> _onSubmitAttendance(
    SubmitAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceSubmitting());
    final result = await submitAttendance(event.location);
    result.fold(
      (failure) => emit(AttendanceFailureState(failure.message)),
      (record) => emit(
        record.isAccepted
            ? AttendanceAccepted(record)
            : AttendanceRejected(record),
      ),
    );
  }
}
