# Issue #04 — Fitur Lokasi: Domain & Data (CRUD + Geotagging)

- **Branch**: `feat/issue-04-location-domain-data`
- **Bergantung pada**: #02, #03
- **Status**: ⬜ Todo

## Deskripsi
Mengimplementasikan lapisan **domain** dan **data** untuk fitur Manajemen Lokasi:
entity, repository, usecases, dan data source berbasis Drift. Termasuk geotagging
(ambil koordinat + reverse geocoding untuk alamat).

## Scope
**In Scope**
- Entity `LocationEntity` (domain).
- Abstract `LocationRepository` (domain).
- Usecases: `GetLocations`, `AddLocation`, `UpdateLocation`, `DeleteLocation`,
  `CaptureCurrentLocation` (geotagging + reverse geocoding).
- `LocationLocalDataSource` (Drift DAO) + `LocationModel`/mapper.
- `LocationRepositoryImpl` (domain ↔ data) dengan `Either<Failure, T>`.
- Registrasi di Dependency Injection.

**Out of Scope**
- BLoC & UI (issue #05).

## Langkah-langkah
1. Domain:
   - `features/location/domain/entities/location_entity.dart` (extends `Equatable`).
   - `features/location/domain/repositories/location_repository.dart` (abstract).
   - `features/location/domain/usecases/*.dart`.
2. Data:
   - `features/location/data/datasources/location_local_datasource.dart`
     (insert/update/delete/getAll via Drift).
   - `features/location/data/models/location_model.dart` + mapper ke/dari entity & Drift row.
   - `features/location/data/repositories/location_repository_impl.dart`.
3. `CaptureCurrentLocation`:
   - Pakai `LocationService.getCurrentPosition()`.
   - Reverse geocoding via `geocoding` (cek koneksi via `ConnectivityService`,
     alamat opsional bila offline).
4. Mapping error → `Failure` (DatabaseFailure, LocationFailure, dst.).
5. Registrasikan datasource, repository, usecases di DI.

## Acceptance Criteria
- CRUD lokasi berfungsi terhadap database.
- Geotagging mengembalikan koordinat; alamat terisi bila ada koneksi.
- Setiap usecase mengembalikan `Either<Failure, Success>`.

## Testing
- Unit test repository dengan mock datasource (`mocktail`).
- Unit test usecases (happy path & failure).
- Test datasource dengan `NativeDatabase.memory()`.

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-04-result.md`.
