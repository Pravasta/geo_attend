# Brainstorming — GeoAttend (Aplikasi Absensi Berbasis Lokasi)

> Dokumen ini berisi hasil brainstorming awal untuk pengembangan aplikasi
> **GeoAttend**, yaitu aplikasi mobile absensi sederhana berbasis Flutter yang
> memverifikasi kehadiran pengguna berdasarkan lokasi GPS dalam radius tertentu.

- **Tanggal**: 25 Juni 2026
- **Platform**: Flutter (Android & iOS)
- **Arsitektur**: Clean Architecture (presentation, domain, data)
- **State Management**: BLoC (`flutter_bloc`)
- **Database**: Drift (SQLite)

---

## 1. Latar Belakang & Tujuan

### 1.1 Latar Belakang
Banyak organisasi membutuhkan mekanisme absensi yang dapat memastikan bahwa
seseorang benar-benar berada di lokasi yang ditentukan (misalnya kantor, sekolah,
atau lokasi proyek) saat melakukan absensi. Pendekatan absensi manual rawan
manipulasi karena tidak ada verifikasi lokasi.

### 1.2 Tujuan
Membangun aplikasi mobile sederhana yang:
1. Memungkinkan admin/pengguna **mendaftarkan lokasi (master data)** beserta
   titik koordinat GPS (geotagging).
2. Memungkinkan pengguna **melakukan absensi** yang hanya akan diterima jika
   pengguna berada dalam **radius maksimal 50 meter** dari titik lokasi.
3. Menyimpan seluruh data lokasi dan riwayat absensi secara **lokal** dan aman.

### 1.3 Definisi Sukses (Success Criteria)
- Lokasi dapat ditambahkan dengan koordinat akurat melalui geotagging.
- Absensi **diterima** jika jarak ≤ 50 m, dan **ditolak** jika > 50 m.
- Riwayat absensi tersimpan dan dapat dilihat kembali.
- Aplikasi mengikuti Clean Architecture + BLoC dan dapat diuji (testable).

---

## 2. Ruang Lingkup (Scope)

### 2.1 In Scope (Termasuk)
- Manajemen lokasi: tambah, lihat daftar, edit, hapus.
- Geotagging untuk mengambil koordinat GPS saat menambah/edit lokasi.
- Absensi dengan verifikasi radius 50 meter.
- Penyimpanan data lokal (Drift/SQLite).
- Riwayat absensi (diterima & ditolak).
- Penanganan izin lokasi & status GPS.

### 2.2 Out of Scope (Tidak Termasuk untuk versi awal)
- Autentikasi multi-user / login akun.
- Sinkronisasi ke server / backend cloud.
- Manajemen role (admin vs karyawan) secara penuh.
- Peta interaktif (map picker) — opsional, dapat ditambahkan kemudian.
- Notifikasi push & laporan/eksport data.

---

## 3. Fitur Utama

### 3.1 Manajemen Lokasi (Master Data)
- Menambahkan lokasi baru dengan input **nama lokasi** dan **geotagging**
  (mengambil koordinat GPS perangkat saat itu).
- Opsional: mengambil **alamat** dari koordinat menggunakan reverse geocoding
  (`geocoding`) untuk mempermudah identifikasi lokasi.
- Menyimpan lokasi ke database lokal.
- Menampilkan **daftar lokasi** (ListView) yang telah ditambahkan.
- **Edit** dan **hapus** lokasi.
- (Opsional) menetapkan **radius** per lokasi; default 50 meter.

### 3.2 Fitur Absensi
- Tombol **"Absensi"** pada halaman utama.
- Aplikasi meminta **izin lokasi** dan memastikan **GPS aktif**.
- Mengambil koordinat GPS pengguna saat ini.
- Menghitung jarak antara posisi pengguna dengan titik lokasi terpilih
  menggunakan formula **Haversine** (disediakan oleh `geolocator.distanceBetween`).
- **Aturan verifikasi:**
  - Jarak **≤ 50 meter** → absensi **DITERIMA (accepted)** dan dicatat.
  - Jarak **> 50 meter** → absensi **DITOLAK (rejected)**, pengguna diberi
    notifikasi alasan penolakan (di luar radius).
- Memberi umpan balik melalui dialog / toast (`fluttertoast`).

### 3.3 Riwayat Absensi
- Menampilkan daftar absensi sebelumnya: lokasi, waktu, status (accepted/rejected),
  jarak terhitung saat absensi.
- Format tanggal & waktu menggunakan `intl`.
- (Opsional) filter berdasarkan tanggal atau lokasi.

---

## 4. Arsitektur & Struktur Folder

Menggunakan **Clean Architecture** dengan 3 lapisan utama dan dipisahkan
per-fitur (feature-first):

