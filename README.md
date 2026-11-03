# Battle Ground (Tactical 2D Top-Down Arena Shooter)

Battle Ground adalah game 2D Top-Down Tactical Arena Shooter multi-platform yang dibangun dengan klien PC native (**Godot 4.x**), klien mobile (**React Native Expo**), dan backend server-authoritative (**Express + TypeScript**).

---

## 1. Arsitektur Proyek Monorepo

Repository ini menggunakan arsitektur **npm workspaces** dengan pembagian paket modular:

- **`apps/pc-client`**: Klien PC native (Godot 4.x / GDScript):
  - Layar **Main Menu & Settings**: Navigasi mode solo practice, dialog konfigurasi tampilan fullscreen, audio bus volume, dan sensitivitas mouse.
  - Layar **Playable Arena**: Pertempuran 2D dengan kontrol WASD 360°, bidikan kursor mouse, sprint (Shift), dash taktis (Spasi), sistem senjata berganti (Pistol, Shotgun, Assault Rifle), reload otomatis/manual (R), peluru proyektil, target dummy latihan respawning, kamera halus (`Camera2D`), HUD telemetri tempur, dan pause overlay in-game (ESC).
- **`apps/mobile`**: Aplikasi klien React Native menggunakan Expo SDK dan TypeScript:
  - Layar **Solo Practice Arena**: Arena 2D dengan dual virtual joystick (gerak dan tembak), proyektil, target dummy dengan HP, dan tombol reset latihan.
  - Layar **Status Koneksi Server**: Monitor healthcheck backend dengan penanganan loading, error, timeout, dan retry.
- **`apps/server`**: Backend REST API & Server-Authoritative Engine menggunakan Express dan TypeScript.
- **`packages/game-data`**: Konfigurasi game balance bersama dalam format JSON (`character.json`, `weapons.json`, `arena.json`) yang menjamin paritas gameplay antara PC dan mobile.
- **`packages/protocol`**: Skema pesan jaringan berbasis JSON Schema (`player-input.schema.json`, `game-state.schema.json`) untuk protokol realtime.
- **`packages/shared`**: Kontrak data (DTO), enum, modul kalkulasi fisika (collision detection, distance, clamp arena, vector normalization) bersama antara mobile dan server.
- **`docs/`**: Dokumentasi lengkap arsitektur PC, gameplay, input system, pipeline aset, build & deployment, testing, dan multiplayer.

---

## 2. Prasyarat Sistem

- **Node.js**: `v20.x` - `v24.x` (Terverifikasi pada Node.js `v24.20.0`).
- **npm**: `v10.x` atau `v11.x` (Terverifikasi pada npm `11.19.0`).
- **Godot Engine**: `v4.3+` (Terverifikasi pada Godot `v4.7.2-stable Win64`).
- **Expo Go** pada perangkat fisik atau simulator Android / iOS (untuk mobile client).

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

### Menjalankan Klien PC (Godot 4.x)

Buka project melalui editor Godot atau jalankan langsung dari command line:

```powershell
# Jalankan game PC langsung di desktop
godot --path apps/pc-client

# Jalankan uji otomatis headless tanpa jendela GUI
godot --headless --path apps/pc-client -s tests/test_headless_smoke.gd
```

> **Kontrol Default PC**:
> - `W`, `A`, `S`, `D`: Bergerak 360 derajat
> - `Mouse Cursor`: Membidik arah tembakan 360 derajat
> - `Klik Kiri (LMB)`: Menembak
> - `Shift Kiri`: Sprint (Kecepatan meningkat)
> - `Spasi`: Dash taktis cepat
> - `R`: Isi ulang amunisi (Reload)
> - `1`, `2`, `3`: Berganti senjata (Pistol, Shotgun, Rifle)
> - `ESC`: Pause permainan / Menu

---

### Menjalankan Backend Server

```bash
npm run dev:server
```

Server akan berjalan di `http://localhost:4000`. Endpoint health check:

```bash
curl http://localhost:4000/api/v1/health
```

---

### Menjalankan Mobile Client (Expo)

