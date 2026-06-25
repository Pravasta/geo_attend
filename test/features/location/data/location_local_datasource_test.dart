import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/database/app_database.dart';
import 'package:geo_attend/features/location/data/datasources/location_local_datasource.dart';
import 'package:geo_attend/features/location/domain/entities/location_entity.dart';

void main() {
  late AppDatabase db;
  late LocationLocalDataSourceImpl dataSource;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = LocationLocalDataSourceImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  const tLocation = LocationEntity(
    name: 'Kantor Pusat',
    latitude: -6.2,
    longitude: 106.816666,
    address: 'Jakarta',
  );

  test('addLocation menyimpan dan mengembalikan entity dengan id', () async {
    final result = await dataSource.addLocation(tLocation);

    expect(result.id, isNotNull);
    expect(result.name, 'Kantor Pusat');
    expect(result.radius, 50.0);
  });

  test('getLocations mengembalikan daftar lokasi tersimpan', () async {
    await dataSource.addLocation(tLocation);
    await dataSource.addLocation(
      tLocation.copyWith(name: 'Cabang A'),
    );

    final result = await dataSource.getLocations();

    expect(result, hasLength(2));
  });

  test('updateLocation memperbarui data lokasi', () async {
    final added = await dataSource.addLocation(tLocation);

    final updated = added.copyWith(name: 'Kantor Baru', radius: 100);
    await dataSource.updateLocation(updated);

    final all = await dataSource.getLocations();
    expect(all.single.name, 'Kantor Baru');
    expect(all.single.radius, 100);
  });

  test('deleteLocation menghapus lokasi', () async {
    final added = await dataSource.addLocation(tLocation);

    await dataSource.deleteLocation(added.id!);

    final all = await dataSource.getLocations();
    expect(all, isEmpty);
  });
}
