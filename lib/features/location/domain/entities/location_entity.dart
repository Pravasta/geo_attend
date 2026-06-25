import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

/// Entity lokasi (titik absensi) pada lapisan domain.
class LocationEntity extends Equatable {
  /// `null` untuk lokasi baru yang belum tersimpan.
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final double radius;
  final DateTime? createdAt;

  const LocationEntity({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.radius = AppConstants.defaultRadiusMeters,
    this.createdAt,
  });

  LocationEntity copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    double? radius,
    DateTime? createdAt,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      radius: radius ?? this.radius,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        address,
        radius,
        createdAt,
      ];
}
