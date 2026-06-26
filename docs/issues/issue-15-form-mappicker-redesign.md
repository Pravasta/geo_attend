# Issue #15 — Redesain Form Lokasi & Map Picker

- **Branch**: `feat/issue-15-form-mappicker-redesign`
- **Fase**: Implementasi Desain
- **Bergantung pada**: #12, #14
- **Referensi desain**: `docs/design/results/GeoAttend Mockups.dc.html` — Section D
- **Status**: ⬜ Todo

## Deskripsi
Menerapkan desain Form Tambah/Edit Lokasi dan Map Picker (termasuk state "API
key belum dikonfigurasi" yang lebih ramah).

## Scope
**In Scope**
- **Form Lokasi**:
  - Input nama (label + tanda wajib `*`, ikon, fokus dengan ring).
  - **Kartu "Koordinat Terpilih"** (latitude, longitude, alamat).
  - Grup tombol "Ambil Titik Lokasi": **Ambil Koordinat (GPS)** (gradien) &
    **Pilih di Peta** (outline).
  - Tombol **Simpan Lokasi** tetap (fixed) di bawah dengan gradient fade.
- **Map Picker**:
  - Tombol back & kontrol zoom mengambang, FAB **my location**.
  - Pin di tengah/marker; **bottom sheet card** (drag handle) berisi koordinat +
    alamat + tombol **Gunakan Lokasi Ini**.
- **Map Picker tanpa API key**:
  - Ikon `key`, judul "Peta belum tersedia", penjelasan, info box, tombol
    **Gunakan GPS Saja** (kembali ke form & picu GPS).

**Out of Scope**
- Logika geocoding/lokasi (sudah ada); hanya tampilan & alur.

## Langkah-langkah
1. Bangun ulang `LocationFormPage` sesuai mockup (kartu koordinat, grup tombol,
   tombol simpan fixed) memakai komponen #12.
2. Bangun ulang `MapPickerPage`: kontrol mengambang + bottom sheet card.
3. Perbaiki state no-API-key memakai `EmptyStateView`/layout khusus + tombol
   "Gunakan GPS Saja".
4. Pertahankan integrasi: hasil map picker & GPS mengisi koordinat/alamat form.

## Acceptance Criteria
- Form & map picker tampil sesuai mockup.
- State tanpa API key informatif + tombol "Gunakan GPS Saja" berfungsi.
- Alur isi koordinat (GPS & peta) tetap berjalan tanpa regresi.
- `flutter analyze` bersih.

## Testing
- Widget test: form menampilkan tombol GPS & Peta; map picker tanpa key
  menampilkan pesan & tombol GPS.
- Pastikan test map picker yang ada tetap hijau.

## Definition of Done
- Acceptance criteria terpenuhi, branch ter-merge via PR.
- Dokumentasi hasil di `docs/result/issue-15-result.md`.
