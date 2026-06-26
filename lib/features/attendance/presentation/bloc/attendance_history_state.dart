part of 'attendance_history_bloc.dart';

sealed class AttendanceHistoryState extends Equatable {
  const AttendanceHistoryState();

  @override
  List<Object?> get props => [];
}

class AttendanceHistoryInitial extends AttendanceHistoryState {
  const AttendanceHistoryInitial();
}

class AttendanceHistoryLoading extends AttendanceHistoryState {
  const AttendanceHistoryLoading();
}

class AttendanceHistoryLoaded extends AttendanceHistoryState {
  /// Seluruh riwayat (sebelum filter).
  final List<AttendanceEntity> all;
  final AttendanceFilter filter;

  const AttendanceHistoryLoaded(this.all, {this.filter = AttendanceFilter.all});

  /// Riwayat setelah filter diterapkan.
  List<AttendanceEntity> get filtered {
    switch (filter) {
      case AttendanceFilter.accepted:
        return all.where((a) => a.isAccepted).toList();
      case AttendanceFilter.rejected:
        return all.where((a) => !a.isAccepted).toList();
      case AttendanceFilter.all:
        return all;
    }
  }

  AttendanceHistoryLoaded copyWith({AttendanceFilter? filter}) {
    return AttendanceHistoryLoaded(all, filter: filter ?? this.filter);
  }

  @override
  List<Object?> get props => [all, filter];
}

class AttendanceHistoryError extends AttendanceHistoryState {
  final String message;

  const AttendanceHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
