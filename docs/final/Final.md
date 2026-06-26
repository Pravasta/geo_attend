# Dokumentasi Akhir — GeoAttend

> Aplikasi absensi berbasis lokasi (GPS) dengan verifikasi radius 50 meter,
> dibangun menggunakan Flutter, Clean Architecture, BLoC, dan Drift.

- **Repository**: https://github.com/Pravasta/geo_attend
- **Tanggal**: 26 Juni 2026
- **Status**: Selesai (17 issue — 2 fase)

---

## 1. Ringkasan Proses

Pengembangan dilakukan secara terstruktur dan terdokumentasi dalam **2 fase**:

**Fase 1 — Fungsionalitas (Issue #01–#11)**
1. **Brainstorming** (`docs/brainstorming/`) — analisis kebutuhan, scope,
   arsitektur, skema data, dan rencana.
2. **Pemecahan Issue** (`docs/issues/`) — task dipecah menjadi issue kecil.
3. **Eksekusi per issue** — tiap issue dikerjakan di branch terpisah, diuji,
   didokumentasikan di `docs/result/`, lalu di-merge ke `main` via Pull Request.
4. **Revisi** (`docs/revision/`) — perubahan desain dicatat saat diperlukan.

**Fase 2 — Implementasi Desain (Issue #12–#17)**
Berdasarkan mockup dari Claude (Design) di `docs/design/`, seluruh tampilan
diimplementasikan ulang agar presisi dengan desain: design system + komponen
reusable, lalu redesain Home, Lokasi, Form/Map Picker, Absensi/Dialog, dan
Riwayat (dengan filter).

Total: **17 Pull Request**, seluruh test hijau (**78 test**), `flutter analyze`
bersih.

---

## 2. Fitur Aplikasi

### Manajemen Lokasi (Master Data)
- Tambah, lihat, edit, hapus lokasi.
- **Geotagging** koordinat via GPS (`geolocator`).
- **Map Picker** Google Maps — pilih/sesuaikan pin lokasi secara akurat.
- Reverse geocoding untuk alamat (opsional, butuh koneksi).

### Absensi (Verifikasi Radius 50 m)
- Pilih lokasi → ambil posisi GPS → hitung jarak (Haversine).
- **Diterima** bila jarak ≤ 50 m, **Ditolak** bila > 50 m.
- Dialog hasil (hijau/merah) beserta info jarak.
- Catatan tersimpan (diterima maupun ditolak) sebagai bukti.

### Riwayat Absensi
- Daftar absensi dengan waktu terformat (Indonesia), badge status berwarna, jarak.
- **Filter** Semua / Diterima / Ditolak (client-side).
- Pull-to-refresh; urutan terbaru lebih dulu.

### UI/UX (mengikuti mockup desain)
- **Design system terpusat** + komponen reusable (`AppButton`, `AppCard`,
  `StatusBadge`, `EmptyStateView`, `ErrorStateView`, `SkeletonBox`, dll.).
- Splash screen (native + animasi pulse dalam aplikasi).
- **HomePage dashboard**: header sapaan dinamis + kartu ringkasan (lokasi,
  absensi, terakhir) + kartu aksi + menu.
- **Skeleton loading**, empty & error state konsisten di seluruh halaman.
- Dialog hasil absensi beranimasi; kartu detail + status GPS pada halaman absensi.
- Font **Poppins** (`google_fonts`), tema Material 3, warna brand indigo + teal.

---

## 3. Arsitektur

**Clean Architecture** (feature-first) dengan 3 lapisan:

```
Presentation (BLoC + UI)  ->  Domain (UseCase + Entity + Repository abstrak)  ->  Data (Repository impl + DataSource/Drift + Service)
```

```
lib/
├── core/
│   ├── config/        # EnvConfig (.env)
│   ├── constants/     # AppConstants (radius 50m, dll.)
│   ├── database/      # Drift: AppDatabase, tables
│   ├── error/         # Failure & Exception
│   ├── services/      # Permission, Location, Geocoding, Connectivity
│   ├── theme/         # AppTheme, AppColors
│   ├── usecases/      # UseCase base
│   ├── utils/         # DistanceCalculator, DateFormatter
│   └── widgets/       # Komponen UI reusable (design system)
├── features/
│   ├── home/          # Splash, HomePage, HomeCubit (ringkasan)
│   ├── location/      # data / domain / presentation
│   └── attendance/    # data / domain / presentation
├── injection_container.dart   # Dependency Injection (get_it)
└── main.dart
```

- **State Management**: BLoC (`flutter_bloc`) — bloc per fitur, factory per halaman.
- **Dependency Injection**: `get_it`.
- **Error handling**: `Either<Failure, T>` (`dartz`).

---

## 4. Tech Stack & Package

| Kategori | Package |
|----------|---------|
| Lokasi & Jarak | `geolocator`, `geocoding`, `google_maps_flutter` |
| Database | `drift`, `sqlite3_flutter_libs`, `path_provider`, `path` |
| State Management | `flutter_bloc`, `equatable` |
| DI & Functional | `get_it`, `dartz` |
| Izin & Koneksi | `permission_handler`, `connectivity_plus` |
| UI | `google_fonts`, `fluttertoast`, `flutter_native_splash` |
| Konfigurasi | `flutter_dotenv`, `intl` |
| Testing (dev) | `bloc_test`, `mocktail`, `build_runner`, `drift_dev` |

---

## 5. Skema Database (Drift)

- **locations**: id, name, latitude, longitude, address?, radius (default 50),
  created_at.
- **attendances**: id, location_id (FK nullable, `setNull`), location_name
  (snapshot), latitude, longitude, distance, status, timestamp.

> Riwayat absensi **dipertahankan** meski lokasi master dihapus (lihat
> `docs/revision/issue-02-revision-01.md`).

---

## 6. Cara Menjalankan

```bash
# 1. Dependencies
fvm flutter pub get

# 2. (Opsional) Konfigurasi Google Maps
cp .env.example .env          # lalu isi MAPS_API_KEY

# 3. Code generation (jika perlu)
fvm dart run build_runner build

# 4. Jalankan
fvm flutter run
```

Lingkungan: Flutter **3.44.3** (FVM, dipin di `.fvmrc`), Dart 3.12.x.

### Konfigurasi Google Maps (opsional)
- Isi `MAPS_API_KEY` pada `.env` (di-`.gitignore`; template di `.env.example`).
- Aktifkan **Maps SDK for Android/iOS** di Google Cloud Console.
- iOS membutuhkan `platform :ios, '14.0'` pada `ios/Podfile`.
- Tanpa key, aplikasi tetap berjalan; map picker menampilkan pesan informatif.

---

## 7. Pengujian

```bash
fvm flutter test
```

- **78 test** lulus, `flutter analyze` bersih.
- Cakupan: util (distance 50 m, date formatter), database (CRUD in-memory),
  services (permission/location/connectivity), repository (lokasi & absensi),
  BLoC/Cubit (location, attendance, history+filter, home), komponen design
  system (button/badge/empty state), widget (home, splash, map picker, form,
  list, dialog hasil).

> Render peta Google Maps & perilaku GPS nyata diverifikasi secara **manual** di
> perangkat fisik (tidak dapat diuji penuh via unit/widget test).

---

## 8. Keterbatasan & Pengembangan Lanjutan

**Keterbatasan saat ini**
- Single-user, tanpa autentikasi/akun.
- Penyimpanan lokal (tanpa sinkronisasi cloud).
- Map picker perlu API key & uji manual untuk render peta.

**Ide pengembangan lanjutan**
- Deteksi mock location (anti-kecurangan).
- Check-in/check-out & rekap jam kerja.
- Filter/pencarian & eksport riwayat (CSV/PDF).
- Lingkaran radius (geofence) di peta.
- Multi-user + sinkronisasi cloud, dark mode.

---

## 9. Referensi Dokumentasi

| Folder | Isi |
|--------|-----|
| `docs/brainstorming/` | Brainstorming awal |
| `docs/issues/` | 17 issue + index (2 fase) |
| `docs/result/` | Hasil tiap issue (#01–#17) |
| `docs/revision/` | Catatan revisi |
| `docs/design/` | Brief desain & mockup (Claude Design) |
| `docs/final/` | Dokumentasi akhir (file ini) |

---

_GeoAttend — dikembangkan dengan Flutter, Clean Architecture, dan disiplin
dokumentasi per issue._
