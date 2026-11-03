# Battle Ground Mobile Game

Top-Down Arena Shooter 2D mobile game yang dibangun dengan React Native Expo dan backend server-authoritative Express.

---

## 1. Arsitektur Proyek

Repository ini menggunakan arsitektur **npm workspaces** dengan pembagian paket:

- **`apps/mobile`**: Aplikasi klien React Native menggunakan Expo SDK dan TypeScript, memuat:
  - Layar **Solo Practice Arena (2D Shooter)**: Arena 2D dengan batas dinding fisik, karakter prajurit, dual virtual joystick (gerak dan tembak), proyektil, target dummy dengan HP, dan sistem reset latihan.
  - Layar **Status Koneksi Server**: Monitor healthcheck backend dengan penanganan loading, error, timeout, dan retry.
- **`apps/server`**: Backend REST API & Server-Authoritative Engine menggunakan Express dan TypeScript.
- **`packages/shared`**: Kontrak data (DTO), enum, modul kalkulasi fisika (collision detection, distance, clamp arena, vector normalization) bersama antara mobile dan server.
- **`docs/`**: Dokumentasi lengkap arsitektur, API, aturan bisnis gameplay, keamanan, dan rencana implementasi.

---

## 2. Prasyarat Sistem

- **Node.js**: `v20.x` - `v24.x` (Terverifikasi pada Node.js `v24.20.0`).
- **npm**: `v10.x` atau `v11.x` (Terverifikasi pada npm `11.19.0`).
- **Expo Go** pada perangkat fisik atau simulator Android / iOS.

---

## 3. Instalasi dan Setup Awal

1. Salin template environment variable:
   ```bash
   cp .env.example .env
   ```

2. Pasang seluruh dependensi monorepo:
   ```bash
   npm install
   ```

3. Bangun paket kontrak bersama:
   ```bash
   npm run build:shared
   ```

---

## 4. Cara Menjalankan Aplikasi

### Menjalankan Backend Server
```bash
npm run dev:server
```
Server akan berjalan di `http://localhost:4000`. Endpoint health check:
```bash
curl http://localhost:4000/api/v1/health
```

### Menjalankan Mobile Client (Expo)
```bash
npm run dev:mobile
```
Setelah Expo CLI terbuka:
- Tekan **`a`** untuk membuka pada **Android Emulator**.
- Tekan **`i`** untuk membuka pada **iOS Simulator**.
- Pindai QR Code di layar menggunakan aplikasi **Expo Go** pada perangkat fisik Android/iOS.

> **Catatan Konfigurasi Alamat API (`EXPO_PUBLIC_API_URL`)**:
> - **iOS Simulator**: `http://localhost:4000`
> - **Android Emulator**: `http://10.0.2.2:4000` (karena Android emulator menggunakan `10.0.2.2` sebagai alias host machine)
> - **Perangkat Fisik (Expo Go)**: `http://<IP-LAN-KOMPUTER>:4000` (contoh: `http://192.168.1.15:4000`)

---

## 5. Pengujian & Analisis Kode

Jalankan perintah pengujian dan pengecekan tipe:

```bash
# Typecheck seluruh workspace (Shared, Server, Mobile)
npm run typecheck

# Jalankan linter ESLint
npm run lint

# Jalankan seluruh unit & integration test (Jest)
npm test

# Verifikasi integritas dependensi Expo
cd apps/mobile && npx expo-doctor
```

---

## 6. Dokumentasi Lanjutan

- [PRD.md](file:///e:/Project/Game/battleground/PRD.md): Rincian produk, gameplay loop, dan kontrol dual virtual joystick.
- [docs/ARCHITECTURE.md](file:///e:/Project/Game/battleground/docs/ARCHITECTURE.md): Diagram modul dan arsitektur sistem.
- [docs/API.md](file:///e:/Project/Game/battleground/docs/API.md): Spesifikasi kontrak endpoint REST API.
- [docs/BUSINESS_RULES.md](file:///e:/Project/Game/battleground/docs/BUSINESS_RULES.md): Mekanika arena, aturan menang/kalah, dan kalkulasi hit.
- [docs/TESTING.md](file:///e:/Project/Game/battleground/docs/TESTING.md): Log eksekusi dan hasil pengujian riil.
- [docs/IMPLEMENTATION_PLAN.md](file:///e:/Project/Game/battleground/docs/IMPLEMENTATION_PLAN.md): Peta jalan tahapan pengerjaan.
