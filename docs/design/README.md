# docs/design — Desain UI GeoAttend

Folder ini menampung proses & hasil desain UI aplikasi GeoAttend.

## Struktur

```
docs/design/
├── brainstorming_design.md   # Brief untuk Claude (Design) — baca ini dulu
├── README.md                 # File ini
└── results/                  # Hasil desain dari Claude (Design) diletakkan di sini
```

## Alur Kerja

1. **Brief** — `brainstorming_design.md` berisi konteks aplikasi, brand,
   daftar layar, komponen, deliverable, dan batasan teknis. Berikan dokumen ini
   ke Claude (Design).
2. **Hasil desain** — letakkan keluaran desain (HTML/CSS, gambar PNG, atau
   spesifikasi markdown) pada folder **`results/`**.
3. **Implementasi** — beri tahu untuk menerjemahkan desain ke widget Flutter
   (Material 3) sesuai spesifikasi.

## Saran Penamaan File di `results/`

Gunakan nama sesuai layar agar mudah dilacak, contoh:

| Layar | Contoh nama file |
|-------|------------------|
| Splash | `splash.html` / `splash.png` |
| Home / Dashboard | `home.html` / `home.png` |
| Daftar Lokasi | `location-list.png` |
| Form Lokasi | `location-form.png` |
| Map Picker | `map-picker.png` |
| Absensi | `attendance.png` |
| Dialog Hasil | `attendance-result.png` |
| Riwayat | `attendance-history.png` |
| Design system / token | `design-system.md` |

> Sertakan juga spesifikasi (warna hex, ukuran, spacing, radius, font weight)
> bila memungkinkan agar implementasi ke Flutter lebih presisi.
