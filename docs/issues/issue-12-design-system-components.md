# Issue #12 — Design System & Komponen UI Reusable

- **Branch**: `feat/issue-12-design-system-components`
- **Fase**: Implementasi Desain
- **Bergantung pada**: #09
- **Referensi desain**: `docs/design/results/GeoAttend Mockups.dc.html` — Section A
- **Status**: ⬜ Todo

## Deskripsi
Menyiapkan fondasi visual sesuai mockup: menyelaraskan tema dengan token desain
dan membuat **komponen UI reusable** yang dipakai lintas layar. Ini dikerjakan
**pertama** agar issue UI berikutnya tinggal menyusun komponen.

## Scope
**In Scope**
- Selaraskan `AppTheme`/`AppColors` dengan token desain (warna, radius, shadow,
  tipografi Poppins: Display 28/700, Headline 22/600, Title/Button 16/600,
  Body 14/400, Caption 12/500).
- Buat widget reusable di `core/widgets/` (atau `core/theme/widgets/`):
  - `AppButton` — varian: primary (gradien), secondary (outline), icon-only,
    state disabled & loading.
  - `StatusBadge` — varian accepted (hijau) & rejected (merah), pill.
  - `AppCard` — kartu putih, radius 16, soft shadow.
  - `InfoBanner` — banner info latar `#EEF1FF`.
  - `EmptyStateView` — ikon dalam kotak, judul, deskripsi, tombol aksi opsional.
  - `ErrorStateView` — ikon error, pesan, tombol "Coba Lagi".
  - `SkeletonBox` / `SkeletonLoader` — placeholder shimmer/abu-abu.
  - `SectionHeader` (opsional) — label uppercase.
- Dokumentasikan ringkas pemakaian komponen.

**Out of Scope**
- Penerapan ke layar spesifik (dilakukan di #13–#17).

## Langkah-langkah
1. Perbarui `core/theme/app_theme.dart` & `app_colors.dart` agar presisi dengan
   token desain (mis. gradien tombol primary, shadow tombol, radius konsisten).
2. Buat folder `core/widgets/` dan implementasikan komponen di atas.
3. Pastikan komponen memakai `google_fonts` Poppins via tema (bukan hardcode).
4. Buat contoh/penggunaan minimal & widget test dasar untuk komponen kunci.

## Acceptance Criteria
- Komponen reusable tersedia & konsisten dengan token desain.
- `AppButton` mendukung primary/secondary/icon/disabled/loading.
- `StatusBadge`, `EmptyStateView`, `ErrorStateView`, `SkeletonBox` siap pakai.
- `flutter analyze` bersih.

## Testing
- Widget test: `AppButton` (loading menampilkan indikator; disabled tidak
  memanggil onPressed), `StatusBadge` (teks Diterima/Ditolak), `EmptyStateView`.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-12-result.md`.
