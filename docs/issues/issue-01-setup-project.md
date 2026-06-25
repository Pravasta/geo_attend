# Issue #01 — Setup Project, Dependencies & Struktur Clean Architecture

- **Branch**: `feat/issue-01-setup-project`
- **Bergantung pada**: —
- **Status**: ⬜ Todo

## Deskripsi
Menyiapkan fondasi project Flutter GeoAttend: inisialisasi project, menambahkan
seluruh dependency, menyiapkan struktur folder Clean Architecture (feature-first),
dan mengonfigurasi Dependency Injection. Ini adalah pondasi untuk seluruh issue
berikutnya.

## Scope
**In Scope**
- Inisialisasi project Flutter (`flutter create`) bila belum ada.
- Menambahkan dependencies ke `pubspec.yaml` (runtime & dev).
- Membuat struktur folder `core/` dan `features/`.
- Setup base class: `Failure`, `UseCase`, konstanta global (mis. `kDefaultRadius = 50`).
- Setup Dependency Injection (`get_it`) di `injection_container.dart`.
- Konfigurasi izin lokasi di `AndroidManifest.xml` dan `Info.plist`.

**Out of Scope**
- Implementasi fitur (lokasi/absensi) — dikerjakan di issue lain.
- Skema database — issue #02.

## Langkah-langkah
1. Jalankan `flutter create .` (jika folder Flutter belum dibuat).
2. Tambahkan dependencies utama pada `pubspec.yaml`:
   `geolocator`, `geocoding`, `drift`, `sqlite3_flutter_libs`, `path_provider`,
   `path`, `flutter_bloc`, `permission_handler`, `fluttertoast`, `intl`,
   `equatable`, `connectivity_plus`, `get_it`, `dartz`.
3. Tambahkan dev dependencies: `build_runner`, `drift_dev`, `bloc_test`,
   `mocktail`, `flutter_lints`.
4. Jalankan `flutter pub get`.
5. Buat struktur folder:
   ```
   lib/core/{constants,error,usecases,services,utils}
   lib/features/{location,attendance}/{data,domain,presentation}
   ```
6. Buat `core/error/failures.dart` (abstract `Failure` + turunannya) dan
   `core/error/exceptions.dart`.
7. Buat `core/usecases/usecase.dart` (abstract `UseCase<Type, Params>` + `NoParams`).
8. Buat `core/constants/app_constants.dart` (mis. `kDefaultRadiusMeters = 50.0`).
9. Setup `injection_container.dart` dengan `GetIt` instance (`sl`).
10. Tambahkan izin lokasi:
    - Android: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` di `AndroidManifest.xml`.
    - iOS: `NSLocationWhenInUseUsageDescription` di `Info.plist`.

## Acceptance Criteria
- `flutter pub get` berhasil tanpa error.
- `flutter analyze` bersih.
- Struktur folder Clean Architecture tersedia.
- `get_it` ter-setup dan dipanggil di `main.dart`.
- Izin lokasi sudah dideklarasikan di kedua platform.

## Testing
- `flutter analyze` lulus.
- Aplikasi dapat di-run (`flutter run`) menampilkan halaman kosong/placeholder.

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil ditulis di `docs/result/issue-01-result.md`.
