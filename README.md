# Tugas 2 IF4073 - Pemrosesan Citra dalam Ranah Frekuensi

Program GUI MATLAB untuk penapisan dan restorasi citra dalam ranah frekuensi. Program menampilkan citra masukan, spektrum Fourier, fungsi penapis/fungsi degradasi H(u,v), citra hasil, spektrum hasil, dan citra referensi, beserta parameter dan PSNR terhadap referensi.

Metode yang tersedia:
- B. Low-pass filter: Ideal, Gaussian, Butterworth
- C. High-pass filter: Ideal, Gaussian, Butterworth
- D. Peningkatan kecerahan: penguatan komponen DC dan frekuensi rendah
- E. Restorasi derau periodik: bandreject Ideal, Butterworth, Gaussian, dan notch reject
- F. Restorasi motion blur: inverse filtering dan Wiener filtering

Semua fungsi transfer H(u,v), PSF motion blur, inverse filter, dan Wiener filter dibuat sendiri. Fungsi bawaan yang dipakai hanya `fft2`, `ifft2`, `fftshift`, `ifftshift`, dan operasi matriks. Citra berwarna diproses per kanal RGB.

## Dependensi

- MATLAB R2021a atau lebih baru
- Tidak memerlukan Image Processing Toolbox

## Cara Menjalankan

```matlab
main
```

1. Klik **Pilih Citra...** dan pilih citra dari folder `dataset/<bagian>/input`.
2. (Opsional) Klik **Pilih Citra Referensi...** untuk menampilkan citra acuan dan menghitung PSNR.
3. Pilih metode dan isi parameter, lalu klik **Proses**.
4. **Simpan Hasil** menyimpan citra hasil (untuk motion blur: `_inverse` dan `_wiener`).

Catatan penggunaan:
- Klik pada **Spektrum Masukan** menampilkan posisi (dx, dy) dan jarak D dari pusat, berguna untuk menentukan D0 bandreject. Pada metode **Notch Reject**, klik tersebut langsung menambahkan lokasi notch (pasangan simetrisnya otomatis ikut ditolak).
- Untuk citra motion blur, panjang dan sudut diisi otomatis dari nama berkas (`_L19_A20`) dan tetap dapat diubah.

## Struktur Program

| Folder | Isi |
|---|---|
| `src/gui` | GUI (`FrequencyApp`) |
| `src/filters` | `lowpassFilter`, `highpassFilter`, `brightnessFilter`, `bandrejectFilter`, `notchRejectFilter` |
| `src/restoration` | `motionPsf`, `psfToOtf`, `inverseFilter`, `wienerFilter` |
| `src/utils` | `filterImage` (FFT, kali H, inverse FFT), `logSpectrum`, `distanceGrid`, pembaca citra |
| `src/methodCatalog.m`, `src/applyMethod.m` | daftar metode dan pemanggilnya |

## Anggota Kelompok

| NIM      | Nama                  |
| 18223020 | Brandon Theodore F    |
| 18223132 | Muhammad Rafly Fauzan |