```bash
npm run dev:mobile
```

Setelah Expo CLI terbuka:
- Tekan **`a`** untuk membuka pada **Android Emulator**.
- Tekan **`i`** untuk membuka pada **iOS Simulator**.
- Pindai QR Code di layar menggunakan aplikasi **Expo Go** pada perangkat fisik Android/iOS.

---

## 5. Pengujian & Analisis Kualitas Kode

Jalankan rangkaian pengujian otomatis monorepo:

```bash
# Validasi tipe statis TypeScript seluruh workspace (Shared, Server, Mobile)
npm run typecheck

# Jalankan linter ESLint
npm run lint

# Jalankan seluruh unit & integration test backend (Jest)
npm test

# Jalankan smoke test otomatis klien PC Godot (Headless)
godot --headless --path apps/pc-client -s tests/test_headless_smoke.gd

# Verifikasi integritas dependensi Expo
cd apps/mobile && npx expo-doctor
```

---

## 6. Indeks Dokumentasi

### Dokumentasi Arsitektur PC (Godot 4.x)
- [docs/PC_MIGRATION_AUDIT.md](file:///e:/Project/Game/battleground/docs/PC_MIGRATION_AUDIT.md): Laporan audit migrasi ke PC game native.
- [docs/PC_ARCHITECTURE.md](file:///e:/Project/Game/battleground/docs/PC_ARCHITECTURE.md): Arsitektur teknis client PC, scene hierarchy, dan autoload singletons.
- [docs/PC_GAMEPLAY.md](file:///e:/Project/Game/battleground/docs/PC_GAMEPLAY.md): Spesifikasi mekanika arena, combat loop, balistik, dan target dummy.
- [docs/PC_INPUT_SYSTEM.md](file:///e:/Project/Game/battleground/docs/PC_INPUT_SYSTEM.md): Sistem input keyboard & mouse 360°, rebinding, dan akselerasi bidikan.
- [docs/PC_ASSET_PIPELINE.md](file:///e:/Project/Game/battleground/docs/PC_ASSET_PIPELINE.md): Pipeline dual visual (prosedural vs tekstur sprite) dan sistem audio.
- [docs/PC_BUILD_DEPLOYMENT.md](file:///e:/Project/Game/battleground/docs/PC_BUILD_DEPLOYMENT.md): Panduan build biner native Windows (.exe), Linux, dan macOS.
- [docs/PC_TESTING.md](file:///e:/Project/Game/battleground/docs/PC_TESTING.md): Framework pengujian otomatis headless CLI dan checklist playtest.
- [docs/PC_MULTIPLAYER.md](file:///e:/Project/Game/battleground/docs/PC_MULTIPLAYER.md): Rencana arsitektur multiplayer Fase 2, WebSocket, dan kompensasi latensi.
- [docs/PC_IMPLEMENTATION_PLAN.md](file:///e:/Project/Game/battleground/docs/PC_IMPLEMENTATION_PLAN.md): Roadmap 4 fase pengembangan Battle Ground PC.
- [docs/PC_PROGRESS.md](file:///e:/Project/Game/battleground/docs/PC_PROGRESS.md): Log progres dan hasil verifikasi pengujian aktual.

### Dokumentasi Mobile & Backend
- [PRD.md](file:///e:/Project/Game/battleground/PRD.md): Rincian produk mobile awal dan gameplay loop dual virtual joystick.
- [docs/ARCHITECTURE.md](file:///e:/Project/Game/battleground/docs/ARCHITECTURE.md): Diagram modul dan arsitektur backend Express.
- [docs/API.md](file:///e:/Project/Game/battleground/docs/API.md): Spesifikasi kontrak endpoint REST API.
- [docs/BUSINESS_RULES.md](file:///e:/Project/Game/battleground/docs/BUSINESS_RULES.md): Mekanika arena, aturan menang/kalah, dan kalkulasi hit.
- [docs/TESTING.md](file:///e:/Project/Game/battleground/docs/TESTING.md): Log eksekusi dan hasil pengujian backend.
