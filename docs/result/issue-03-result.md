# Result — Issue #03: Core Services (Permission, Location & Distance Util)

- **Branch**: `feat/issue-03-core-services`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Service inti lintas-fitur berhasil dibuat: pengelolaan izin lokasi, pengambilan
posisi GPS, perhitungan jarak (logika inti verifikasi 50 m), dan pengecekan
konektivitas. Seluruhnya berbasis abstraksi agar mudah diuji dan di-inject.

## Yang Dikerjakan
1. **`core/utils/distance_calculator.dart`** — `DistanceCalculator`:
   - `distanceInMeters(...)` membungkus `Geolocator.distanceBetween` (Haversine).
   - `isWithinRadius(distance, radius)` — logika inti aturan absensi
     (`distance <= radius`).
2. **`core/services/permission_service.dart`** — `PermissionService` (abstract)
   + `PermissionServiceImpl` (berbasis `permission_handler`):
   - `hasLocationPermission`, `requestLocationPermission`, `isPermanentlyDenied`,
     `openSettings`.
3. **`core/services/location_service.dart`** — `LocationService` (abstract)
   + `LocationServiceImpl` (berbasis `geolocator`):
   - `isLocationServiceEnabled`.
   - `getCurrentPosition`: cek GPS aktif → cek/minta izin → ambil posisi
     (akurasi tinggi). Melempar `LocationServiceDisabledException` /
     `LocationPermissionDeniedException` pada kondisi gagal.
4. **`core/services/connectivity_service.dart`** — `ConnectivityService`
   (abstract) + `ConnectivityServiceImpl` (berbasis `connectivity_plus`).
5. **Dependency Injection** — `DistanceCalculator`, `PermissionService`,
   `LocationService`, `ConnectivityService` didaftarkan sebagai `lazySingleton`.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ 18 tests passed |

### Cakupan Test
- **DistanceCalculator** (`isWithinRadius`): 0 m, 49.9 m, 50 m → accepted;
  50.01 m, 51 m → rejected. Plus `distanceInMeters` (titik identik = 0).
- **LocationService** (mock `GeolocatorPlatform` + `PermissionService`):
  GPS mati → exception; izin ditolak → exception; sukses → `Position`;
  minta izin lalu berhasil.
- **ConnectivityService** (mock `Connectivity`): wifi/seluler → connected;
  none → disconnected.

## Keputusan Teknis
- **Permission via `permission_handler`, lokasi via `geolocator`** — keduanya
  membaca status izin OS yang sama sehingga konsisten. Pembagian peran ini
  menghormati daftar package dan menjaga tanggung jawab tiap service tetap jelas.
- **Dependency Injection ke service** (`GeolocatorPlatform`, `Connectivity`,
  `Permission` dapat di-override lewat konstruktor) sehingga service dapat diuji
  tanpa menyentuh platform asli (mock via `mocktail`).
- **`hide LocationServiceDisabledException`** pada import `geolocator` untuk
  menghindari bentrok nama dengan exception aplikasi.
- Menambah `plugin_platform_interface` sebagai dev dependency (dibutuhkan untuk
  `MockPlatformInterfaceMixin` saat mem-mock platform geolocator).

## Acceptance Criteria — Terpenuhi
- [x] Service dapat dipanggil & mengembalikan hasil yang benar.
- [x] `isWithinRadius` benar untuk jarak ≤ radius dan > radius.
- [x] Exception dilempar saat izin ditolak / GPS mati.

## Langkah Selanjutnya
Lanjut ke **Issue #04 — Fitur Lokasi: Domain & Data (CRUD + Geotagging)**.
