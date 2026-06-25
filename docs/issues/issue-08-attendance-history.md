# Issue #08 — Riwayat Absensi (List + Format Tanggal)

- **Branch**: `feat/issue-08-attendance-history`
- **Bergantung pada**: #06, #07
- **Status**: ⬜ Todo

## Deskripsi
Menampilkan riwayat absensi pengguna: daftar catatan absensi (diterima & ditolak)
lengkap dengan nama lokasi, waktu (terformat `intl`), status berwarna, dan jarak.

## Scope
**In Scope**
- Event/State riwayat pada `AttendanceBloc` (atau bloc terpisah `HistoryBloc`).
- Halaman `AttendanceHistoryPage` (ListView).
- Item riwayat: lokasi, tanggal/waktu (`intl`), badge status, jarak.
- Empty state bila belum ada riwayat.

**Out of Scope**
- Filter lanjutan / eksport (opsional, issue #09 atau pengembangan lanjutan).

## Langkah-langkah
1. Tambah event `LoadAttendanceHistory` & state `AttendanceHistoryLoaded(list)`.
2. Implementasikan pemanggilan usecase `GetAttendanceHistory`.
3. UI `AttendanceHistoryPage`:
   - ListView item dengan nama lokasi, waktu (`DateFormat`), badge status
     (hijau accepted / merah rejected), jarak.
   - Loading & empty state.
4. Tautkan navigasi dari halaman utama/absensi.

## Acceptance Criteria
- Riwayat tampil terurut (terbaru di atas).
- Tanggal & waktu terformat rapi (`intl`).
- Status accepted/rejected dibedakan secara visual.
- Empty state tampil bila belum ada data.

## Testing
- `bloc_test` untuk load history (loaded & empty).
- Uji manual: lakukan beberapa absensi lalu cek tampilan riwayat.

## Definition of Done
- Semua acceptance criteria terpenuhi.
- Branch ter-merge ke `main` via PR.
- Dokumentasi hasil di `docs/result/issue-08-result.md`.
