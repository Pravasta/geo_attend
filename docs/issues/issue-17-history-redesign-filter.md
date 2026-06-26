# Issue #17 — Redesain Riwayat Absensi + Filter

- **Branch**: `feat/issue-17-history-redesign-filter`
- **Fase**: Implementasi Desain
- **Bergantung pada**: #12
- **Referensi desain**: `docs/design/results/GeoAttend Mockups.dc.html` — Section F
- **Status**: ⬜ Todo

## Deskripsi
Menerapkan desain Riwayat Absensi: item list baru, **filter chips**
(Semua/Diterima/Ditolak), dan empty state yang lebih baik.

## Scope
**In Scope**
- **Filter chips**: Semua (aktif=gradien), Diterima (outline hijau), Ditolak
  (outline merah). Memfilter daftar berdasarkan status.
- **Item riwayat**: ikon status dalam kotak, nama lokasi, tanggal+waktu
  terformat (mis. "Kam, 26 Jun 2026 · 08:02 WIB"), "X m dari titik" berwarna,
  badge status (pill).
- **Empty state**: ikon `history_toggle_off`, judul "Belum ada riwayat",
  deskripsi, tombol **Absensi Sekarang** (pakai `EmptyStateView`).
- Pertahankan pull-to-refresh.

**Out of Scope**
- Eksport/hapus riwayat (pengembangan lanjutan).

## Langkah-langkah
1. Tambah filter status pada `AttendanceHistoryBloc` (event `FilterChanged`
   atau state menyimpan filter aktif) — filtering **client-side** atas data yang
   sudah dimuat.
2. Bangun ulang item riwayat sesuai mockup (format tanggal pakai `DateFormatter`,
   pertimbangkan menambah hari dalam bahasa Indonesia, mis. format `EEE, dd MMM
   yyyy · HH:mm`).
3. Tambahkan baris **filter chips** di atas list.
4. Terapkan `EmptyStateView` (termasuk saat filter menghasilkan kosong → pesan
   sesuai).
5. Pertahankan pull-to-refresh.

## Acceptance Criteria
- Filter chips memfilter daftar (Semua/Diterima/Ditolak) dengan benar.
- Item riwayat tampil sesuai mockup (waktu terformat, jarak berwarna, badge).
- Empty state tampil saat tidak ada data / hasil filter kosong.
- `flutter analyze` bersih.

## Testing
- `bloc_test`: filter menghasilkan subset yang benar (accepted/rejected/semua).
- Widget test: chips tampil; empty state saat kosong.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-17-result.md`.
