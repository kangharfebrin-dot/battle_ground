# Product Requirements Document — Battle Ground Mobile Game

- **Status**: BASELINE TERKONFIRMASI (Disepakati 2026-10-28 / 2026-10-29).
- **Genre**: Top-Down Arena Shooter 2D.
- **Sistem Kontrol**: Dual Virtual Joystick (Stik kiri: Gerakan/Navigasi translasi, Stik kanan: Arah bidikan & firing proyektil).
- **Mode Permainan**:
  1. **Realtime Synchronous Multiplayer**: Room-based arena survival bersama pemain lain.
  2. **Solo Practice**: Mode latihan mandiri (offline / bot match) untuk mengasah mekanika menembak dan manuver.
- **Model Otoritas State**: Server-Authoritative untuk match state, collision, damage, eliminasi, dan skor akhir. Klien hanya mengirim input vektor dan menerima snapshot state terotorisasi.
- **Transport Komunikasi**: REST API (manajemen akun, healthcheck, matchmaking queue) dan Socket.IO (game loop sinkron realtime).
- **Mobile Client**: React Native Expo (TypeScript).
- **Backend**: Express (Node.js) + Socket.IO Server (TypeScript).
- **Arsitektur Repository**: Monorepo npm workspaces (`apps/mobile`, `apps/server`, `packages/shared`).

---

## 1. Ringkasan Produk

**Battle Ground** adalah game mobile aksi survival bertema *top-down arena shooter 2D*. Pemain mengendalikan prajurit di dalam arena tertutup dengan rintangan fisik, bermanuver menghindari tembakan proyektil lawan, mengambil item arena, dan berusaha bertahan hidup hingga akhir atau mengumpulkan skor eliminasi tertinggi.

---

## 2. Platform & Target Pengguna

- **Platform Target**: Android & iOS (via Expo).
- **Orientasi Layar**: Landscape (dioptimasi untuk dual thumb touch input) atau adaptif safe-area.
- **Target Performa**: 60 FPS pada perangkat mobile mainstream.
- **Sistem Kontrol**: Dual Virtual Joystick.
  - Joystick Kiri: Mengatur arah dan kecepatan translasi karakter (360 derajat).
  - Joystick Kanan: Mengatur sudut bidikan (aim angle) dan melepaskan tembakan (fire trigger).

---

## 3. Mode Permainan & Core Gameplay Loop

### A. Mode Permainan
1. **Realtime Synchronous Multiplayer**:
   - Pemain bergabung ke dalam room/arena bersama pemain lain melalui matchmaking/room code.
   - Server mensimulasikan pergerakan, benturan proyektil, dan pengurangan HP.
2. **Solo Practice**:
   - Pemain dapat langsung masuk arena simulasi tanpa menunggu pemain lain.
   - Berguna untuk uji latency, performa FPS lokal, kalibrasi joystick, dan latihan mekanika tembakan.

### B. Core Gameplay Loop
1. **Lobby / Mode Selection**: Pemain memilih mode (Multiplayer atau Solo Practice).
2. **Match Initiation**: Server menginisialisasi koordinat arena, boundary dinding, dan titik spawn pemain.
3. **Combat & Survival**:
   - Pemain bermanuver dengan joystick kiri dan menembak dengan joystick kanan.
   - Menghindari proyektil musuh dan bahaya arena.
   - Mengambil power-ups (Health Kit, Speed Boost, Weapon Ammo) jika tersedia.
4. **Elimination & Victory Resolution**:
   - Pemain dengan HP = 0 tereliminasi.
   - Pemenang ditentukan oleh pemain/tim terakhir yang bertahan (*Last Standing*) atau akumulasi kill score tertinggi.
5. **Post-Match Summary**: Hasil pertandingan dicatat dan divalidasi oleh backend server-authoritative.

---

## 4. Kebutuhan Fungsional (Functional Requirements)

| ID | Kebutuhan | Deskripsi & Acceptance Criteria | Prioritas | Status |
| --- | --- | --- | --- | --- |
| FR-001 | Workspace & Tooling Foundation | Root npm workspaces (`apps/mobile`, `apps/server`, `packages/shared`) dengan TypeScript & ESLint terkonfigurasi. | P0 | IN PROGRESS |
| FR-002 | Backend Service & Healthcheck | Express server dengan middleware standar (`helmet`, `cors`, `express.json`) dan endpoint `GET /api/v1/health`. | P0 | IN PROGRESS |
| FR-003 | Mobile Client Shell | Aplikasi Expo menampilkan nama game, status konektivitas backend riil, dan tombol retry. | P0 | IN PROGRESS |
| FR-004 | Shared Contracts Package | Package `@battleground/shared` menyediakan type data kontrak health dan basis DTO bersama. | P0 | IN PROGRESS |
| FR-005 | Realtime Gateway (Socket.IO) | WebSocket server untuk koordinasi room, input dispatching, dan broadcast snapshot 20-30 Hz. | P1 | Terencana |
| FR-006 | Dual Joystick Engine (Mobile) | Komponen virtual joystick kanan dan kiri responsif dengan touch gesture mulus. | P1 | Terencana |
| FR-007 | Server-Authoritative Combat Engine | Server memvalidasi collision bounding-box pemain, peluru, HP, dan eliminasi. | P1 | Terencana |
| FR-008 | Solo Practice Offline/Local Simulation | Mode permainan lokal untuk latihan mandiri tanpa ketergantungan koneksi match eksternal. | P1 | Terencana |

---

## 5. Non-Functional Requirements

- **Integritas Server-Authoritative**: Client dianggap untrusted. Penghitungan damage, knockback, dan skor mutlak dihitung di server.
- **Zero Client Secrets**: Tidak ada token database, API private keys, atau secret server di bundle Expo (`EXPO_PUBLIC_*`).
- **Resilience & Network Recovery**: Mobile client mendeteksi disconnect dan mampu melakukan reconnect/retry dengan feedback UI jelas.
- **Observability**: Log server terstruktur tanpa membocorkan credential, token, atau data personal (PII).
