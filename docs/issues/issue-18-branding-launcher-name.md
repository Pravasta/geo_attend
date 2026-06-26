# Issue #18 — Branding: Launcher Icon & Nama Aplikasi

- **Branch**: `feat/issue-18-branding-launcher-name`
- **Fase**: Finalisasi / Branding
- **Bergantung pada**: #09
- **Status**: ⬜ Todo

## Deskripsi
Menerapkan branding aplikasi: memakai **logo** (`assets/app_logo.png`) sebagai
**launcher icon** (Android & iOS) dan mengubah **nama aplikasi** yang tampil di
launcher menjadi **"GeoAttendance"** (lebih rapi dari `geo_attend`).

## Scope
**In Scope**
- Tambah `flutter_launcher_icons` (dev) + konfigurasi memakai `assets/app_logo.png`.
- Generate launcher icon untuk Android & iOS.
- Ubah nama aplikasi (label launcher):
  - Android: `android:label` → `GeoAttendance`.
  - iOS: `CFBundleDisplayName` → `GeoAttendance`.
- Pastikan build APK menampilkan nama & ikon baru.

**Out of Scope**
- Perubahan brand di dalam aplikasi (splash/home tetap "GeoAttend") — dapat
  disesuaikan terpisah bila diinginkan.
- Perubahan `applicationId` / bundle id.

## Langkah-langkah
1. Tambah `flutter_launcher_icons` ke `dev_dependencies`.
2. Buat konfigurasi `flutter_launcher_icons` (image_path `assets/app_logo.png`,
   android + ios, adaptive bila perlu).
3. Jalankan `dart run flutter_launcher_icons` untuk generate ikon.
4. Ubah `android:label` di `AndroidManifest.xml` → `GeoAttendance`.
5. Ubah `CFBundleDisplayName` di `ios/Runner/Info.plist` → `GeoAttendance`.
6. Verifikasi (`flutter analyze`, build profile) ikon & nama tampil benar.

## Acceptance Criteria
- Launcher icon memakai `assets/app_logo.png` (Android & iOS).
- Nama aplikasi di launcher = **GeoAttendance**.
- `flutter analyze` bersih; build profile berhasil.

## Testing
- `flutter analyze` lulus; build APK profile sukses.
- Verifikasi manual ikon & label saat aplikasi terpasang di perangkat.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-18-result.md`.
