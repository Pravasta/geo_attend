# Brainstorming Design — GeoAttend

> **Tujuan dokumen**: brief lengkap untuk diberikan kepada **Claude (Design)**
> agar membuat desain UI GeoAttend yang modern, rapi, dan konsisten — untuk
> kemudian **diimplementasikan ke Flutter**. Letakkan hasil desain pada folder
> `docs/design/results/`.

---

## 1. Tentang Aplikasi

**GeoAttend** adalah aplikasi mobile **absensi berbasis lokasi (GPS)**. Pengguna
mendaftarkan lokasi (geotagging / pilih di peta), lalu melakukan absensi yang
**diverifikasi** berada dalam **radius maksimal 50 meter** dari titik lokasi.
Jika di luar radius, absensi **ditolak**.

- **Platform**: Flutter (Android & iOS), Material 3, **mobile portrait**.
- **Bahasa UI**: Indonesia.
- **Sifat**: single-user, data lokal (offline-first), tanpa login.

---

## 2. Pengguna & Nada Desain

- **Pengguna**: karyawan / anggota organisasi (umum, non-teknis).
- **Nada/mood**: **profesional, modern, ramah, tepercaya (trustworthy)**, bersih.
- **Kesan yang diinginkan**: simpel & jelas, tidak ramai, mudah dipakai sekali
  lihat. Hindari kesan "template default Flutter".

---

## 3. Identitas Brand Saat Ini (boleh ditingkatkan)

Desain saat ini sudah memakai fondasi berikut. Claude Design boleh
**menyempurnakan** selama tetap konsisten dan beralasan.

| Token | Nilai |
|-------|-------|
| Primary | `#3D5AFE` (indigo) |
| Primary Dark | `#2A3EB1` |
| Primary Light | `#8187FF` |
| Accent | `#00BFA5` (teal) |
| Success | `#2E7D32` (bg `#E6F4EA`) |
| Danger | `#C62828` (bg `#FDECEA`) |
| Background | `#F5F6FB` |
| Surface | `#FFFFFF` |
| Text Primary | `#1A1C2E` |
| Text Secondary | `#6B6F82` |
| Gradien brand | linear `#3D5AFE → #2A3EB1` (top-left → bottom-right) |
| Font | **Poppins** (`google_fonts`) |
| Sudut (radius) | kartu 16, tombol 14, ikon-kontainer 12–16, header 28 |
| Bayangan | lembut/halus (soft shadow) |

> Jika ingin mengusulkan palet/aksen baru, sertakan alasannya dan tetap jaga
> kontras & aksesibilitas (WCAG AA).

---

## 4. Prinsip Desain

1. **Clean & modern** — banyak whitespace, hierarki visual jelas.
2. **Konsisten** — komponen, spacing, dan warna seragam di semua layar.
3. **Mobile-first** — target layar ponsel, sentuh nyaman (target ≥ 44px).
4. **Material 3** — selaras dengan komponen Flutter (mudah diimplementasikan).
5. **Feedback jelas** — status sukses/gagal/loading/empty selalu terlihat.
6. **Aksesibel** — kontras cukup, ukuran teks terbaca.

---

## 5. Daftar Layar (Screen Inventory)

Mohon desainkan **semua layar** berikut beserta **variasi state**-nya
(loading / empty / error / sukses) bila relevan.

### 5.1 Splash Screen
- Logo/ikon brand (saat ini ikon pin lokasi), nama "GeoAttend", tagline
  "Absensi berbasis lokasi", indikator loading.
- Latar gradien brand. Animasi masuk (fade/scale) dipersilakan.

### 5.2 Home / Dashboard
- Header (gradien) dengan sapaan + nama app.
- **Aksi utama**: kartu/tombol menonjol **"Absensi Sekarang"** (+ subteks
  "Verifikasi kehadiran dalam radius 50 m").
- **Menu**: kartu **Lokasi** (kelola titik) & **Riwayat** (catatan absensi).
- Banner info singkat cara pakai.
- (Opsional) ringkasan: jumlah lokasi, absensi terakhir.

### 5.3 Daftar Lokasi (Master Data)
- List kartu lokasi: nama, alamat, koordinat, radius; aksi **edit** & **hapus**.
- FAB / tombol **Tambah**.
- State: loading, **empty** ("belum ada lokasi"), error + retry.

