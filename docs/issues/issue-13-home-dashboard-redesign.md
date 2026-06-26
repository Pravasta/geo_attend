# Issue #13 — Redesain Home Dashboard & Splash

- **Branch**: `feat/issue-13-home-dashboard-redesign`
- **Fase**: Implementasi Desain
- **Bergantung pada**: #12
- **Referensi desain**: `docs/design/results/GeoAttend Mockups.dc.html` — Section B
- **Status**: ⬜ Todo

## Deskripsi
Menerapkan desain Home dashboard (lebih kaya dari versi saat ini) dan
menyempurnakan Splash agar presisi dengan mockup.

## Scope
**In Scope**
- **Splash**: sesuaikan dengan mockup (logo dalam kotak putih + animasi pulse di
  belakang, nama app, tagline, loading di bawah) — perbaiki bila ada selisih.
- **Home** (mengacu Variasi 2 / kombinasi terbaik):
  - Header gradien: sapaan kontekstual ("Selamat pagi/siang/sore 👋") + nama app.
  - **Kartu ringkasan** (stats): jumlah **Lokasi**, jumlah **Absensi**, **waktu
    absensi terakhir**.
  - **Kartu aksi utama** "Absensi Sekarang" (gradien) → halaman Absensi.
  - **Menu** Lokasi & Riwayat (list dengan ikon + chevron, atau kartu).
  - **Info banner** pengingat GPS aktif.
- Sumber data ringkasan: **reuse usecase yang ada** (`GetLocations` untuk jumlah
  lokasi; `GetAttendanceHistory` untuk jumlah & absensi terakhir). Boleh dibuat
  `HomeBloc`/`HomeCubit` ringan yang memanggil keduanya.

**Out of Scope**
- Perubahan data layer/skema (cukup pakai usecase eksisting).

## Langkah-langkah
1. Sesuaikan `SplashPage` dengan detail mockup (animasi pulse, spacing, ukuran).
2. Buat `HomeCubit`/`HomeBloc` yang memuat ringkasan (jumlah lokasi, jumlah
   absensi, absensi terakhir) via usecase eksisting.
3. Bangun ulang `HomePage`: header + kartu ringkasan + kartu aksi + menu + banner,
   memakai komponen dari #12.
4. Sapaan dinamis berdasarkan jam (pagi/siang/sore/malam).
5. Tangani state loading/empty untuk ringkasan (mis. "—" bila belum ada data).

## Acceptance Criteria
- Home menampilkan ringkasan (lokasi, absensi, terakhir) dari data nyata.
- Navigasi ke Absensi, Lokasi, Riwayat berfungsi.
- Sapaan menyesuaikan waktu.
- Tampilan presisi dengan mockup; `flutter analyze` bersih.

## Testing
- `bloc_test`/cubit test ringkasan home (loaded dengan data, kosong).
- Widget test: Home menampilkan kartu aksi & menu.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-13-result.md`.
