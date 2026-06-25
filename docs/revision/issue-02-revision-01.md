# Revision — Issue #02 (Rev-01): Pertahankan Riwayat Absensi saat Lokasi Dihapus

- **Terkait Issue**: #02 — Setup Database Drift
- **Branch**: `feat/issue-02-database-drift`
- **Tanggal**: 25 Juni 2026

## Deskripsi Masalah
Desain awal tabel `Attendances` memakai foreign key `onDelete: KeyAction.cascade`.
Akibatnya, ketika sebuah lokasi master dihapus, **seluruh riwayat absensi yang
terkait ikut terhapus**. Untuk aplikasi absensi, data kehadiran bersifat penting
dan tidak boleh hilang hanya karena lokasi master dihapus/diubah oleh admin.

Keputusan ditinjau ulang atas preferensi: riwayat absensi sebaiknya **tetap
disimpan**.

## Langkah-langkah Perbaikan
1. Ubah kolom `locationId` pada tabel `Attendances`:
   - Dari: `integer().references(Locations, #id, onDelete: KeyAction.cascade)`
   - Menjadi: `integer().nullable().references(Locations, #id, onDelete: KeyAction.setNull)`
2. Tambah kolom snapshot `locationName` (`text`, wajib) untuk menjaga konteks
   riwayat meski lokasi master sudah tidak ada.
3. Regenerasi kode Drift (`build_runner`).
4. Perbarui unit test:
   - Sertakan `locationName` saat insert absensi.
   - Ganti test "cascade hapus absensi" menjadi test "riwayat tetap tersimpan,
     `locationId` di-set null, `locationName` bertahan".
5. Perbarui dokumentasi `docs/result/issue-02-result.md`.

## Harapan Perbaikan
- Menghapus lokasi master **tidak** menghapus riwayat absensi.
- Setelah lokasi dihapus, baris absensi memiliki `locationId = null` namun tetap
  menampilkan nama lokasi melalui `locationName`.
- Integritas data terjaga tanpa baris yatim yang melanggar foreign key.

## Status
✅ Selesai diterapkan — `flutter analyze` bersih, seluruh test (4) lulus.
