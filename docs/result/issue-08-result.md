# Result — Issue #08: Riwayat Absensi (List + Format Tanggal)

- **Branch**: `feat/issue-08-attendance-history`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Halaman riwayat absensi selesai: menampilkan seluruh catatan absensi (diterima &
ditolak) dengan nama lokasi, waktu terformat (`intl`), badge status berwarna, dan
jarak. Dilengkapi loading, empty, dan error state, serta pull-to-refresh.

## Yang Dikerjakan

### Util
- **`core/utils/date_formatter.dart`** — `DateFormatter.formatDateTime` memakai
  `intl` (`DateFormat('dd MMM yyyy, HH:mm')`).

### BLoC
- **`AttendanceHistoryBloc`** (bloc terpisah dari `AttendanceBloc`) dengan event
  `LoadAttendanceHistory` dan state `Initial`/`Loading`/`Loaded(history)`/`Error`.

### UI
- **`AttendanceHistoryPage`** — `ListView` riwayat, loading/empty/error state,
  `RefreshIndicator` (tarik untuk memuat ulang).
- **`AttendanceHistoryItem`** — kartu item: ikon & badge status (hijau "Diterima"
  / merah "Ditolak"), nama lokasi, waktu terformat, jarak.

### Integrasi
- `AttendanceHistoryBloc` didaftarkan sebagai **factory** di DI.
- Tombol **"Riwayat Absensi"** ditambahkan pada home sementara (`main.dart`).

## Keputusan Teknis
- **Bloc terpisah (`AttendanceHistoryBloc`)** alih-alih menumpang di
  `AttendanceBloc` — memisahkan concern "submit absensi" dari "memuat riwayat"
  sehingga state masing-masing tidak saling mengganggu.
- **Urutan terbaru dulu** sudah dijamin di data source (`ORDER BY timestamp DESC`
  dari Issue #06), sehingga UI cukup menampilkan apa adanya.
- **Riwayat dimuat ulang tiap halaman dibuka** (BLoC dibuat saat masuk halaman),
  sehingga absensi terbaru langsung tampil; ditambah pull-to-refresh.
- **Format tanggal locale-independent** (`dd MMM yyyy, HH:mm`) untuk menghindari
  kebutuhan inisialisasi data locale `intl`.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **60 tests passed** |

### Cakupan Test
- **`bloc_test`** `AttendanceHistoryBloc`: ada riwayat → `[Loading, Loaded]`;
  kosong → `[Loading, Loaded([])]`; gagal → `[Loading, Error]`.
- **`DateFormatter`**: format & padding nol jam/menit.

## Acceptance Criteria — Terpenuhi
- [x] Riwayat tampil terurut (terbaru di atas).
- [x] Tanggal & waktu terformat rapi (`intl`).
- [x] Status accepted/rejected dibedakan secara visual (badge berwarna).
- [x] Empty state tampil bila belum ada data.

## Langkah Selanjutnya
Lanjut ke **Issue #09 — Penyempurnaan UI/UX, Edge Cases & Dokumentasi Akhir**
(termasuk HomePage final menggantikan home sementara).
