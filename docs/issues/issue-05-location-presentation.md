# Issue #05 — Fitur Lokasi: Presentation (BLoC + UI)

- **Branch**: `feat/issue-05-location-presentation`
- **Bergantung pada**: #04
- **Status**: ⬜ Todo

## Deskripsi
Membangun lapisan presentation untuk Manajemen Lokasi: `LocationBloc` beserta
event/state, halaman daftar lokasi, dan form tambah/edit lokasi dengan tombol
geotagging.

## Scope
**In Scope**
- `LocationBloc`, `LocationEvent`, `LocationState` (pakai `equatable`).
- Halaman `LocationListPage` (ListView + FAB).
- Halaman/Form `LocationFormPage` (tambah & edit) dengan tombol "Ambil Koordinat".
- Aksi hapus dengan konfirmasi dialog.
- Umpan balik via `fluttertoast`.
- Wiring `BlocProvider` & DI.

**Out of Scope**
- Fitur absensi (issue #06–#07).
- Map picker.

## Langkah-langkah
1. Buat `LocationEvent`: `LoadLocations`, `AddLocation`, `UpdateLocation`,
   `DeleteLocation`, `CaptureCoordinate`.
2. Buat `LocationState`: `LocationInitial`, `LocationLoading`, `LocationLoaded`,
   `LocationOperationSuccess`, `CoordinateCaptured`, `LocationError`.
3. Implementasikan `LocationBloc` memanggil usecases dari issue #04.
4. UI `LocationListPage`: tampilkan list, loading, empty state; FAB → form.
5. UI `LocationFormPage`: TextField nama, tombol geotagging (tampilkan lat/lng/alamat),
   tombol simpan; mode edit memuat data awal.
6. Tangani error (izin/GPS) dengan pesan & toast yang jelas.
7. Daftarkan `LocationBloc` di DI dan sediakan via `BlocProvider`.

## Acceptance Criteria
- Daftar lokasi tampil dan ter-update setelah CRUD.
- Geotagging mengisi koordinat (& alamat) pada form.
- Hapus meminta konfirmasi; sukses/gagal diberi umpan balik.
- Loading & empty state tampil dengan benar.

## Testing
- `bloc_test` untuk seluruh transisi state `LocationBloc`.
- Uji manual alur tambah/edit/hapus + geotagging di perangkat.

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-05-result.md`.
