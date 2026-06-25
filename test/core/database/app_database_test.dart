import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/constants/app_constants.dart';
import 'package:geo_attend/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // Database in-memory untuk pengujian (tidak menyentuh file device).
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Locations table', () {
    test('insert dan query lokasi berhasil', () async {
      final id = await db.into(db.locations).insert(
            LocationsCompanion.insert(
              name: 'Kantor Pusat',
              latitude: -6.200000,
              longitude: 106.816666,
            ),
          );

      final rows = await db.select(db.locations).get();

      expect(rows, hasLength(1));
      expect(rows.first.id, id);
      expect(rows.first.name, 'Kantor Pusat');
      // Radius default mengikuti AppConstants.defaultRadiusMeters (50 m).
      expect(rows.first.radius, AppConstants.defaultRadiusMeters);
    });
  });

  group('Attendances table', () {
    test('insert absensi yang terkait lokasi berhasil', () async {
      final locationId = await db.into(db.locations).insert(
            LocationsCompanion.insert(
              name: 'Cabang A',
              latitude: -6.21,
              longitude: 106.81,
            ),
          );

      await db.into(db.attendances).insert(
            AttendancesCompanion.insert(
              locationId: locationId,
              latitude: -6.21,
              longitude: 106.81,
              distance: 12.5,
              status: AppConstants.statusAccepted,
            ),
          );

      final rows = await db.select(db.attendances).get();

      expect(rows, hasLength(1));
      expect(rows.first.locationId, locationId);
      expect(rows.first.distance, 12.5);
      expect(rows.first.status, AppConstants.statusAccepted);
    });

    test('hapus lokasi meng-cascade hapus absensi terkait', () async {
      final locationId = await db.into(db.locations).insert(
            LocationsCompanion.insert(
              name: 'Cabang B',
              latitude: -6.22,
              longitude: 106.82,
            ),
          );
      await db.into(db.attendances).insert(
            AttendancesCompanion.insert(
              locationId: locationId,
              latitude: -6.22,
              longitude: 106.82,
              distance: 5.0,
              status: AppConstants.statusAccepted,
            ),
          );

      await (db.delete(db.locations)
            ..where((t) => t.id.equals(locationId)))
          .go();

      final attendances = await db.select(db.attendances).get();
      expect(attendances, isEmpty);
    });
  });
}