```
lib/
├── core/
│   ├── constants/         # konstanta global (mis. DEFAULT_RADIUS = 50)
│   ├── error/             # Failure & Exception
│   ├── usecases/          # base UseCase
│   ├── services/          # LocationService, PermissionService, dll.
│   └── utils/             # helper (distance, date formatter)
├── features/
│   ├── location/
│   │   ├── data/          # datasource (Drift), model, repository impl
│   │   ├── domain/        # entity, repository abstract, usecases
│   │   └── presentation/  # bloc, pages, widgets
│   └── attendance/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection_container.dart   # dependency injection (get_it)
└── main.dart
```

### Alur Dependency
`Presentation (BLoC)` → `Domain (UseCase + Repository abstract)` → `Data (Repository impl + DataSource/Drift)`

Lapisan dalam (domain) **tidak boleh** bergantung pada lapisan luar.
Dependency Injection mengelola pembuatan objek antar lapisan.

---

## 5. Desain Database (Drift / SQLite)

### Tabel `locations`
| Kolom        | Tipe     | Keterangan                          |
|--------------|----------|-------------------------------------|
| id           | INTEGER  | Primary key, auto-increment         |
| name         | TEXT     | Nama lokasi                         |
| latitude     | REAL     | Koordinat lintang                   |
| longitude    | REAL     | Koordinat bujur                     |
| address      | TEXT?    | Alamat hasil reverse geocoding (opsional) |
| radius       | REAL     | Radius (meter), default 50          |
| created_at   | DATETIME | Waktu pembuatan                     |

### Tabel `attendances`
| Kolom        | Tipe     | Keterangan                                  |
|--------------|----------|---------------------------------------------|
| id           | INTEGER  | Primary key, auto-increment                 |
| location_id  | INTEGER  | Foreign key → locations.id                  |
| latitude     | REAL     | Koordinat pengguna saat absen               |
| longitude    | REAL     | Koordinat pengguna saat absen               |
| distance     | REAL     | Jarak terhitung (meter) ke titik lokasi     |
| status       | TEXT     | 'accepted' / 'rejected'                      |
| timestamp    | DATETIME | Waktu absensi                               |

> Catatan: menyimpan koordinat & jarak pada saat absen memudahkan audit dan
> debugging, sekaligus menjadi bukti verifikasi.

---

## 6. State Management (BLoC)

### LocationBloc
- **Events**: `LoadLocations`, `AddLocation`, `UpdateLocation`, `DeleteLocation`,
  `CaptureCurrentCoordinate` (geotagging).
- **States**: `LocationInitial`, `LocationLoading`, `LocationLoaded(list)`,
  `LocationError(message)`, `CoordinateCaptured(lat,lng,address)`.

### AttendanceBloc
- **Events**: `LoadAttendanceHistory`, `SubmitAttendance(locationId)`.
- **States**: `AttendanceInitial`, `AttendanceLoading`,
  `AttendanceAccepted(record)`, `AttendanceRejected(distance)`,
  `AttendanceHistoryLoaded(list)`, `AttendanceError(message)`.

Menggunakan `equatable` agar perbandingan state efisien dan mudah diuji.

---

## 7. Penanganan Izin, GPS & Edge Cases

Hal-hal penting yang harus ditangani agar aplikasi andal:
1. **Izin lokasi ditolak** → tampilkan penjelasan & arahkan ke pengaturan
   (`permission_handler`).
2. **Izin "deny forever"** → beri tahu pengguna cara mengaktifkan manual.
3. **GPS / layanan lokasi mati** → minta pengguna mengaktifkan.
4. **Akurasi GPS rendah** → pertimbangkan menampilkan akurasi (accuracy) dan
   mungkin menolak jika akurasi terlalu buruk (mis. > 50 m), agar verifikasi adil.
5. **Lokasi belum ada** → cegah absensi sebelum minimal satu lokasi terdaftar.
6. **Mock location / fake GPS** → (lanjutan) deteksi `isMocked` jika diperlukan
   untuk mencegah kecurangan absensi.
7. **Konektivitas** → reverse geocoding butuh internet; gunakan
   `connectivity_plus` untuk memberi tahu jika fitur alamat tidak tersedia
   offline (absensi & jarak tetap berfungsi offline karena murni GPS + lokal).

---

## 8. UI/UX

- **Halaman Utama**: ringkasan + tombol cepat (Absensi, Kelola Lokasi, Riwayat).
- **Halaman Lokasi**: daftar lokasi (ListView), FAB tambah lokasi.
- **Form Lokasi**: input nama + tombol "Ambil Koordinat" (geotagging) +
  pratinjau lat/lng/alamat.
- **Halaman Absensi**: pilih lokasi → tombol Absensi → dialog hasil
  (diterima/ditolak + jarak).
- **Halaman Riwayat**: daftar absensi dengan badge status berwarna
  (hijau = accepted, merah = rejected).
- Umpan balik singkat dengan **toast** dan dialog konfirmasi.
- Desain sederhana, intuitif, dengan loading & empty state yang jelas.

---

## 9. Keamanan & Privasi

