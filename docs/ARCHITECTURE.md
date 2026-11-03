# Arsitektur Sistem

Status: Baseline Arsitektur Terkonfirmasi & Gameplay Slice Terpasang (2026-10-29).

## 1. Fakta Arsitektur Terverifikasi

- **Struktur Monorepo**: Menggunakan npm workspaces resmi (`apps/mobile`, `apps/server`, `packages/shared`).
- **Stack Terpilih**:
  - **Mobile**: React Native + Expo SDK 52 (TypeScript).
  - **Backend**: Express (Node.js) + TypeScript.
  - **Shared Contract**: `@battleground/shared` (TypeScript library).
- **Transport Komunikasi**:
  - **REST API**: Endpoint `/api/v1/*` untuk administrasi, profile, dan health check.
  - **Socket.IO** (Fase berikutnya): Transport realtime bi-directional untuk sinkronisasi multiplayer.
- **Runtime Lingkungan Host**: Node.js `v24.20.0`, npm `11.19.0` (Windows).

## 2. Struktur Monorepo Aktual

```text
battleground/
├── package.json               # Root monorepo workspace manifest
├── tsconfig.json              # Base TypeScript configuration
├── .eslintrc.json             # Konfigurasi ESLint & @typescript-eslint
├── .gitignore                 # Dependency, build outputs, environment ignores
├── .env.example               # Template environment variables (non-secret)
├── README.md                  # Panduan operasional proyek
├── CHANGELOG.md               # Catatan rilis dan evolusi kode
├── AGENTS.md                  # Panduan integritas dan instruksi AI agent
├── PRD.md                     # Product Requirements Document
├── apps/
│   ├── mobile/                # React Native Expo Client
│   │   ├── src/
│   │   │   ├── config/        # API Base URL & environment config
│   │   │   └── game/          # Modul Gameplay Solo Practice 2D
│   │   │       ├── components/
│   │   │       │   └── VirtualJoystick.tsx # Dual touch joystick (PanResponder)
│   │   │       └── SoloPracticeArena.tsx   # 60 FPS loop, arena, collision & HP
│   │   ├── assets/            # App icons, splash, adaptive icons
│   │   ├── app.json           # Konfigurasi Expo SDK 52 (orientation landscape)
│   │   ├── App.tsx            # Layar terpadu (Tab Arena & Tab Status Server)
│   │   ├── metro.config.js    # Konfigurasi Metro monorepo resolver
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── server/                # Express Backend Service
│       ├── src/
│       │   ├── config/        # Validasi environment & port binding
│       │   ├── controllers/   # Request handler (Healthcheck controller)
│       │   ├── middleware/    # Helmet, CORS, Error Handler terpusat
│       │   ├── routes/        # Router modular `/api/v1/*`
│       │   ├── app.ts         # Inisialisasi Express Application
│       │   └── server.ts      # Server entrypoint & graceful shutdown
│       ├── tests/             # Supertest & Jest integration tests
│       ├── jest.config.js
│       ├── package.json
│       └── tsconfig.json
├── packages/
│   └── shared/                # Tipe Data Bersama & Modul Fisika Matematika
│       ├── src/
│       │   ├── contracts/     # Health contract & Game contract
│       │   ├── physics/       # Collision detection, distance, clamp arena
│       │   └── index.ts       # Main export
│       ├── package.json
│       └── tsconfig.json
└── docs/                      # Dokumentasi teknis, audit, dan tata kelola
```

## 3. Komponen Inti Gameplay Arena 2D (`apps/mobile/src/game`)

1. **Virtual Joystick (`VirtualJoystick.tsx`)**:
   - Dibangun menggunakan native React Native `PanResponder` tanpa dependensi native eksternal tambahan.
   - Menghasilkan event ternormalisasi: vektor `(x, y)` rentang `[-1, 1]`, magnitudo `[0, 1]`, dan sudut rotasi `angle` (radian).
2. **Arena Playfield & Loop (`SoloPracticeArena.tsx`)**:
   - Loop game 60 FPS menggunakan `requestAnimationFrame`.
   - Batas arena adaptif dengan deteksi dinding fisik.
   - Pemain (karakter lingkaran dengan indikator turret bidik) dapat bermanuver 360 derajat.
   - Mekanika tembakan proyektil berkecepatan 9 unit/tick dengan cooldown 220ms.
   - Target dummy bot dengan HP bar (60 HP) yang berpatroli di dalam arena.
   - Deteksi tabrakan fisik proyektil-target (damage 20 HP) dan eliminasi target (skor +100).
   - Deteksi kontak tabrakan pemain-target yang mengurangi HP pemain.
   - Kondisi Game Over saat HP pemain = 0 dengan tombol Reset Practice instan.
