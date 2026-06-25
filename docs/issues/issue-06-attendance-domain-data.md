# Issue #06 — Fitur Absensi: Domain & Data (Verifikasi Radius 50m)

- **Branch**: `feat/issue-06-attendance-domain-data`
- **Bergantung pada**: #02, #03, #04
- **Status**: ⬜ Todo

## Deskripsi
Mengimplementasikan lapisan domain & data untuk fitur Absensi, termasuk **logika
inti verifikasi radius 50 meter**: ambil posisi pengguna, hitung jarak ke titik
lokasi, tentukan accepted/rejected, lalu simpan ke database.

## Scope
**In Scope**
- Entity `AttendanceEntity` + enum/`AttendanceStatus` (accepted/rejected).
- Abstract `AttendanceRepository`.
- Usecases: `SubmitAttendance(locationId)`, `GetAttendanceHistory`.
- `AttendanceLocalDataSource` (Drift) + model/mapper.
- `AttendanceRepositoryImpl` dengan logika verifikasi radius.
- Registrasi di DI.

**Out of Scope**
- UI & BLoC (issue #07).
- Tampilan riwayat (issue #08).

## Langkah-langkah
1. Domain:
   - `AttendanceEntity` (extends `Equatable`) memuat lokasi, koordinat, distance,
     status, timestamp.
   - `AttendanceRepository` (abstract).
   - Usecase `SubmitAttendance`: ambil lokasi terpilih → ambil posisi pengguna
     (`LocationService`) → hitung jarak (`DistanceCalculator`) → tentukan status
     (`distance <= radius` ? accepted : rejected) → simpan record → kembalikan hasil.
   - Usecase `GetAttendanceHistory`.
2. Data:
   - `AttendanceLocalDataSource` (insert, getAll, getByLocation).
   - `AttendanceModel` + mapper.
   - `AttendanceRepositoryImpl`.
3. Tangani error: izin ditolak, GPS mati, lokasi tidak ditemukan → `Failure`.
4. Registrasikan datasource, repository, usecases di DI.

## Acceptance Criteria
- `distance ≤ radius (50m)` → status **accepted** dan tersimpan.
- `distance > radius` → status **rejected** dan tersimpan (sebagai bukti).
- Distance & koordinat pengguna tercatat pada record.
- Error izin/GPS dikembalikan sebagai `Failure` yang tepat.

## Testing
- Unit test `SubmitAttendance` dengan posisi mock:
  - 0 m → accepted; 50 m → accepted; 51 m → rejected.
  - izin ditolak / GPS mati → failure.
- Test repository & datasource (memory DB).

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-06-result.md`.
