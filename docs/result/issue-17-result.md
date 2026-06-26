# Result — Issue #17: Redesain Riwayat Absensi + Filter

- **Branch**: `feat/issue-17-history-redesign-filter`
- **Fase**: Implementasi Desain
- **Status**: ✅ Selesai
- **Tanggal**: 26 Juni 2026

## Ringkasan
Halaman Riwayat Absensi dirombak sesuai mockup (Section F): **filter chips**
(Semua/Diterima/Ditolak), item baru dengan waktu berformat Indonesia, jarak
berwarna, dan badge status; serta empty state yang lebih baik.

## Yang Dikerjakan

### Filter (BLoC)
- `AttendanceFilter` (all/accepted/rejected), event `FilterChanged`.
- `AttendanceHistoryLoaded` menyimpan `all` + `filter` dengan getter **`filtered`**
  (filtering **client-side** atas data yang sudah dimuat) + `copyWith`.
- Filter aktif **dipertahankan** saat memuat ulang.

### UI
- **Filter chips** di atas list: "Semua" (gradien saat aktif), "Diterima" (hijau),
  "Ditolak" (merah).
- **Item riwayat** baru: ikon status dalam kotak, nama lokasi, **waktu** (format
  Indonesia mis. `Jum, 26 Jun 2026 · 08:02`), "X m dari titik" berwarna, badge
  status (pill compact).
- **Empty state** (`EmptyStateView`): beda pesan untuk "belum ada riwayat" vs
  "hasil filter kosong".
- Pull-to-refresh dipertahankan.

### Util
- `DateFormatter.formatHistoryDateTime` — hari & bulan Indonesia secara
  deterministik (tanpa inisialisasi locale `intl`).

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **78 tests passed** |

### Cakupan Test
- `bloc_test`: `FilterChanged` menyaring daftar (rejected → hanya item ditolak).
- `DateFormatter.formatHistoryDateTime`: hari & bulan Indonesia.
- Test history lama (loaded/empty/error) tetap hijau.

## Keputusan Teknis
- **Filtering client-side** di state (`filtered` getter) — tanpa query ulang DB;
  ringan & responsif.
- **Format tanggal Indonesia manual** (peta hari/bulan) agar deterministik &
  testable tanpa `initializeDateFormatting`.
- **Empty state kontekstual** — membedakan "belum ada data" dan "filter kosong".

## Acceptance Criteria — Terpenuhi
- [x] Filter chips memfilter daftar (Semua/Diterima/Ditolak) dengan benar.
- [x] Item riwayat sesuai mockup (waktu terformat, jarak berwarna, badge).
- [x] Empty state tampil saat tidak ada data / hasil filter kosong.
- [x] `flutter analyze` bersih.

## Penutup
Issue UI terakhir selesai. Seluruh **Fase 2 (Implementasi Desain, #12–#17)**
tuntas — aplikasi kini presisi dengan mockup desain.
