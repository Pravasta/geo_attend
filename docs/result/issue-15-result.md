# Result — Issue #15: Redesain Form Lokasi & Map Picker

- **Branch**: `feat/issue-15-form-mappicker-redesign`
- **Fase**: Implementasi Desain
- **Status**: ✅ Selesai
- **Tanggal**: 26 Juni 2026

## Ringkasan
Form Tambah/Edit Lokasi dan Map Picker dirombak sesuai mockup (Section D),
termasuk state "API key belum dikonfigurasi" yang lebih ramah dengan opsi
"Gunakan GPS Saja".

## Yang Dikerjakan

### Form Lokasi
- Input **nama** dengan label + tanda wajib `*`, ikon, gaya tema (fokus ring).
- **Kartu "Koordinat Terpilih"** (`AppCard`): Latitude, Longitude, Alamat.
- Grup **"Ambil Titik Lokasi"**: tombol **Ambil Koordinat (GPS)** (`AppButton`
  primary) & **Pilih di Peta** (`AppButton.secondary`).
- Tombol **Simpan Lokasi** dipindah ke **bar bawah (fixed)**, dengan state loading.

### Map Picker
- Tata letak peta penuh dengan **kontrol mengambang**: tombol back & ganti tipe
  peta (atas), tombol **"ke lokasi saya"**, kontrol zoom native.
- **Bottom sheet card** (drag handle): koordinat (6 desimal) + **alamat reaktif**
  (reverse geocoding saat pin berubah, latest-wins) + tombol **Gunakan Lokasi Ini**.
- Marker dapat digeser & tap memindah pin.

### Map Picker tanpa API key
- Ikon `key`, judul **"Peta belum tersedia"**, penjelasan, dan tombol
  **"Gunakan GPS Saja"** (kembali ke form untuk memakai GPS).

## Verifikasi
| Cek | Hasil |
|-----|-------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ **74 tests passed** |

### Cakupan Test
- Widget test form: menampilkan tombol GPS, Peta, & Simpan.
- Widget test map picker tanpa key: "Peta belum tersedia" + "Gunakan GPS Saja".

## Keputusan Teknis
- **Alamat reaktif di map picker** — reverse geocoding dipicu saat pin berubah
  dengan token "latest-wins" agar hasil lama tidak menimpa yang baru. Alamat
  yang sudah teresolusi langsung dikirim saat konfirmasi (tanpa fetch ulang).
- **Tombol Simpan fixed** di bawah (`_BottomBar`) agar konsisten dengan mockup &
  selalu terjangkau.
- **State no-API-key membawa callback `onUseGps`** yang menutup map picker
  sehingga pengguna kembali ke form dan tetap bisa memakai GPS.
- Memakai komponen `AppButton`/`AppCard` (#12) untuk konsistensi.

## Acceptance Criteria — Terpenuhi
- [x] Form & map picker tampil sesuai mockup.
- [x] State tanpa API key informatif + tombol "Gunakan GPS Saja" berfungsi.
- [x] Alur isi koordinat (GPS & peta) tetap berjalan tanpa regresi.
- [x] `flutter analyze` bersih.

## Langkah Selanjutnya
Lanjut ke **Issue #16 — Redesain Absensi & Dialog Hasil**.
