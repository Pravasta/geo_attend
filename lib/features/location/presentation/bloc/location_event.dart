part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

/// Memuat seluruh lokasi tersimpan.
class LoadLocations extends LocationEvent {
  const LoadLocations();
}

/// Geotagging: mengambil koordinat GPS saat ini.
class CaptureCoordinate extends LocationEvent {
  const CaptureCoordinate();
}

/// Menambahkan lokasi baru.
class AddLocationEvent extends LocationEvent {
  final LocationEntity location;

  const AddLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

/// Memperbarui lokasi yang sudah ada.
class UpdateLocationEvent extends LocationEvent {
  final LocationEntity location;

  const UpdateLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

/// Menghapus lokasi berdasarkan id.
class DeleteLocationEvent extends LocationEvent {
  final int id;

  const DeleteLocationEvent(this.id);

  @override
  List<Object?> get props => [id];
}
