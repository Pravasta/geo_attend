# Issue #16 — Redesain Absensi & Dialog Hasil

- **Branch**: `feat/issue-16-attendance-dialog-redesign`
- **Fase**: Implementasi Desain
- **Bergantung pada**: #12
- **Referensi desain**: `docs/design/results/GeoAttend Mockups.dc.html` — Section E
- **Status**: ⬜ Todo

## Deskripsi
Menerapkan desain halaman Absensi (pemilih lokasi + detail + tombol fixed) dan
dialog hasil (Diterima/Ditolak) yang lebih informatif & beranimasi.

## Scope
**In Scope**
- **Halaman Absensi**:
  - Pemilih lokasi (dropdown bergaya kartu, ikon place + chevron).
  - **Kartu "Detail Lokasi"**: Koordinat, Radius, **Status GPS** (Aktif/Tidak).
  - **Preview posisi** ("Posisi Anda · ± N m akurasi") — placeholder visual.
  - Tombol **Absensi Sekarang** fixed di bawah (gradient fade), state loading.
  - Empty state bila belum ada lokasi.
- **Dialog Hasil**:
  - **Diterima**: ikon `check_circle` hijau + animasi pulse, judul "Absensi
    Berhasil", nama lokasi, **kartu jarak** ("X m dari titik lokasi · Dalam
    radius 50 m · waktu"), tombol Selesai (gradien).
  - **Ditolak**: ikon `cancel` merah, judul "Absensi Ditolak", kartu jarak
    ("X m · Di luar radius 50 m"), tombol Tutup (outline).

**Out of Scope**
- Logika verifikasi (sudah ada); hanya tampilan.
- Akurasi GPS nyata sebagai angka (boleh ditampilkan bila tersedia dari
  `Position.accuracy`, jika tidak tampilkan placeholder).

## Langkah-langkah
1. Bangun ulang `AttendancePage`: pemilih lokasi, kartu detail (status GPS dari
   `LocationService.isLocationServiceEnabled`), tombol fixed.
2. (Opsional) tampilkan akurasi dari `Position.accuracy` bila mudah diperoleh.
3. Bangun ulang `AttendanceResultDialog` (accepted/rejected) sesuai mockup,
   memakai data `AttendanceEntity` (jarak, nama lokasi, waktu).
4. Pertahankan `AttendanceBloc` & alur submit yang ada.

## Acceptance Criteria
- Halaman absensi & dialog tampil sesuai mockup.
- Dialog menampilkan jarak & status yang benar (accepted ≤ 50 m / rejected > 50 m).
- Status GPS tampil; tombol Absensi fixed dengan loading.
- `flutter analyze` bersih.

## Testing
- Widget test: dialog accepted menampilkan "Absensi Berhasil" + jarak; rejected
  menampilkan "Absensi Ditolak".
- Pastikan `bloc_test` AttendanceBloc tetap hijau.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-16-result.md`.
