# Arsitektur Sistem

Status: Baseline Arsitektur Terkonfirmasi (Diperbarui 2026-10-29).

## 1. Fakta Arsitektur Terverifikasi

- **Struktur Monorepo**: Menggunakan npm workspaces resmi (`apps/mobile`, `apps/server`, `packages/shared`).
- **Stack Terpilih**:
  - **Mobile**: React Native + Expo (TypeScript).
  - **Backend**: Express (Node.js) + TypeScript.
  - **Shared Contract**: `@battleground/shared` (TypeScript library).
- **Transport Komunikasi**:
  - **REST API**: Endpoint `/api/v1/*` untuk administrasi, profile, dan health check.
  - **Socket.IO** (Fase berikutnya): Transport realtime bi-directional untuk game loop sinkron.
- **Runtime Lingkungan Host**: Node.js `v24.20.0`, npm `11.19.0` (Windows).

## 2. Struktur Monorepo Aktual

```text
battleground/
├── package.json               # Root monorepo workspace manifest
├── tsconfig.json              # Base TypeScript configuration
├── .gitignore                 # Dependency, build outputs, environment ignores
├── .env.example               # Template environment variables (non-secret)
├── README.md                  # Dokumentasi panduan operasional proyek
├── CHANGELOG.md               # Catatan rilis dan evolusi dokumentasi/fitur
├── AGENTS.md                  # Panduan integritas dan instruksi AI agent
├── PRD.md                     # Product Requirements Document
├── apps/
│   ├── mobile/                # React Native Expo Client
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── app.json           # Konfigurasi Expo
│   │   ├── App.tsx            # Layar inisial (Health Connectivity & Retry)
│   │   └── src/
│   │       └── config/        # API Base URL & environment config
│   └── server/                # Express Backend Service
│       ├── package.json
│       ├── tsconfig.json
│       ├── src/
│       │   ├── config/        # Validasi environment & port binding
│       │   ├── controllers/   # Request handler (Healthcheck controller)
│       │   ├── middleware/    # Helmet, CORS, Error Handler terpusat
│       │   ├── routes/        # Router modular `/api/v1/*`
│       │   ├── app.ts         # Inisialisasi Express Application
│       │   └── server.ts      # Server entrypoint & graceful shutdown
│       └── tests/             # Supertest & Jest integration tests
├── packages/
│   └── shared/                # Tipe Data Bersama & Kontrak DTO
│       ├── package.json
│       ├── tsconfig.json
│       └── src/
│           ├── index.ts       # Main export
│           └── contracts/     # Health contract & status responses
└── docs/                      # Dokumentasi teknis, audit, dan tata kelola
```

## 3. Pemisahan Tanggung Jawab (Separation of Concerns)

### A. Mobile Client (`apps/mobile`)
- Menangani input interaktif pengguna: Dual Virtual Joystick (translasi posisi dan arah bidik tembak).
- Menampilkan HUD responsif: HP bar, ammo count, ping latency, dan status server.
- Mengelola state transisi koneksi: loading, connected, connection failed, retrying.
- Mengirimkan hanya vektor pergerakan dan trigger aksi ke backend.
- **Prinsip Keamanan Klien**:
  - Dilarang menyimpan credentials database, private keys, atau JWT secret di client bundle.
  - Nilai variabel `EXPO_PUBLIC_*` hanya digunakan untuk URL endpoint publik yang aman dilihat umum.

### B. Express Backend (`apps/server`)
- Mengontrol seluruh otoritas state pertandingan (Server-Authoritative): validasi posisi pemain, deteksi hit peluru, deduksi HP, eliminasi, dan skor kemenangan.
- Menyediakan endpoint RESTful berstruktur envelope konsisten:
  - `GET /api/v1/health`
- Menerapkan security hardening:
  - `helmet` untuk security response headers.
  - `cors` dengan origin terkonfigurasi.
  - Body-parser JSON dengan limit ketat (`10kb`) guna mencegah payload exhaustion.
  - Error middleware terpusat yang tidak membocorkan internal stack trace di mode production.
  - Graceful shutdown menangani sinyal `SIGTERM` dan `SIGINT`.

### C. Shared Package (`packages/shared`)
- Bertindak sebagai single source of truth untuk kontrak API dan DTO antara server dan mobile.
- Menghindari duplikasi tipe TypeScript antara backend dan client Expo.
- Tidak menyertakan logika runtime berlebih atau dependensi eksternal yang tidak diperlukan.

## 4. Pola Jaringan & Alamat API
- **iOS Simulator**: Mengakses backend melalui `http://localhost:4000`.
- **Android Emulator**: Mengakses backend host machine melalui alias loopback `http://10.0.2.2:4000`.
- **Perangkat Fisik (Expo Go / Development Build)**: Mengakses backend melalui IP LAN komputer pengembang (misalnya `http://192.168.x.x:4000`).
- **Server Production / Staging**: Mengakses URL resmi domain HTTPS.
