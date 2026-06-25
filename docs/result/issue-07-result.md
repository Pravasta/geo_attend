# Result — Issue #07: Fitur Absensi — Presentation (BLoC + UI + Dialog Hasil)

- **Branch**: `feat/issue-07-attendance-presentation`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Lapisan presentation untuk Absensi selesai: `AttendanceBloc`, halaman absensi
(pilih lokasi + tombol "Absensi Sekarang"), dan dialog hasil yang menampilkan
status diterima/ditolak beserta jarak. Aplikasi kini dapat melakukan alur
absensi end-to-end.

## Yang Dikerjakan

### BLoC
- **`AttendanceEvent`** (sealed): `SubmitAttendanceEvent(LocationEntity)`.
- **`AttendanceState`** (sealed): `AttendanceInitial`, `AttendanceSubmitting`,
  `AttendanceAccepted(record)`, `AttendanceRejected(record)`,
  `AttendanceFailureState(message)`.
- **`AttendanceBloc`** memanggil `SubmitAttendance`; memetakan hasil ke
  Accepted/Rejected berdasarkan `record.isAccepted`.

### UI
- **`AttendancePage`** — `MultiBlocProvider` (`LocationBloc` untuk memuat daftar
  lokasi + `AttendanceBloc` untuk submit):
  - Dropdown pemilihan lokasi + kartu info lokasi terpilih (koordinat, radius).
  - Tombol "Absensi Sekarang" dengan indikator loading saat memproses.
  - Empty state bila belum ada lokasi terdaftar.
- **`AttendanceResultDialog`** — dialog hasil:
  - Accepted: ikon hijau, "Absensi Berhasil", info jarak (dalam radius).
  - Rejected: ikon merah, "Absensi Ditolak", info jarak (di luar radius).
- Error (izin/GPS) → umpan balik `fluttertoast`.

### Integrasi
- `AttendanceBloc` didaftarkan sebagai **factory** di DI.
- `main.dart` kini memakai **home sementara** (`_TempHomePage`) dengan navigasi
  ke "Absensi" dan "Manajemen Lokasi" (HomePage final dibuat di Issue #09).

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **55 tests passed** |

### Cakupan Test
- **`bloc_test`** `AttendanceBloc`: dalam radius → `[Submitting, Accepted]`;
  di luar radius → `[Submitting, Rejected]`; error izin/GPS →
  `[Submitting, FailureState]`.

## Keputusan Teknis
- **`MultiBlocProvider`** menggabungkan `LocationBloc` (sumber daftar lokasi) dan
  `AttendanceBloc` (submit) pada satu halaman, memanfaatkan kembali usecase
  lokasi tanpa menduplikasi logika pemuatan daftar.
- **Validasi pemilihan** — item terpilih divalidasi ulang terhadap daftar
  terkini agar tidak merujuk lokasi yang sudah dihapus.
- **Home sementara di `main.dart`** untuk membuat fitur absensi dapat diakses
  lebih awal; akan digantikan HomePage final di #09.

## Acceptance Criteria — Terpenuhi
- [x] Pengguna memilih lokasi lalu menekan Absensi.
- [x] Dialog menampilkan hasil benar sesuai jarak (≤50 diterima / >50 ditolak).
- [x] Error izin/GPS ditampilkan dengan jelas.
- [x] Loading tampil selama pengambilan GPS.

## Catatan
- Uji manual GPS nyata (di dalam & luar radius) sebaiknya dijalankan pada
  perangkat fisik; verifikasi E2E menyeluruh dijadwalkan pada Issue #09.

## Langkah Selanjutnya
Lanjut ke **Issue #08 — Riwayat Absensi (List + Format Tanggal)**.
