# Result — Issue #10: Konfigurasi Environment (.env) & Google Maps API Key

- **Branch**: `feat/issue-10-env-google-maps-key`
- **Status**: ✅ Selesai
- **Tanggal**: 25 Juni 2026

## Ringkasan
Infrastruktur konfigurasi rahasia melalui `.env` selesai: `flutter_dotenv`
terpasang, file `.env`/`.env.example` dibuat, key dibaca aman via `EnvConfig`,
dan Android dikonfigurasi menginjeksikan Google Maps API key dari `.env` ke
manifest saat build. Tidak ada API key yang ter-commit ke repository.

## Yang Dikerjakan
1. **Dependency** — tambah `flutter_dotenv`.
2. **File env**:
   - `.env` (lokal, di-`.gitignore`) berisi `MAPS_API_KEY=` (diisi pemilik project).
   - `.env.example` (di-commit) sebagai template.
3. **`.gitignore`** — menambahkan `.env` (memastikan `.env.example` tetap ter-track).
4. **`pubspec.yaml`** — mendaftarkan `.env` sebagai asset.
5. **`core/config/env_config.dart`** — `EnvConfig.mapsApiKey` & `hasMapsApiKey`
   (akses aman via `dotenv.maybeGet`).
6. **`main.dart`** — memuat `.env` (`dotenv.load`) sebelum `di.init()`, dibungkus
   `try/catch` agar aplikasi tetap berjalan meski file/key belum ada.
7. **Android**:
   - `build.gradle.kts` membaca `MAPS_API_KEY` dari `.env` di root project lalu
     menyetelnya sebagai `manifestPlaceholders["MAPS_API_KEY"]`.
   - `AndroidManifest.xml` menambahkan `<meta-data
     android:name="com.google.android.geo.API_KEY" android:value="${MAPS_API_KEY}"/>`.
8. **README** — menambahkan bagian "Konfigurasi Environment (.env)" dengan langkah
   pengisian API key.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **62 tests passed** |

### Cakupan Test
- **`EnvConfig`** (`dotenv.loadFromString`): mengembalikan nilai key;
  `hasMapsApiKey` false saat kosong.

## Keputusan Teknis
- **`.env` sebagai sumber tunggal** — dibaca baik oleh Dart (`flutter_dotenv`)
  maupun oleh Android Gradle (parsing langsung file `.env`) sehingga API key cukup
  diisi di satu tempat.
- **`flutter_dotenv` 6.0.1** memakai `loadFromString` untuk pengujian (bukan
  `testLoad` versi lama) dan `maybeGet` untuk akses nilai.
- **Pemuatan env bersifat opsional** (`try/catch`) — aplikasi tidak crash bila
  `.env` kosong/absen; fitur peta menampilkan pesan saat key kosong (Issue #11).

## Catatan / Deviasi Scope
- **Konfigurasi native iOS (GMSServices.provideAPIKey) ditunda ke Issue #11.**
  Pemanggilan `GMSServices.provideAPIKey` membutuhkan SDK `GoogleMaps` yang baru
  tersedia setelah `google_maps_flutter` ditambahkan (#11). Menambahkannya di #10
  akan menyebabkan iOS gagal kompilasi (modul `GoogleMaps` belum ada). Maka
  inisialisasi key iOS dikerjakan bersamaan dengan integrasi peta di #11.
- **Verifikasi build Android dengan key asli** sebaiknya dilakukan setelah key
  diisi (render peta diuji pada #11).

## Acceptance Criteria — Status
- [x] `.env` ter-ignore; `.env.example` ter-commit sebagai template.
- [x] Aplikasi memuat `.env` saat startup tanpa crash (meski key kosong).
- [x] `EnvConfig.mapsApiKey` mengembalikan nilai dari `.env`.
- [x] Konfigurasi native **Android** siap menerima API key.
- [~] Konfigurasi native **iOS** — ditunda ke #11 (alasan teknis di atas).
- [x] Tidak ada API key yang ter-commit ke repository.

## Langkah Selanjutnya
Lanjut ke **Issue #11 — Map Picker: Pilih Lokasi via Google Maps** (termasuk
inisialisasi API key iOS).
