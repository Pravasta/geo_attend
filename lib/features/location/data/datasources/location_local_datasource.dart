import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/location_entity.dart';
import '../models/location_model.dart';

/// Sumber data lokal (Drift) untuk lokasi.
abstract class LocationLocalDataSource {
  Future<List<LocationEntity>> getLocations();
  Future<LocationEntity> addLocation(LocationEntity location);
  Future<LocationEntity> updateLocation(LocationEntity location);
  Future<void> deleteLocation(int id);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final AppDatabase database;

  LocationLocalDataSourceImpl(this.database);

  @override
  Future<List<LocationEntity>> getLocations() async {
    try {
      final query = database.select(database.locations)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);
      final rows = await query.get();
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<LocationEntity> addLocation(LocationEntity location) async {
    try {
      final row = await database
          .into(database.locations)
          .insertReturning(location.toInsertCompanion());
      return row.toEntity();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<LocationEntity> updateLocation(LocationEntity location) async {
    try {
      await database
          .update(database.locations)
          .replace(location.toUpdateCompanion());
      return location;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deleteLocation(int id) async {
    try {
      await (database.delete(database.locations)
            ..where((t) => t.id.equals(id)))
          .go();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
