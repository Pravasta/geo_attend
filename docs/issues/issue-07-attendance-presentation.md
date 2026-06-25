# Issue #07 — Fitur Absensi: Presentation (BLoC + UI + Dialog Hasil)

- **Branch**: `feat/issue-07-attendance-presentation`
- **Bergantung pada**: #06, #05
- **Status**: ⬜ Todo

## Deskripsi
Membangun lapisan presentation untuk Absensi: `AttendanceBloc`, halaman absensi
(pilih lokasi + tombol Absensi), dan dialog hasil yang menampilkan status
diterima/ditolak beserta jarak.

## Scope
**In Scope**
- `AttendanceBloc`, `AttendanceEvent`, `AttendanceState`.
- Halaman `AttendancePage`: pilih lokasi (dropdown/list) + tombol "Absensi".
- Dialog hasil: accepted (hijau) / rejected (merah) + info jarak.
- Penanganan loading saat mengambil GPS.
- Umpan balik via `fluttertoast`.

**Out of Scope**
- Halaman riwayat (issue #08).

## Langkah-langkah
1. Buat `AttendanceEvent`: `SubmitAttendance(locationId)`.
2. Buat `AttendanceState`: `AttendanceInitial`, `AttendanceLoading`,
   `AttendanceAccepted(record)`, `AttendanceRejected(distance)`, `AttendanceError`.
3. Implementasikan `AttendanceBloc` memanggil usecase `SubmitAttendance`.
4. UI `AttendancePage`: pemilihan lokasi (ambil dari LocationBloc/usecase),
   tombol Absensi, indikator loading.
5. `BlocListener` → tampilkan dialog hasil sesuai state:
   - Accepted: "Absensi berhasil. Jarak X m dari lokasi."
   - Rejected: "Absensi ditolak. Anda berada Y m (>50 m) dari lokasi."
   - Error: pesan izin/GPS + arahan.
6. Daftarkan `AttendanceBloc` di DI & `BlocProvider`.

## Acceptance Criteria
- Pengguna memilih lokasi lalu menekan Absensi.
- Dialog menampilkan hasil yang benar sesuai jarak (≤50 / >50).
- Error izin/GPS ditampilkan dengan jelas.
- Loading tampil selama pengambilan GPS.

## Testing
- `bloc_test` untuk `AttendanceBloc` (accepted/rejected/error).
- Uji manual: absen di dalam & luar radius (mock/real).

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-07-result.md`.
