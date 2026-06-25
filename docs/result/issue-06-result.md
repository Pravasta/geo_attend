# Result — Issue #06: Fitur Absensi — Domain & Data (Verifikasi Radius 50 m)

- **Branch**: `feat/issue-06-attendance-domain-data`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Lapisan **domain** dan **data** untuk fitur Absensi selesai, termasuk **logika
inti verifikasi radius**: ambil posisi pengguna → hitung jarak ke titik lokasi →
tentukan accepted (≤ radius) / rejected (> radius) → simpan catatan (diterima
maupun ditolak) sebagai bukti.

## Yang Dikerjakan

### Domain
- **`AttendanceEntity`** (`Equatable`) + enum **`AttendanceStatus`**
  (accepted/rejected), dengan getter `isAccepted`. Menyimpan koordinat pengguna,
  `distance`, status, `locationName` (snapshot), dan `locationId` (nullable).
- **`AttendanceRepository`** (abstrak) — `submitAttendance(location)`,
  `getAttendanceHistory()`.
- **Usecases**: `SubmitAttendance` (param `LocationEntity`), `GetAttendanceHistory`.

### Data
- **`attendance_model.dart`** — mapper Drift `Attendance` ↔ `AttendanceEntity`,
  termasuk konversi `AttendanceStatus` ↔ string DB (`accepted`/`rejected`).
- **`AttendanceLocalDataSource`** + impl (Drift) — `insertAttendance`
  (`insertReturning`), `getAttendances` (urut `timestamp` desc).
- **`AttendanceRepositoryImpl`** — orkestrasi `LocationService` +
  `DistanceCalculator` + datasource; mapping exception → `Failure`.

### Dependency Injection
- `AttendanceLocalDataSource`, `AttendanceRepository`, `SubmitAttendance`,
  `GetAttendanceHistory` didaftarkan di `injection_container.dart`.

## Logika Verifikasi (`submitAttendance`)
1. Ambil posisi pengguna via `LocationService.getCurrentPosition()`.
2. Hitung jarak pengguna ↔ titik lokasi (`DistanceCalculator.distanceInMeters`).
3. `isWithinRadius(distance, location.radius)` → `accepted` / `rejected`.
4. **Simpan catatan apa pun statusnya** (rejected pun disimpan sebagai bukti).
5. Mapping error: GPS mati → `LocationServiceFailure`, izin ditolak →
   `LocationPermissionFailure`, DB → `DatabaseFailure`.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **52 tests passed** |

### Cakupan Test
- **Repository (logika inti)**: 30 m → accepted; **50 m (batas) → accepted**;
  80 m → rejected (tetap tersimpan); GPS mati → failure (tidak menyimpan);
  izin ditolak → failure; getHistory sukses/gagal.
- **DataSource (in-memory DB)**: insert accepted, insert rejected (bukti),
  getAttendances.

## Keputusan Teknis
- **`SubmitAttendance` menerima `LocationEntity`** (bukan hanya `locationId`).
  Halaman absensi (#07) sudah memuat daftar lokasi, sehingga lokasi terpilih
  diteruskan langsung. Ini menghindari ketergantungan silang ke
  `LocationRepository` dan query ekstra, menjaga fitur absensi tetap mandiri.
  _(Deviasi kecil dari deskripsi issue yang menyebut `locationId`.)_
- **Record rejected tetap disimpan** sesuai brainstorming — berguna untuk audit
  dan riwayat (#08).
- **`distance` & koordinat pengguna direkam** pada tiap catatan sebagai bukti
  verifikasi.

## Acceptance Criteria — Terpenuhi
- [x] `distance ≤ 50 m` → accepted & tersimpan.
- [x] `distance > 50 m` → rejected & tersimpan.
- [x] Distance & koordinat pengguna tercatat.
- [x] Error izin/GPS dikembalikan sebagai `Failure` yang tepat.

## Langkah Selanjutnya
Lanjut ke **Issue #07 — Fitur Absensi: Presentation (BLoC + UI + Dialog Hasil)**.
