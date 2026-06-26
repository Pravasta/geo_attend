# Result — Issue #12: Design System & Komponen UI Reusable

- **Branch**: `feat/issue-12-design-system-components`
- **Fase**: Implementasi Desain
- **Status**: ✅ Selesai
- **Tanggal**: 26 Juni 2026

## Ringkasan
Fondasi visual untuk implementasi mockup: komponen UI reusable di `core/widgets/`
yang selaras dengan token desain (warna, radius, shadow, tipografi Poppins). Issue
UI berikutnya (#13–#17) tinggal menyusun komponen ini.

## Yang Dikerjakan
Komponen di `lib/core/widgets/` (+ barrel `widgets.dart`):

| Komponen | Fungsi |
|----------|--------|
| `AppButton` | Tombol primary (gradien + shadow) & secondary (outline); state **disabled** & **loading**; opsi `expand`/ikon. |
| `AppIconButton` | Tombol ikon kotak (latar lembut primary). |
| `StatusBadge` | Badge pill accepted (hijau) / rejected (merah); opsi `compact`. |
| `AppCard` | Kartu putih radius + soft shadow; opsi `onTap`. |
| `InfoBanner` | Banner info latar `#EEF1FF`. |
| `EmptyStateView` | Ikon dalam kotak + judul + deskripsi + aksi opsional. |
| `ErrorStateView` | Ikon error + pesan + tombol "Coba Lagi". |
| `SkeletonBox` | Placeholder skeleton beranimasi (denyut opacity). |
| `SectionHeader` | Label section uppercase. |

Komponen mengambil tipografi Poppins (konsisten dengan `AppTheme`) dan token
warna dari `AppColors`.

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **71 tests passed** |

### Cakupan Test Baru
- `AppButton`: memanggil `onPressed` saat ditekan; **loading** menampilkan
  indikator & tidak memanggil `onPressed`; **disabled** aman ditekan.
- `StatusBadge`: accepted → "Diterima", rejected → "Ditolak".
- `EmptyStateView`: menampilkan judul/pesan & aksi (tap memanggil callback).

## Keputusan Teknis
- **`AppButton` memakai `Ink` + gradien** (bukan `FilledButton`) karena tombol
  primary desain berlatar gradien brand + shadow — sulit dicapai via
  `FilledButton.styleFrom`. Tetap menggunakan `InkWell` agar ada ripple.
- **`SkeletonBox` ringan** (denyut opacity via `AnimationController`) tanpa
  dependency shimmer eksternal.
- **Barrel file `widgets.dart`** agar import ringkas di layar (`import
  '../../../../core/widgets/widgets.dart';`).

## Acceptance Criteria — Terpenuhi
- [x] Komponen reusable tersedia & konsisten token desain.
- [x] `AppButton` mendukung primary/secondary/icon/disabled/loading.
- [x] `StatusBadge`, `EmptyStateView`, `ErrorStateView`, `SkeletonBox` siap pakai.
- [x] `flutter analyze` bersih.

## Langkah Selanjutnya
Lanjut ke **Issue #13 — Redesain Home Dashboard & Splash** (mulai memakai
komponen ini).
