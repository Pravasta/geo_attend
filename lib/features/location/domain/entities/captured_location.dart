import 'package:equatable/equatable.dart';

/// Hasil geotagging: koordinat GPS saat ini beserta alamat (opsional).
///
/// [address] bisa `null` bila reverse geocoding gagal atau perangkat offline.
class CapturedLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;

  const CapturedLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}
