# Result — Issue #13: Redesain Home Dashboard & Splash

- **Branch**: `feat/issue-13-home-dashboard-redesign`
- **Fase**: Implementasi Desain
- **Status**: ✅ Selesai
- **Tanggal**: 26 Juni 2026

## Ringkasan
Home dirombak sesuai mockup menjadi dashboard yang kaya: header gradien dengan
sapaan dinamis, **kartu ringkasan** (lokasi, absensi, terakhir), kartu aksi
"Absensi Sekarang", menu list, dan info banner. Splash disempurnakan dengan
animasi pulse di belakang logo.

## Yang Dikerjakan

### Data ringkasan (tanpa data layer baru)
- **`HomeCubit`** + `HomeState` (`HomeLoading`/`HomeLoaded`) dengan `HomeSummary`
  (locationCount, attendanceCount, lastAttendance) — **reuse** `GetLocations` &
  `GetAttendanceHistory`. Didaftarkan sebagai factory di DI.
- `DateFormatter.formatTime` ditambahkan (format `HH:mm`).

### Home (sesuai mockup Variasi 2)
- Header gradien: **sapaan dinamis** (pagi/siang/sore/malam) + nama app + ikon.
- **Kartu ringkasan** (overlap header): Lokasi / Absensi / Terakhir (waktu, warna
  mengikuti status absensi terakhir); skeleton saat loading.
- **Kartu aksi** "Absensi Sekarang" (gradien + shadow) → halaman Absensi.
- **Menu** (Lokasi & Riwayat) sebagai list dengan ikon + chevron.
- **InfoBanner** pengingat GPS.
- Kembali dari sub-halaman → ringkasan otomatis dimuat ulang (`load()`).

### Splash
- Animasi **pulse** (lingkaran memudar) di belakang logo, selain fade + scale.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **73 tests passed** |

### Cakupan Test
- **`HomeCubit`**: `load()` menghitung ringkasan dari usecase (dengan data &
  saat kosong).
- **Widget**: Home menampilkan kartu aksi & menu; Splash menampilkan nama app
  lalu berpindah ke HomePage.

## Keputusan Teknis
- **`HomeCubit` reuse usecase** (`GetLocations`, `GetAttendanceHistory`) — tidak
  menambah data layer; ringkasan tahan-gagal (default kosong bila usecase gagal).
- **Reload saat kembali** ke Home agar ringkasan (mis. setelah absensi) selalu
  terbaru.
- **Overlap kartu ringkasan** memakai `Transform.translate(-32)` agar tampil
  menimpa header gradien sesuai mockup.

## Acceptance Criteria — Terpenuhi
- [x] Home menampilkan ringkasan (lokasi, absensi, terakhir) dari data nyata.
- [x] Navigasi ke Absensi, Lokasi, Riwayat berfungsi.
- [x] Sapaan menyesuaikan waktu.
- [x] Tampilan presisi dengan mockup; `flutter analyze` bersih.

## Langkah Selanjutnya
Lanjut ke **Issue #14 — Redesain Manajemen Lokasi (List/Empty/Skeleton)**.
