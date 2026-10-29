# Changelog

Seluruh perubahan signifikan pada dokumentasi dan implementasi kode dicatat di sini.

## 0.3.0 — 2026-10-29

### Ditambahkan
- Inisialisasi struktur monorepo npm workspaces (`apps/mobile`, `apps/server`, `packages/shared`).
- Package `@battleground/shared` dengan kontrak TypeScript untuk `HealthStatusResponse` dan error envelope.
- Backend Express pada `apps/server` dengan endpoint `GET /api/v1/health`, middleware Helmet, CORS terkonfigurasi, error handling terpusat, validasi environment, dan graceful shutdown.
- Integration test backend menggunakan Jest dan Supertest untuk pengujian endpoint `/api/v1/health` dan penanganan 404.
- Aplikasi React Native Expo pada `apps/mobile` dengan layar status koneksi backend, penanganan timeout/error, tombol coba ulang (retry), dan feedback status visual.
- Konfigurasi `.env.example` dan `.gitignore` lengkap.

### Diubah
- Menyelesaikan temuan audit **AUD-003**: Konfirmasi keputusan produk (Top-Down Arena Shooter 2D, dual virtual joystick, mode realtime synchronous multiplayer serta Solo Practice, backend server-authoritative, transport REST API dan Socket.IO).
- Memutakhirkan seluruh dokumentasi teknis (`PRD.md`, `README.md`, `docs/AUDIT_REPORT.md`, `docs/ARCHITECTURE.md`, `docs/DATABASE.md`, `docs/API.md`, `docs/BUSINESS_RULES.md`, `docs/SECURITY.md`, `docs/TESTING.md`, `docs/DEPLOYMENT.md`, `docs/IMPLEMENTATION_PLAN.md`, `docs/PROGRESS.md`) agar konsisten dengan implementasi riil.

---

## 0.2.0 — 2026-10-27

- Menyelesaikan audit awal repository berbasis bukti (Greenfield verification).
- Memperbarui `docs/AUDIT_REPORT.md` dengan hasil eksekusi perintah aktual dan temuan terstruktur (AUD-001, AUD-002, AUD-003).
- Memperbarui `docs/ARCHITECTURE.md`, `docs/DATABASE.md`, `docs/API.md`, `docs/TESTING.md`, dan `docs/PROGRESS.md` untuk merefleksikan kondisi greenfield dan cetak biru arsitektur.

---

## 0.1.0 — 2026-10-27

- Menambahkan paket dokumentasi awal Battle Ground.
- Mencatat React Native Expo dan Express sebagai stack yang diminta.
- Menambahkan instruksi AI agent, Rules kontekstual, dan Agent Skills.
