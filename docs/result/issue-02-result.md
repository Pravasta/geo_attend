# Result — Issue #02: Setup Database Drift (locations & attendances)

- **Branch**: `feat/issue-02-database-drift`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Database lokal berbasis **Drift (SQLite)** berhasil disiapkan. Tabel `locations`
dan `attendances` didefinisikan sesuai skema brainstorming, kode ter-generate via
`build_runner`, dan `AppDatabase` didaftarkan sebagai singleton di Dependency
Injection.

## Yang Dikerjakan
1. **`core/database/tables.dart`** — definisi tabel:
   - `Locations`: `id`, `name`, `latitude`, `longitude`, `address` (nullable),
     `radius` (default 50 m via `AppConstants.defaultRadiusMeters`), `createdAt`.
   - `Attendances`: `id`, `locationId` (FK → `locations.id`, **nullable**,
     `onDelete: setNull`), `locationName` (snapshot nama lokasi), `latitude`,
     `longitude`, `distance`, `status`, `timestamp`.
2. **`core/database/app_database.dart`** — `@DriftDatabase`:
   - `schemaVersion = 1`.
   - `MigrationStrategy` dengan `createAll()` dan `PRAGMA foreign_keys = ON`.
   - Koneksi lazy ke file di direktori dokumen aplikasi (`path_provider` + `path`).
   - Konstruktor `AppDatabase.forTesting(...)` untuk pengujian in-memory.
3. **Code generation** — `fvm dart run build_runner build` menghasilkan
   `app_database.g.dart`.
4. **Dependency Injection** — `AppDatabase` didaftarkan sebagai `lazySingleton`
   di `injection_container.dart`.
5. **Unit test** — `test/core/database/app_database_test.dart`:
   - Insert & query lokasi (verifikasi radius default 50 m).
   - Insert absensi terkait lokasi (termasuk snapshot `locationName`).
   - Hapus lokasi → riwayat absensi **tetap tersimpan** (`locationId` di-set
     null, `locationName` bertahan).

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `build_runner` | ✅ `app_database.g.dart` ter-generate |
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ 4 tests passed (1 smoke + 3 database) |

## Keputusan Teknis
- **Riwayat absensi dipertahankan saat lokasi dihapus** — `locationId` dibuat
  nullable dengan `onDelete: setNull`, dan ditambahkan kolom snapshot
  `locationName`. Saat lokasi master dihapus, baris absensi tidak ikut terhapus:
  relasi `locationId` menjadi null sementara `locationName` menjaga konteks
  riwayat tetap bermakna. Pilihan ini sesuai sifat data kehadiran yang tidak
  boleh hilang. _(Sempat dipertimbangkan `onDelete: cascade`, namun diganti agar
  riwayat aman.)_
- **File generated di-commit** — `.gitignore` disesuaikan agar `*.g.dart` ikut
  ter-track, sehingga repo dapat di-build tanpa wajib menjalankan codegen lebih
  dulu (belum ada CI yang menjalankan `build_runner`).

## Acceptance Criteria — Terpenuhi
- [x] `app_database.g.dart` ter-generate tanpa error.
- [x] Database dapat dibuka tanpa crash (terverifikasi via test in-memory).
- [x] Tabel `locations` & `attendances` sesuai skema brainstorming.

## Langkah Selanjutnya
Lanjut ke **Issue #03 — Core Services (Permission, Location & Distance Util)**.
