# Issue #11 — Map Picker: Pilih Lokasi via Google Maps

- **Branch**: `feat/issue-11-map-picker`
- **Bergantung pada**: #10, #05
- **Dikerjakan sebelum**: #09 (final)
- **Status**: ⬜ Todo

## Deskripsi
Menambahkan kemampuan memilih titik lokasi menggunakan **Google Maps**
(`google_maps_flutter`). Pengguna dapat membuka peta, menggeser/menyentuh untuk
menempatkan pin, lalu mengonfirmasi titik tersebut sebagai koordinat lokasi.
Fitur ini **melengkapi** geotagging GPS yang sudah ada (Issue #04/#05) — pengguna
bebas memilih: ambil koordinat via GPS **atau** pilih di peta.

## Scope
**In Scope**
- Tambah dependency `google_maps_flutter`.
- Halaman `MapPickerPage` menampilkan `GoogleMap`:
  - Posisi awal: lokasi saat ini (jika izin ada) atau koordinat lokasi yang
    sedang diedit; fallback ke koordinat default.
  - Pilih titik dengan tap pada peta dan/atau menggeser marker.
  - Tampilkan koordinat terpilih + tombol "Gunakan Lokasi Ini".
  - (Opsional) reverse geocoding untuk menampilkan alamat titik terpilih.
- Integrasi ke `LocationFormPage`:
  - Tombol baru "Pilih di Peta" di samping "Ambil Koordinat (GPS)".
  - Hasil pemilihan mengisi `latitude`, `longitude`, dan `address`.
- Penanganan API key tidak tersedia (peta gagal dimuat) dengan pesan ramah.

**Out of Scope**
- Menampilkan radius/geofence sebagai lingkaran di peta (boleh jadi peningkatan
  lanjutan; opsional bila waktu memungkinkan).
- Mengubah logika verifikasi absensi (tetap memakai `DistanceCalculator`).
- Navigasi turn-by-turn atau pencarian tempat (places autocomplete).

## Langkah-langkah
1. Tambah `google_maps_flutter` ke `pubspec.yaml`, `pub get`.
2. Pastikan konfigurasi API key dari **Issue #10** aktif (Android manifest & iOS).
3. Buat `features/location/presentation/pages/map_picker_page.dart`:
   - `GoogleMap` dengan `onTap` untuk memindahkan marker.
   - State titik terpilih (`LatLng`).
   - Tombol konfirmasi mengembalikan hasil (`Navigator.pop` dengan koordinat).
4. (Opsional) panggil `GeocodingService` untuk alamat titik terpilih.
5. Integrasikan ke `LocationFormPage`:
   - Tambah tombol "Pilih di Peta" → buka `MapPickerPage` → isi koordinat/alamat
     pada form (gunakan mekanisme `setState` yang sudah ada).
6. Tangani kasus peta gagal (API key kosong/salah) — tampilkan pesan.
7. Uji manual di perangkat (peta tampil, pilih titik, koordinat terisi).

## Acceptance Criteria
- Pengguna dapat membuka peta dari form lokasi dan memilih titik.
- Koordinat (dan alamat bila tersedia) hasil pemilihan masuk ke form.
- Geotagging GPS lama tetap berfungsi (tidak ada regресi).
- Aplikasi tidak crash bila API key belum diisi (pesan jelas).

## Testing
- Widget test `MapPickerPage` untuk interaksi dasar (bila memungkinkan tanpa
  render peta asli; minimal verifikasi tombol konfirmasi mengembalikan nilai).
- Verifikasi integrasi form: hasil map picker mengisi state koordinat.
- Uji manual di perangkat fisik (render peta butuh API key + platform).

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-11-result.md`.
