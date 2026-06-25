import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/location_entity.dart';

/// Mapper antara baris Drift (`Location`) dan domain ([LocationEntity]).
extension LocationRowMapper on Location {
  LocationEntity toEntity() {
    return LocationEntity(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: address,
      radius: radius,
      createdAt: createdAt,
    );
  }
}

extension LocationEntityMapper on LocationEntity {
  /// Companion untuk operasi insert (tanpa `id`, dibiarkan auto-increment).
  LocationsCompanion toInsertCompanion() {
    return LocationsCompanion(
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      address: Value(address),
      radius: Value(radius),
    );
  }

  /// Companion untuk operasi update (menyertakan `id`).
  LocationsCompanion toUpdateCompanion() {
    return LocationsCompanion(
      id: Value(id!),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      address: Value(address),
      radius: Value(radius),
    );
  }
}
