# Issue #10 — Konfigurasi Environment (.env) & Google Maps API Key

- **Branch**: `feat/issue-10-env-google-maps-key`
- **Bergantung pada**: #01
- **Dikerjakan sebelum**: #09 (final)
- **Status**: ⬜ Todo

## Deskripsi
Menyiapkan manajemen konfigurasi rahasia melalui file **`.env`** (menggunakan
`flutter_dotenv`) dan menanam **Google Maps API Key** ke konfigurasi native
Android & iOS. Ini adalah **prasyarat** untuk Issue #11 (Map Picker), agar API
key tidak hardcoded di kode dan tidak ikut ter-commit ke repository.

> Catatan: nilai Google Maps API Key akan disiapkan oleh pemilik project pada
> file `.env` lokal. Repo hanya menyimpan contoh (`.env.example`).

## Scope
**In Scope**
- Tambah dependency `flutter_dotenv`.
- Buat `.env` (lokal, di-ignore) & `.env.example` (template, di-commit).
- Tambahkan `.env` ke `.gitignore` dan ke `assets` pada `pubspec.yaml`.
- Muat `.env` saat startup (`main.dart`) sebelum `runApp`.
- Buat helper `core/config/env_config.dart` untuk akses nilai env yang aman.
- Konfigurasi native agar Google Maps membaca API key:
  - Android: inject `MAPS_API_KEY` melalui `AndroidManifest.xml` +
    `local.properties`/`build.gradle` (atau secrets-gradle-plugin), atau
    pendekatan manifest placeholder.
  - iOS: set API key di `AppDelegate.swift` membaca dari env/plist.
- Dokumentasi cara mengisi API key di `README` / hasil issue.

**Out of Scope**
- Implementasi peta & map picker (Issue #11).
- Fitur lokasi lain.

## Langkah-langkah
1. Tambah `flutter_dotenv` ke `pubspec.yaml`, jalankan `pub get`.
2. Buat file:
   - `.env` → `MAPS_API_KEY=` (kosong, diisi pemilik project).
   - `.env.example` → `MAPS_API_KEY=your_api_key_here`.
3. Update `.gitignore`: tambahkan `.env` (pastikan `.env.example` tetap ter-track).
4. Daftarkan `.env` sebagai asset di `pubspec.yaml` (`assets: - .env`).
5. `core/config/env_config.dart`:
   - `static String get mapsApiKey => dotenv.env['MAPS_API_KEY'] ?? '';`
   - getter aman + validasi opsional.
6. `main.dart`: `await dotenv.load(fileName: ".env");` sebelum `di.init()`.
7. Konfigurasi Android:
   - `AndroidManifest.xml`: `<meta-data android:name="com.google.android.geo.API_KEY"
     android:value="${MAPS_API_KEY}"/>`.
   - Inject `MAPS_API_KEY` via `manifestPlaceholders` di `build.gradle.kts`
     (membaca dari `local.properties` atau env), tanpa commit nilai asli.
8. Konfigurasi iOS:
   - `AppDelegate.swift`: `GMSServices.provideAPIKey(...)` membaca nilai
     (mis. dari `Info.plist`/env yang diisi saat build).
9. Tulis instruksi pengisian API key.

## Acceptance Criteria
- `.env` ter-ignore; `.env.example` ter-commit sebagai template.
- Aplikasi memuat `.env` saat startup tanpa crash (meski key kosong).
- `EnvConfig.mapsApiKey` mengembalikan nilai dari `.env`.
- Konfigurasi native siap menerima API key (terverifikasi tidak error saat build
  setelah key diisi).
- Tidak ada API key yang ter-commit ke repository.

## Testing
- Unit test `EnvConfig` (dengan `dotenv.testLoad`) mengembalikan nilai yang benar.
- `flutter analyze` bersih; aplikasi tetap berjalan tanpa key (peta diuji di #11).

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-10-result.md`.
