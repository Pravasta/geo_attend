# Result — Issue #11: Map Picker — Pilih Lokasi via Google Maps

- **Branch**: `feat/issue-11-map-picker`
- **Status**: ✅ Selesai (implementasi); render peta perlu uji manual dengan API key
- **Tanggal**: 26 Juni 2026

## Ringkasan
Map picker Google Maps selesai: pengguna dapat memilih titik lokasi secara
**akurat** di peta (tap/geser pin, zoom, ganti tipe peta) lalu mengonfirmasinya.
Hasil pemilihan (koordinat + alamat) mengisi form lokasi. Melengkapi geotagging
GPS yang sudah ada — keduanya tersedia sebagai opsi.

Memenuhi requirement asli task (`docs/task.txt` baris 8): geotagging untuk
mendapatkan titik lokasi (pin location) **secara akurat**.

## Yang Dikerjakan
1. **Dependency** — tambah `google_maps_flutter`.
2. **iOS** (dilanjutkan dari #10) — `AppDelegate.swift` memanggil
   `GMSServices.provideAPIKey` dengan key dibaca dari `.env` yang dibundel di
   `flutter_assets` (tetap sumber tunggal `.env`).
3. **`MapPickerPage`** (`features/location/presentation/pages/map_picker_page.dart`):
   - `GoogleMap` dengan marker yang dapat digeser & `onTap` memindahkan pin.
   - Zoom (kontrol bawaan) + tombol ganti tipe peta (normal/hybrid) untuk presisi.
   - Kartu info menampilkan koordinat terpilih (6 desimal) + tombol "Gunakan
     Lokasi Ini" (reverse geocoding alamat saat konfirmasi).
   - FAB "Ke lokasi saya" (memusatkan peta ke posisi GPS via `LocationService`).
   - Branch khusus bila API key kosong → tampil pesan ramah (tidak crash).
   - Mengembalikan `MapPickerResult(lat, lng, address?)`.
4. **Integrasi `LocationFormPage`**:
   - Tombol baru **"Pilih di Peta"** di samping **"Ambil Koordinat (GPS)"**.
   - Hasil map picker mengisi `latitude`, `longitude`, `address` pada form.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **63 tests passed** |

### Cakupan Test
- **Widget test `MapPickerPage`**: menampilkan pesan saat API key belum
  dikonfigurasi (branch tanpa render peta).
- Render peta penuh & pemilihan titik **butuh uji manual** di perangkat dengan
  API key (platform view tidak dapat dirender di widget test).

## Keputusan Teknis
- **`.env` tetap sumber tunggal** key — Android (Gradle, #10) & iOS (AppDelegate
  membaca asset `.env`) memakai nilai yang sama.
- **Reverse geocoding di `MapPickerPage`** (memakai `GeocodingService` dari DI)
  untuk mendapatkan alamat titik terpilih — kompromi pragmatis di presentation
  agar tidak menambah usecase/bloc baru khusus untuk satu pemanggilan tampilan.
- **Map picker melengkapi, bukan menggantikan** geotagging GPS — pengguna bebas
  memilih sumber koordinat.
- **Graceful degradation** — bila API key kosong, halaman menampilkan pesan
  alih-alih peta abu-abu yang membingungkan.

## Catatan Setup (perlu perhatian)
- **API key**: isi `MAPS_API_KEY` pada `.env`, aktifkan **Maps SDK for Android**
  & **Maps SDK for iOS** di Google Cloud Console.
- **iOS deployment target**: `google_maps_flutter_ios` membutuhkan **iOS 14+**.
  Saat `pod install`/build iOS pertama, pastikan `ios/Podfile` menyetel
  `platform :ios, '14.0'` (Podfile di-generate saat build pertama).
- **Android `minSdk`**: google_maps_flutter butuh `minSdk ≥ 21` (default Flutter
  sudah memenuhi).

## Acceptance Criteria — Status
- [x] Pengguna dapat membuka peta dari form & memilih titik secara akurat
  (zoom & geser pin).
- [x] Koordinat (6 desimal) & alamat hasil pemilihan masuk ke form.
- [x] Geotagging GPS lama tetap berfungsi (tidak ada regresi).
- [x] Tidak crash bila API key belum diisi (pesan jelas).
- [~] Render peta nyata — perlu uji manual dengan API key (di luar kemampuan
  unit/widget test).

## Langkah Selanjutnya
Lanjut ke **Issue #09 — Penyempurnaan UI/UX, Edge Cases & Dokumentasi Akhir**
(tahap terakhir: HomePage final + dokumentasi akhir mencakup map picker).
