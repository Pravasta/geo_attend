# Issue #03 — Core Services: Permission, Location & Distance Util

- **Branch**: `feat/issue-03-core-services`
- **Bergantung pada**: #01
- **Status**: ⬜ Todo

## Deskripsi
Membuat service inti yang dipakai lintas fitur: pengelolaan izin lokasi,
pengambilan posisi GPS, perhitungan jarak, dan pengecekan konektivitas.

## Scope
**In Scope**
- `PermissionService` — minta & cek izin lokasi (`permission_handler` / `geolocator`).
- `LocationService` — cek layanan lokasi aktif, ambil posisi terkini (`geolocator`).
- `DistanceCalculator` util — hitung jarak dua titik (`Geolocator.distanceBetween`).
- `ConnectivityService` — cek koneksi internet (`connectivity_plus`).
- Registrasi semua service di Dependency Injection.

**Out of Scope**
- Reverse geocoding (dipakai di fitur lokasi, issue #04).
- UI dialog izin (issue presentation terkait).

## Langkah-langkah
1. Buat `core/services/permission_service.dart`:
   - `Future<bool> hasLocationPermission()`
   - `Future<bool> requestLocationPermission()`
   - Tangani status `denied`, `permanentlyDenied`.
2. Buat `core/services/location_service.dart`:
   - `Future<bool> isLocationServiceEnabled()`
   - `Future<Position> getCurrentPosition()` (dengan akurasi tinggi).
3. Buat `core/utils/distance_calculator.dart`:
   - `double distanceInMeters(lat1, lng1, lat2, lng2)`.
   - `bool isWithinRadius(distance, radius)`.
4. Buat `core/services/connectivity_service.dart`:
   - `Future<bool> isConnected()`.
5. Definisikan exception khusus: `LocationPermissionDeniedException`,
   `LocationServiceDisabledException`.
6. Registrasikan semua service di `injection_container.dart`.

## Acceptance Criteria
- Service dapat dipanggil dan mengembalikan hasil yang benar.
- `isWithinRadius` mengembalikan `true` untuk jarak ≤ radius, `false` untuk > radius.
- Exception dilempar pada kondisi izin ditolak / GPS mati.

## Testing
- Unit test `DistanceCalculator`: 0 m → within; 50 m → within; 51 m → not within.
- Unit test service dengan mock (`mocktail`) untuk skenario izin & GPS.

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-03-result.md`.
