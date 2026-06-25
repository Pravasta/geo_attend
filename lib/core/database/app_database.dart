import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Database lokal aplikasi (Drift/SQLite).
///
/// Mengelola tabel [Locations] dan [Attendances]. Foreign key diaktifkan agar
/// relasi absensi → lokasi terjaga (hapus lokasi akan menghapus riwayat
/// absensi terkait — cascade).
@DriftDatabase(tables: [Locations, Attendances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Konstruktor untuk pengujian (mis. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // Aktifkan foreign key constraint (default SQLite: off).
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// Membuka koneksi database secara lazy pada file di direktori dokumen aplikasi.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
