# Strategi dan Hasil Pengujian

Status: Diperbarui & Terintegrasi (Fase Inisialisasi Fondasi 2026-10-29).

## 1. Strategi Pengujian Monorepo

Pengujian dilakukan secara berlapis untuk memastikan stabilitas kode:
1. **Static Analysis & Typecheck**:
   - `npm run typecheck` (`tsc -b` atau `tsc --noEmit`) pada root dan setiap workspace.
2. **Backend Integration Testing**:
   - Menjalankan Jest dan Supertest pada endpoint `/api/v1/health`.
   - Menguji HTTP status 200, struktur respons JSON sesuai tipe `@battleground/shared`, dan penanganan 404 pada rute yang tidak dikenal.
3. **Mobile Client Verification**:
   - Pengujian integrasi konektivitas mobile terhadap status backend (Loading state, Success state, Error state, dan mekanisme Retry).

---

## 2. Command Pengujian Riil

Perintah yang dikonfigurasi pada package manifest:

| Command | Workspace | Tujuan |
| --- | --- | --- |
| `npm run typecheck` | Root (seluruh workspace) | Memverifikasi kepatuhan tipe TypeScript tanpa emit |
| `npm run test:server` | `apps/server` | Menjalankan suite integration test backend via Jest |
| `npm run test` | Root (seluruh workspace) | Menjalankan seluruh unit & integration test yang tersedia |
| `npm run build:shared` | `packages/shared` | Mengompilasi library kontrak bersama ke folder `dist` |
| `npm run build:server` | `apps/server` | Mengompilasi aplikasi server ke JavaScript produksi |

---

## 3. Log Hasil Pengujian Aktual

Catatan eksekusi command aktual:
- Hasil `npm run typecheck`: Menghasilkan exit code 0 (Bebas error kompilasi TypeScript).
- Hasil `npm run test:server`: Seluruh test suite Jest pada endpoint `/api/v1/health` lulus (status 200 OK, payload sesuai kontrak, 404 handling teruji).

---

## 4. Prosedur Uji Manual End-to-End (Mobile to Backend)

1. Jalankan backend: `npm run dev:server` (Server mendengarkan di `http://localhost:4000`).
2. Jalankan aplikasi Expo: `npm run dev:mobile`.
3. Buka layar di Expo Go / emulator:
   - Amati status awal memuat (*Loading Indicator*).
   - Pastikan layar berubah hijau menampilkan detail status server (`ok`, service, uptime, timestamp).
4. Hentikan server backend (`Ctrl+C`):
   - Tekan tombol **"Uji Koneksi Ulang"** di aplikasi mobile.
   - Amati layar berubah merah menampilkan pesan kegagalan koneksi (*Connection Failed / Timeout*).
5. Nyalakan kembali server backend:
   - Tekan tombol **"Uji Koneksi Ulang"**.
   - Amati layar kembali menampilkan status sukses hijau (*Reconnected*).
