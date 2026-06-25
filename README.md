# GeoAttend

Aplikasi absensi berbasis lokasi (GPS) menggunakan Flutter, Clean Architecture,
BLoC, dan Drift. Pengguna mendaftarkan lokasi (geotagging) lalu melakukan absensi
yang diverifikasi berada dalam radius 50 meter dari titik lokasi.

## Persyaratan
- Flutter 3.44.3 (dikelola via [FVM](https://fvm.app), dipin di `.fvmrc`)
- Dart 3.12.x

## Konfigurasi Environment (.env)

Aplikasi memuat konfigurasi rahasia (Google Maps API key) dari file `.env` di root
project. File `.env` **tidak** ikut ter-commit (di-`.gitignore`); yang di-commit
hanya `.env.example` sebagai template.

Langkah setup:

1. Salin template:
   ```bash
   cp .env.example .env
   ```
2. Isi `MAPS_API_KEY` pada `.env` dengan Google Maps API key Anda:
   ```env
   MAPS_API_KEY=AIza...your_key...
   ```
3. Aktifkan **Maps SDK for Android** (dan **Maps SDK for iOS** bila membangun iOS)
   pada [Google Cloud Console](https://console.cloud.google.com/) untuk key tersebut.

> Catatan: nilai key dibaca oleh aplikasi (Dart) melalui `flutter_dotenv`, dan oleh
> Android Gradle yang menginjeksikannya ke `AndroidManifest.xml`
> (`com.google.android.geo.API_KEY`) saat build. Aplikasi tetap berjalan meski key
> kosong (peta ditampilkan dengan pesan saat fitur map picker diaktifkan — Issue #11).

## Menjalankan

```bash
fvm flutter pub get
fvm flutter run
```

## Pengujian

```bash
fvm flutter test
```

## Dokumentasi
Proses pengembangan didokumentasikan pada folder `docs/`:
- `docs/brainstorming/` — brainstorming awal
- `docs/issues/` — pemecahan task menjadi issue
- `docs/result/` — hasil tiap issue
- `docs/revision/` — catatan revisi
- `docs/final/` — dokumentasi akhir