### 5.4 Form Tambah/Edit Lokasi
- Input **nama lokasi** (validasi).
- Kartu pratinjau koordinat (lat/lng/alamat).
- Dua opsi mengambil titik: **"Ambil Koordinat (GPS)"** & **"Pilih di Peta"**.
- Tombol **Simpan** (dengan state loading).

### 5.5 Map Picker (Google Maps)
- Peta penuh layar, marker dapat digeser, tap untuk memindah pin, kontrol zoom.
- Kartu mengambang menampilkan koordinat terpilih + tombol **"Gunakan Lokasi Ini"**.
- Tombol **"Ke lokasi saya"**.
- State khusus: **API key belum dikonfigurasi** (pesan ramah, bukan peta kosong).

### 5.6 Absensi
- Pemilih lokasi (dropdown/list), kartu info lokasi terpilih (koordinat, radius).
- Tombol besar **"Absensi Sekarang"** (state loading saat memproses GPS).
- State: **belum ada lokasi** (arahkan tambah lokasi dulu).

### 5.7 Dialog Hasil Absensi
- **Diterima**: ikon/aksen **hijau**, "Absensi Berhasil", nama lokasi, jarak
  ("Anda berada X m dari titik lokasi — dalam radius").
- **Ditolak**: ikon/aksen **merah**, "Absensi Ditolak", jarak ("… di luar radius").
- Tombol tutup.

### 5.8 Riwayat Absensi
- List kartu: nama lokasi, **waktu** (terformat), **badge status** (Diterima
  hijau / Ditolak merah), jarak.
- Pull-to-refresh. State: loading, **empty**, error + retry.

---

## 6. Komponen UI yang Diharapkan

Mohon definisikan komponen reusable berikut (beserta variannya):
- **Tombol**: primary (filled), secondary (outlined), dengan ikon, state disabled/loading.
- **Kartu**: kartu menu, kartu aksi (gradien), kartu list item.
- **Badge status**: accepted / rejected.
- **List item**: lokasi & riwayat.
- **Input field**: text field bertema.
- **Dialog**: konfirmasi & hasil.
- **App bar**, **FAB**, **bottom info banner**.
- **Empty state** & **error state** (ikon + pesan + aksi).
- **Loading** (indikator & skeleton bila perlu).

---

## 7. Deliverable yang Diharapkan dari Claude Design

1. **Mockup tiap layar** (mobile portrait), light mode (dark mode opsional).
2. **Variasi state** (loading/empty/error/sukses) untuk layar yang relevan.
3. **Spesifikasi desain** agar mudah diimplementasikan ke Flutter:
   - Warna (hex), ukuran font & weight, spacing (8-pt grid disarankan),
     radius, ukuran ikon, dimensi komponen.
4. **Komponen/design system** ringkas (token + komponen reusable).

**Format hasil** (salah satu / kombinasi):
- Artifact **HTML/CSS** (mockup interaktif) — sangat membantu untuk acuan piksel.
- Gambar (PNG/screenshot) per layar.
- Catatan spesifikasi (markdown) berisi token & ukuran.

> Tujuan akhirnya bisa **diterjemahkan ke widget Flutter (Material 3)**, jadi
> hindari elemen yang sulit direplikasi (efek berat/kustom kompleks) kecuali
> disertai spesifikasi jelas.

---

## 8. Batasan Teknis (penting untuk implementasi)

- **Flutter Material 3**, mobile **portrait**.
- Font **Poppins** (via `google_fonts`).
- Utamakan **ikon Material** / vector ringan; hindari aset gambar berat agar
  aplikasi tetap ringan & offline-friendly.
- Dukungan **Android & iOS**; perhatikan area aman (status bar / notch).
- Map picker memakai **Google Maps** (komponen peta nyata, bukan kustom).

---

## 9. Cara Mengirim Hasil Desain

1. Letakkan file hasil desain di **`docs/design/results/`**
   (mis. `home.html`, `home.png`, `spec.md`, dst.).
2. Beri nama file sesuai layar agar mudah dilacak (lihat `docs/design/README.md`).
3. Beri tahu saya — saya akan **mengimplementasikannya ke Flutter** mengikuti
   spesifikasi, lalu mengintegrasikannya ke aplikasi.

---

_Dokumen ini adalah brief; silakan tingkatkan ide desain selama tetap konsisten
dengan brand, prinsip, dan batasan teknis di atas._
