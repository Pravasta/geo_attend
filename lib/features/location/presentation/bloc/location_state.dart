part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

/// Sedang memuat daftar lokasi.
class LocationLoading extends LocationState {
  const LocationLoading();
}

/// Daftar lokasi berhasil dimuat.
class LocationLoaded extends LocationState {
  final List<LocationEntity> locations;

  const LocationLoaded(this.locations);

  @override
  List<Object?> get props => [locations];
}

/// Operasi (capture/add/update/delete) sedang berjalan.
class LocationOperationInProgress extends LocationState {
  const LocationOperationInProgress();
}

/// Operasi (add/update/delete) berhasil.
class LocationOperationSuccess extends LocationState {
  final String message;

  const LocationOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Geotagging berhasil; koordinat (dan alamat) siap dipakai form.
class CoordinateCaptured extends LocationState {
  final CapturedLocation captured;

  const CoordinateCaptured(this.captured);

  @override
  List<Object?> get props => [captured];
}

/// Terjadi kesalahan.
class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
