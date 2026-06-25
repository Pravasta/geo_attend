# Daftar Issue — GeoAttend

Task pengembangan aplikasi GeoAttend dipecah menjadi beberapa issue kecil agar
mudah dikerjakan dan dilacak. Issue dikerjakan **berurutan** karena saling
bergantung (dependency). Setiap issue dikerjakan pada **branch terpisah** dan
ditutup dengan **PR ke `main`**.

| # | Judul | Branch | Bergantung pada | Status |
|---|-------|--------|-----------------|--------|
| [01](issue-01-setup-project.md) | Setup Project, Dependencies & Struktur Clean Architecture | `feat/issue-01-setup-project` | — | ✅ Done |
| [02](issue-02-database-drift.md) | Setup Database Drift (locations & attendances) | `feat/issue-02-database-drift` | #01 | ✅ Done |
| [03](issue-03-core-services.md) | Core Services: Permission, Location & Distance Util | `feat/issue-03-core-services` | #01 | ✅ Done |
| [04](issue-04-location-domain-data.md) | Fitur Lokasi — Domain & Data (CRUD + Geotagging) | `feat/issue-04-location-domain-data` | #02, #03 | ✅ Done |
| [05](issue-05-location-presentation.md) | Fitur Lokasi — Presentation (BLoC + UI) | `feat/issue-05-location-presentation` | #04 | ✅ Done |
| [06](issue-06-attendance-domain-data.md) | Fitur Absensi — Domain & Data (Verifikasi 50m) | `feat/issue-06-attendance-domain-data` | #02, #03, #04 | ✅ Done |
| [07](issue-07-attendance-presentation.md) | Fitur Absensi — Presentation (BLoC + UI + Dialog) | `feat/issue-07-attendance-presentation` | #06, #05 | ✅ Done |
| [08](issue-08-attendance-history.md) | Riwayat Absensi (List + Format Tanggal) | `feat/issue-08-attendance-history` | #06, #07 | ✅ Done |
| [10](issue-10-env-google-maps-key.md) | Konfigurasi Environment (.env) & Google Maps API Key | `feat/issue-10-env-google-maps-key` | #01 | ✅ Done |
| [11](issue-11-map-picker.md) | Map Picker: Pilih Lokasi via Google Maps | `feat/issue-11-map-picker` | #10, #05 | ⬜ Todo |
| [09](issue-09-polish-final.md) | Penyempurnaan UI/UX, Edge Cases & Dokumentasi Akhir | `feat/issue-09-polish-final` | semua (termasuk #10, #11) | ⬜ Todo |

> **Catatan urutan**: Issue **#10** dan **#11** (tambahan: Google Maps map picker)
> dikerjakan **setelah #08 dan sebelum #09**. Issue **#09** tetap menjadi tahap
> terakhir (finalisasi & dokumentasi akhir) agar mencakup seluruh fitur termasuk
> map picker.

## Legenda Status
- ⬜ Todo — belum dikerjakan
- 🟨 In Progress — sedang dikerjakan
- ✅ Done — selesai & ter-merge

## Alur Pengerjaan per Issue
1. Buat branch dari `main`.
2. Kerjakan sesuai langkah & scope issue.
3. Tulis & jalankan test, lakukan review.
4. Dokumentasikan hasil di `docs/result/`.
5. Jika ada kendala, catat di `docs/revision/`.
6. Commit deskriptif → push → buat PR ke `main`.
7. Update status di tabel ini setelah merge.
