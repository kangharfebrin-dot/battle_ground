# Build, Deployment, dan Release

Status: Checklist Kesiapan & Panduan Operasional Lingkungan (2026-10-29).

## 1. Lingkungan Pengembangan (Development Environment)

### A. Persyaratan Host
- Node.js: `v20.x` hingga `v24.x` (Teruji pada Node.js `v24.20.0`).
- Package Manager: `npm` versi `10.x` atau `11.x` (Teruji pada npm `11.19.0`).
- Expo CLI: Terintegrasi via local `npx expo`.

### B. Konfigurasi Lingkungan
- Buat file `.env` di root atau di folder `apps/server` berdasarkan template `.env.example`.
- Variabel Server:
  - `PORT=4000`
  - `NODE_ENV=development`
  - `CORS_ORIGIN=*`
- Variabel Mobile:
  - `EXPO_PUBLIC_API_URL`: Mengarah ke IP/host server backend yang dapat diakses oleh perangkat/emulator klien.

---

## 2. Proses Build & Verifikasi Monorepo

1. **Build Shared Library**:
   ```bash
   npm run build:shared
   ```
   Menghasilkan file deklarasi `.d.ts` dan output JavaScript di `packages/shared/dist`.

2. **Build Server**:
   ```bash
   npm run build:server
   ```
   Menghasilkan output kompilasi TypeScript server di `apps/server/dist`.

3. **Verifikasi Bundle Mobile**:
   ```bash
   npx expo export --workspace=apps/mobile
   ```

---

## 3. Checklist Rilis Produksi (Production Readiness)

- [ ] Seluruh static typecheck (`npm run typecheck`) lulus dengan exit code 0.
- [ ] Seluruh unit dan integration test (`npm test`) lulus.
- [ ] Variabel `NODE_ENV` disetel ke `production` pada server backend.
- [ ] Variable `CORS_ORIGIN` dibatasi hanya ke domain/origin yang diotorisasi.
- [ ] Tidak ada file `.env`, kredensial, atau private keys yang ter-commit ke git.
- [ ] Endpoint `/api/v1/health` dapat diakses oleh load balancer / container orchestrator sebagai liveness probe.
