# Result — Issue #01: Setup Project, Dependencies & Struktur Clean Architecture

- **Branch**: `feat/issue-01-setup-project`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Fondasi project GeoAttend berhasil disiapkan: project Flutter ter-generate,
seluruh dependency terpasang, struktur Clean Architecture (feature-first) dibuat,
Dependency Injection (`get_it`) di-setup, dan izin lokasi dikonfigurasi untuk
Android & iOS.

## Lingkungan
- **Flutter**: 3.44.3 (dikelola via **FVM**, dipin di `.fvmrc`)
- **Dart**: 3.12.2
- **Org / applicationId**: `com.geoattend.geo_attend`
- **Platform**: Android & iOS

## Yang Dikerjakan
1. **Inisialisasi project** — `fvm flutter create .` dengan menjaga folder `docs/`.
2. **Dependencies runtime** ditambahkan:
   `geolocator`, `geocoding`, `drift`, `sqlite3_flutter_libs`, `path_provider`,
   `path`, `flutter_bloc`, `permission_handler`, `fluttertoast`, `intl`,
   `equatable`, `connectivity_plus`, `get_it`, `dartz`.
3. **Dependencies dev** ditambahkan:
   `build_runner`, `drift_dev`, `bloc_test`, `mocktail` (+ `flutter_lints` bawaan).
4. **Struktur folder Clean Architecture**:
   ```
   lib/
   ├── core/{constants,error,usecases,services,utils,database}
   ├── features/location/{data,domain,presentation}/...
   ├── features/attendance/{data,domain,presentation}/...
   ├── injection_container.dart
   └── main.dart
   ```
5. **Base files core**:
   - `core/constants/app_constants.dart` — termasuk `defaultRadiusMeters = 50.0`.
   - `core/error/failures.dart` — `Failure` + turunannya.
   - `core/error/exceptions.dart` — exception lapisan data/service.
   - `core/usecases/usecase.dart` — `UseCase<T, Params>` + `NoParams`.
6. **Dependency Injection** — `injection_container.dart` dengan `GetIt sl` dan
   fungsi `init()` (placeholder pendaftaran per-issue), dipanggil di `main.dart`.
7. **main.dart** — `GeoAttendApp` + halaman placeholder (Material 3).
8. **Izin platform**:
   - Android: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `INTERNET`,
     `ACCESS_NETWORK_STATE`.
   - iOS: `NSLocationWhenInUseUsageDescription`,
     `NSLocationAlwaysAndWhenInUseUsageDescription`.
9. **.gitignore** — penyesuaian untuk FVM (pin `.fvmrc`, abaikan symlink SDK).

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter pub get` | ✅ Berhasil |
| `flutter analyze` | ✅ No issues found |
| `flutter test` (smoke test) | ✅ All tests passed |

## Catatan
- Test bawaan (`widget_test.dart`) diperbarui dari counter demo menjadi smoke
  test halaman placeholder GeoAttend.
- `minSdk`/`targetSdk` mengikuti default Flutter (`flutter.minSdkVersion`) —
  geolocator kompatibel. Akan ditinjau bila build menuntut minSdk lebih tinggi.

## Acceptance Criteria — Terpenuhi
- [x] `flutter pub get` berhasil tanpa error.
- [x] `flutter analyze` bersih.
- [x] Struktur folder Clean Architecture tersedia.
- [x] `get_it` ter-setup dan dipanggil di `main.dart`.
- [x] Izin lokasi dideklarasikan di Android & iOS.

## Langkah Selanjutnya
Lanjut ke **Issue #02 — Setup Database Drift** (tabel `locations` & `attendances`).
