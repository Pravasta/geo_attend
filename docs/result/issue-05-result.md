# Result — Issue #05: Fitur Lokasi — Presentation (BLoC + UI)

- **Branch**: `feat/issue-05-location-presentation`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Lapisan presentation untuk Manajemen Lokasi selesai: `LocationBloc` lengkap
dengan event/state, halaman daftar lokasi, dan form tambah/edit dengan tombol
geotagging. Aplikasi kini dapat dijalankan dan menampilkan fitur lokasi.

## Yang Dikerjakan

### BLoC
- **`LocationEvent`** (sealed): `LoadLocations`, `CaptureCoordinate`,
  `AddLocationEvent`, `UpdateLocationEvent`, `DeleteLocationEvent`.
- **`LocationState`** (sealed): `LocationInitial`, `LocationLoading`,
  `LocationLoaded`, `LocationOperationInProgress`, `LocationOperationSuccess`,
  `CoordinateCaptured`, `LocationError`.
- **`LocationBloc`** memanggil kelima usecase dari Issue #04.

### UI
- **`LocationListPage`** — daftar lokasi (`ListView`), loading/empty/error state,
  FAB "Tambah", aksi edit & hapus (dengan dialog konfirmasi).
- **`LocationFormPage`** — form tambah/edit: input nama (validasi), tombol
  "Ambil Koordinat (Geotagging)", kartu pratinjau koordinat & alamat, tombol
  simpan dengan indikator loading.
- **`LocationListItem`** — widget kartu item lokasi.
- Umpan balik via `fluttertoast` (sukses/gagal/koordinat diambil).

### Integrasi
- `LocationBloc` didaftarkan sebagai **factory** di DI (instance baru per halaman).
- `main.dart` sementara membuka `LocationListPage` (HomePage penuh dibuat di #09).

## Keputusan Teknis
- **Satu `LocationBloc` per halaman (factory, bukan singleton)** — halaman daftar
  dan form memakai instance terpisah sehingga state geotagging pada form tidak
  mencemari state daftar. Setelah form sukses, halaman daftar di-reload via
  `Navigator.pop(true)`.
- **`buildWhen` pada daftar** — daftar hanya rebuild untuk state yang relevan
  (`LocationLoading/Loaded/Error`); state operasi (`OperationSuccess`) ditangani
  `listener` (toast + reload) agar daftar tidak berkedip kosong.
- **State form dikelola lokal** (`TextEditingController` + koordinat lokal),
  BLoC hanya untuk operasi async (capture/simpan) — UX form lebih mulus.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **42 tests passed** |

### Cakupan Test
- **`bloc_test`** seluruh transisi `LocationBloc`: load (loaded/error),
  capture (captured/error izin), add/update (success), delete (success).
- **Widget smoke test**: `LocationListPage` menampilkan judul & empty state.

## Acceptance Criteria — Terpenuhi
- [x] Daftar lokasi tampil & ter-update setelah CRUD (reload setelah operasi).
- [x] Geotagging mengisi koordinat (& alamat) pada form.
- [x] Hapus meminta konfirmasi; sukses/gagal diberi umpan balik.
- [x] Loading & empty state tampil dengan benar.

## Catatan
- **Uji manual di perangkat** (mengambil koordinat GPS nyata, izin lokasi)
  direkomendasikan dijalankan pada perangkat fisik — perilaku GPS tidak dapat
  diuji penuh di unit/widget test. Verifikasi end-to-end menyeluruh dijadwalkan
  pada Issue #09.

## Langkah Selanjutnya
Lanjut ke **Issue #06 — Fitur Absensi: Domain & Data (Verifikasi Radius 50 m)**.
