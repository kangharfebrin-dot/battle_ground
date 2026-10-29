# Battle Ground Mobile Game

Top-Down Arena Shooter 2D mobile game yang dibangun dengan React Native Expo dan backend server-authoritative Express.

---

## 1. Arsitektur Proyek

Repository ini menggunakan arsitektur **npm workspaces** dengan pembagian paket:

- **`apps/mobile`**: Aplikasi klien React Native menggunakan Expo SDK dan TypeScript.
- **`apps/server`**: Backend REST API & Server-Authoritative Engine menggunakan Express dan TypeScript.
- **`packages/shared`**: Kontrak data (DTO), enum, dan antarmuka TypeScript bersama antara mobile dan server.
- **`docs/`**: Dokumentasi lengkap arsitektur, API, aturan bisnis gameplay, keamanan, dan rencana implementasi.

---

## 2. Prasyarat Sistem

- **Node.js**: `v20.x` - `v24.x` (Direkomendasikan Node.js LTS atau versi aktif, terverifikasi pada Node.js `v24.20.0`).
- **npm**: `v10.x` atau `v11.x` (Terverifikasi pada npm `11.19.0`).
- **Expo Go** pada perangkat fisik atau simulator Android / iOS.

---

## 3. Instalasi dan Setup Awal

1. Clone repository dan masuk ke direktori:
   ```bash
   git clone https://github.com/kangharfebrin-dot/battle_ground.git
   cd battle_ground
   ```

2. Salin template environment variable:
   ```bash
   cp .env.example .env
   ```

3. Pasang seluruh dependensi monorepo:
   ```bash
   npm install
   ```

4. Bangun paket kontrak bersama:
   ```bash
   npm run build:shared
   ```

---

## 4. Cara Menjalankan Aplikasi

### Menjalankan Backend Server
```bash
npm run dev:server
```
Server akan berjalan di `http://localhost:4000`. Anda dapat memverifikasi kesehatan server melalui peramban atau terminal:
```bash
curl http://localhost:4000/api/v1/health
```

### Menjalankan Mobile Client (Expo)
```bash
npm run dev:mobile
```
Setelah Expo CLI terbuka, tekan `a` untuk Android Emulator, `i` untuk iOS Simulator, atau pindai QR code menggunakan aplikasi **Expo Go** pada perangkat fisik.

> **Catatan Konfigurasi Alamat API (`EXPO_PUBLIC_API_URL`)**:
> - **iOS Simulator**: `http://localhost:4000`
> - **Android Emulator**: `http://10.0.2.2:4000` (karena Android emulator menggunakan `10.0.2.2` sebagai alias host machine)
> - **Perangkat Fisik (Expo Go)**: `http://<IP-LAN-KOMPUTER>:4000` (contoh: `http://192.168.1.15:4000`)

---

## 5. Pengujian & Analisis Kode

Jalankan perintah pengujian dan pengecekan tipe:

```bash
# Typecheck seluruh workspace
npm run typecheck

# Jalankan integration test backend (Jest + Supertest)
npm run test:server

# Build backend untuk produksi
npm run build:server
```

---

## 6. Dokumentasi Lanjutan

- [PRD.md](file:///e:/Project/Game/battleground/PRD.md): Rincian produk, gameplay loop, dan kontrol dual virtual joystick.
- [docs/ARCHITECTURE.md](file:///e:/Project/Game/battleground/docs/ARCHITECTURE.md): Diagram dan batas tanggung jawab komponen sistem.
- [docs/API.md](file:///e:/Project/Game/battleground/docs/API.md): Spesifikasi kontrak endpoint REST API.
- [docs/BUSINESS_RULES.md](file:///e:/Project/Game/battleground/docs/BUSINESS_RULES.md): Mekanika arena, aturan menang/kalah, dan otoritas server.
- [docs/SECURITY.md](file:///e:/Project/Game/battleground/docs/SECURITY.md): Penegakan zero client secrets dan pengerasan server.
- [docs/TESTING.md](file:///e:/Project/Game/battleground/docs/TESTING.md): Laporan dan strategi pengujian.
- [docs/PROGRESS.md](file:///e:/Project/Game/battleground/docs/PROGRESS.md): Status pencapaian milestone.
