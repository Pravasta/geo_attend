# Result — Issue #04: Fitur Lokasi — Domain & Data (CRUD + Geotagging)

- **Branch**: `feat/issue-04-location-domain-data`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Lapisan **domain** dan **data** untuk fitur Manajemen Lokasi selesai: entity,
repository abstrak, lima usecase, data source Drift, mapper, implementasi
repository, dan reverse geocoding untuk geotagging. Seluruh operasi mengembalikan
`Either<Failure, T>`.

## Yang Dikerjakan

### Domain
- **`LocationEntity`** (`Equatable`, dengan `copyWith`) — id?, name, latitude,
  longitude, address?, radius (default 50), createdAt?.
- **`CapturedLocation`** — hasil geotagging (lat, lng, address?).
- **`LocationRepository`** (abstrak) — `getLocations`, `addLocation`,
  `updateLocation`, `deleteLocation`, `captureCurrentLocation`.
- **Usecases**: `GetLocations`, `AddLocation`, `UpdateLocation`,
  `DeleteLocation`, `CaptureCurrentLocation`.

### Data
- **`GeocodingService`** (core) — reverse geocoding (koordinat → alamat ringkas)
  via package `geocoding`.
- **`LocationLocalDataSource`** + impl (Drift) — CRUD memakai `insertReturning`,
  `replace`, `delete`; melempar `DatabaseException` saat gagal.
- **`location_model.dart`** — extension mapper Drift `Location` ↔ `LocationEntity`
  (+ companion insert/update).
- **`LocationRepositoryImpl`** — mengoordinasi data source + `LocationService`
  + `GeocodingService` + `ConnectivityService`; mapping exception → `Failure`.

### Dependency Injection
- `GeocodingService`, `LocationLocalDataSource`, `LocationRepository`, dan kelima
  usecase didaftarkan di `injection_container.dart`.

## Alur Geotagging (`captureCurrentLocation`)
1. Ambil posisi via `LocationService.getCurrentPosition()`.
2. Jika ada koneksi (`ConnectivityService`), coba reverse geocoding untuk alamat.
   Kegagalan geocoding **tidak** membatalkan geotagging (koordinat tetap valid,
   alamat `null`).
3. Map exception: GPS mati → `LocationServiceFailure`, izin ditolak →
   `LocationPermissionFailure`, lainnya → `LocationFailure`.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **35 tests passed** |

### Cakupan Test
- **DataSource** (in-memory DB): add (id terisi, radius default 50), getAll,
  update, delete.
- **Repository** (mock): getLocations sukses/gagal, deleteLocation,
  captureCurrentLocation (online+alamat, offline tanpa alamat & tanpa panggil
  geocoding, GPS mati, izin ditolak).
- **Usecases**: delegasi ke repository + penerusan `Left(Failure)`.

## Keputusan Teknis
- **`captureCurrentLocation` di repository** (bukan langsung di usecase) agar
  usecase tetap tipis dan orkestrasi data source/service terpusat sesuai Clean
  Architecture.
- **Mapper sebagai extension** (`location_model.dart`) untuk konversi ringkas
  antara baris Drift dan entity domain tanpa kelas model tambahan yang berat.
- **Perbandingan `Either` di test**: list di dalam `Right` dibandingkan via
  `fold` (List `==` Dart bersifat referensial, bukan element-wise).

## Acceptance Criteria — Terpenuhi
- [x] CRUD lokasi berfungsi terhadap database.
- [x] Geotagging mengembalikan koordinat; alamat terisi bila ada koneksi.
- [x] Setiap usecase mengembalikan `Either<Failure, Success>`.

## Langkah Selanjutnya
Lanjut ke **Issue #05 — Fitur Lokasi: Presentation (BLoC + UI)**.