- Meminta izin lokasi dengan **penjelasan jelas** mengapa dibutuhkan.
- Data lokasi & absensi disimpan **lokal** di perangkat, tidak dibagikan.
- Tidak mengirim data ke pihak ketiga.
- Reverse geocoding hanya mengirim koordinat ke layanan geocoding bawaan
  platform (informasikan ke pengguna bila relevan).

---

## 10. Strategi Testing

- **Unit test** untuk usecases & util (terutama perhitungan jarak & aturan 50 m).
- **Bloc test** (`bloc_test`) untuk LocationBloc & AttendanceBloc.
- **Test repository** dengan mock datasource.
- Skenario absensi yang diuji:
  - Tepat di titik (0 m) → accepted.
  - Tepat di batas (≈50 m) → accepted.
  - Di luar batas (>50 m) → rejected.
  - Izin ditolak / GPS mati → error yang tepat.
- Pengujian manual di beberapa perangkat untuk akurasi GPS.

---

## 11. Daftar Package

### Wajib (sesuai task)
| Package             | Kegunaan                                                   |
|---------------------|------------------------------------------------------------|
| `geolocator`        | Mendapatkan koordinat GPS & menghitung jarak antar titik.  |
| `geocoding`         | Reverse geocoding: alamat dari koordinat.                  |
| `drift`             | ORM database lokal (SQLite).                               |
| `flutter_bloc`      | State management pola BLoC.                                |
| `permission_handler`| Meminta & memeriksa izin lokasi.                          |
| `fluttertoast`      | Notifikasi singkat (toast).                                |
| `intl`              | Format tanggal & waktu.                                    |
| `equatable`         | Perbandingan objek/state.                                  |
| `connectivity_plus` | Cek status koneksi internet (untuk geocoding).            |

### Tambahan yang Direkomendasikan (beserta alasan)
| Package                 | Kegunaan & Alasan                                           |
|-------------------------|-------------------------------------------------------------|
| `get_it`                | Dependency Injection — wajib untuk Clean Architecture.      |
| `dartz`                 | Tipe `Either<Failure, Success>` untuk error handling rapi.  |
| `sqlite3_flutter_libs`  | Runtime SQLite native untuk Flutter (dibutuhkan Drift).     |
| `path_provider` & `path`| Menentukan lokasi file database di perangkat.              |
| `bloc_test` (dev)       | Pengujian BLoC.                                             |
| `mocktail` (dev)        | Mocking dependency untuk unit test.                        |
| `build_runner` (dev)    | Code generation untuk Drift.                               |
| `drift_dev` (dev)       | Generator kode Drift.                                       |
| `flutter_lints` (dev)   | Menjaga kualitas & konsistensi kode.                       |

> Catatan: `google_maps_flutter` dapat dipertimbangkan bila ingin menampilkan
> peta / map picker, namun di luar scope versi awal.

---

## 12. Ide Tambahan (Pengembangan Lanjutan)

1. **Radius dinamis per lokasi** — tiap lokasi punya radius sendiri (default 50 m).
2. **Map picker** — pilih titik lokasi via peta, bukan hanya GPS saat ini.
3. **Deteksi mock location** untuk mencegah kecurangan absensi.
4. **Filter & pencarian** pada daftar lokasi dan riwayat.
5. **Eksport riwayat** ke CSV/PDF.
6. **Jenis absensi** (check-in / check-out) dengan ringkasan jam kerja.
7. **Tema gelap (dark mode)** dan dukungan multi-bahasa.
8. **Sinkronisasi cloud** & multi-user (versi lanjutan).

---

## 13. Rencana Pemecahan Issue (Roadmap Awal)

Task akan dipecah menjadi issue-issue kecil di `docs/issues/`. Urutan yang
diusulkan:

1. **Issue #1** — Setup project, dependencies, struktur Clean Architecture & DI.
2. **Issue #2** — Setup database Drift (tabel locations & attendances).
3. **Issue #3** — Core services: permission, location, distance util.
4. **Issue #4** — Fitur Manajemen Lokasi (CRUD + geotagging) — domain & data.
5. **Issue #5** — Fitur Manajemen Lokasi — presentation (BLoC + UI).
6. **Issue #6** — Fitur Absensi (verifikasi radius 50 m) — domain & data.
7. **Issue #7** — Fitur Absensi — presentation (BLoC + UI + dialog hasil).
8. **Issue #8** — Riwayat Absensi (list + format tanggal).
9. **Issue #9** — Penyempurnaan UI/UX, edge cases, & dokumentasi akhir.

Setiap issue dikerjakan pada **branch terpisah**, ditutup dengan **PR ke main**,
didokumentasikan pada `docs/result/`, dan bila ada kendala dibuat catatan di
`docs/revision/`. Dokumentasi akhir disusun di `docs/final/`.

---

_Dokumen ini adalah living document dan dapat diperbarui seiring berjalannya
pengembangan._
