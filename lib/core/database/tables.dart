import 'package:drift/drift.dart';

import '../constants/app_constants.dart';

/// Tabel master data lokasi (titik absensi).
///
/// Menyimpan nama lokasi beserta koordinat hasil geotagging dan radius
/// verifikasi (default 50 meter).
class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text().nullable()();
  RealColumn get radius =>
      real().withDefault(const Constant(AppConstants.defaultRadiusMeters))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tabel riwayat absensi.
///
/// Setiap baris merekam satu percobaan absensi: koordinat pengguna saat absen,
/// jarak terhitung ke titik lokasi, status (accepted/rejected), dan waktu.
/// Menyimpan koordinat & jarak berguna sebagai bukti audit verifikasi.
class Attendances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get locationId =>
      integer().references(Locations, #id, onDelete: KeyAction.cascade)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get distance => real()();
  TextColumn get status => text().withLength(min: 1, max: 20)();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
