# Issue #02 — Setup Database Drift (locations & attendances)

- **Branch**: `feat/issue-02-database-drift`
- **Bergantung pada**: #01
- **Status**: ⬜ Todo

## Deskripsi
Menyiapkan database lokal menggunakan **Drift (SQLite)**: mendefinisikan tabel
`locations` dan `attendances`, membuat instance database, dan code generation.

## Scope
**In Scope**
- Definisi tabel `Locations` dan `Attendances` (Drift).
- Kelas `AppDatabase` + koneksi (`NativeDatabase` via `path_provider`).
- Code generation (`build_runner`).
- Registrasi `AppDatabase` di Dependency Injection.

**Out of Scope**
- DAO/query khusus fitur (dibuat di issue domain/data terkait).
- Logika bisnis absensi.

## Langkah-langkah
1. Buat `core/database/tables.dart`:
   - Tabel `Locations`: `id` (autoIncrement), `name`, `latitude`, `longitude`,
     `address` (nullable), `radius` (default 50), `createdAt`.
   - Tabel `Attendances`: `id`, `locationId` (FK), `latitude`, `longitude`,
     `distance`, `status`, `timestamp`.
2. Buat `core/database/app_database.dart` dengan anotasi `@DriftDatabase(tables: [...])`.
3. Implementasikan `_openConnection()` menggunakan `path_provider` + `path`.
4. Tetapkan `schemaVersion = 1`.
5. Jalankan `dart run build_runner build --delete-conflicting-outputs`.
6. Registrasikan `AppDatabase` sebagai singleton di `injection_container.dart`.

## Acceptance Criteria
- File `app_database.g.dart` ter-generate tanpa error.
- Database dapat dibuka saat aplikasi dijalankan tanpa crash.
- Tabel `locations` & `attendances` terbentuk sesuai skema brainstorming.

## Testing
- Unit test sederhana: insert & query satu baris pada tiap tabel menggunakan
  `NativeDatabase.memory()`.
- `flutter analyze` lulus.

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-02-result.md`.
