# Issue #14 — Redesain Manajemen Lokasi (List, Empty, Skeleton)

- **Branch**: `feat/issue-14-location-list-redesign`
- **Fase**: Implementasi Desain
- **Bergantung pada**: #12
- **Referensi desain**: `docs/design/results/GeoAttend Mockups.dc.html` — Section C
- **Status**: ⬜ Todo

## Deskripsi
Menerapkan desain halaman Daftar Lokasi: kartu lokasi baru, empty state yang
informatif, dan **loading skeleton** menggantikan spinner.

## Scope
**In Scope**
- **Kartu lokasi**: ikon dalam kotak, nama + alamat, chip koordinat & chip
  radius (`⊙ 50 m`), tombol **Edit** & **Hapus** (tombol berlabel + ikon, bukan
  icon-button polos), pemisah atas tombol.
- **Empty state**: ikon `location_off` dalam kotak, judul "Belum ada lokasi",
  deskripsi, tombol **Tambah Lokasi** (pakai `EmptyStateView` dari #12).
- **Loading skeleton**: kartu skeleton (3 item) menggantikan `CircularProgress`.
- **FAB** gradien (tambah).
- AppBar dengan tombol back konsisten.

**Out of Scope**
- Form & map picker (Issue #15).

## Langkah-langkah
1. Buat ulang `LocationListItem` sesuai mockup (chip koordinat/radius, tombol
   Edit/Hapus berlabel).
2. Ganti loading `CircularProgressIndicator` dengan skeleton (komponen #12).
3. Terapkan `EmptyStateView` untuk kondisi kosong + tombol Tambah.
4. Sesuaikan FAB & AppBar dengan desain.
5. Pertahankan logika BLoC eksisting (load/CRUD/konfirmasi hapus).

## Acceptance Criteria
- Daftar lokasi tampil sesuai mockup (kartu, chip, tombol Edit/Hapus).
- Loading menampilkan skeleton; empty menampilkan EmptyStateView + CTA.
- CRUD & konfirmasi hapus tetap berfungsi (tanpa regresi).
- `flutter analyze` bersih.

## Testing
- Widget test: empty state tampil; item menampilkan nama & tombol aksi.
- Pastikan `bloc_test` LocationBloc yang ada tetap hijau.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-14-result.md`.
