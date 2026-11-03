# Strategi dan Hasil Pengujian

Status: Diperbarui & Diverifikasi (Fase Gameplay Arena 2D 2026-10-29).

## 1. Strategi Pengujian Monorepo

Pengujian dilakukan secara berlapis untuk memastikan stabilitas kode:
1. **Dependency Integrity (`expo-doctor`)**:
   - Memverifikasi skema `app.json`, kelengkapan aset visual, konfigurasi `metro.config.js`, dan kecocokan versi paket dengan Expo SDK.
2. **Static Analysis & Typecheck**:
   - `npm run typecheck` (`tsc --noEmit`) pada root dan setiap workspace.
3. **Linting (ESLint)**:
   - `npm run lint` (`eslint . --ext .ts,.tsx`) memeriksa kepatuhan sintaks TypeScript dan mendeteksi unused variables / potensi bug runtime.
4. **Unit & Integration Testing (Jest)**:
   - Menguji modul matematika fisika di `@battleground/shared` (jarak, tabrakan lingkaran, penguncian koordinat arena, normalisasi vektor).
   - Menguji backend Express pada endpoint `/api/v1/health` dan penanganan route 404 via Supertest.

---

## 2. Command Pengujian Riil & Hasil Aktual

| Command | Workspace | Target Verifikasi | Hasil Aktual |
| --- | --- | --- | --- |
| `npx expo-doctor` | `apps/mobile` | Validasi aset, app.json, metro.config, dan paket SDK | **18/18 checks passed** (Exit code 0) |
| `npm run typecheck` | Root (Monorepo) | Typechecking `@battleground/shared`, `@battleground/server`, `@battleground/mobile` | **0 errors** (Exit code 0) |
| `npm run lint` | Root (Monorepo) | Linter ESLint pada seluruh file `.ts` dan `.tsx` | **0 errors, 0 warnings** (Exit code 0) |
| `npm test` | Root (Monorepo) | Unit test fisika shared & integration test Express | **10 passed, 2 suites** (Exit code 0) |
| `npm run build:server` | `apps/server` | Kompilasi TypeScript backend ke folder `dist` | **Berhasil** (Exit code 0) |
| `npm run build:shared` | `packages/shared` | Kompilasi deklarasi `.d.ts` dan output CJS | **Berhasil** (Exit code 0) |

---

## 3. Log Output Pengujian Aktual

### A. Hasil `npx expo-doctor`
```text
Running 18 checks on your project...
18/18 checks passed. No issues detected!
```

### B. Hasil `npm test` (Jest)
```text
PASS tests/physics.test.ts
  Shared Game Physics & Mathematics
    calculateDistance
      √ harus menghitung jarak euclidean secara akurat (15 ms)
    checkCircleCollision
      √ harus mendeteksi tabrakan saat jarak antar-pusat <= jumlah radius (1 ms)
      √ harus mendeteksi tidak ada tabrakan saat lingkaran terpisah (1 ms)
    clampToArena
      √ harus membatasi posisi di dalam batas dinding arena (2 ms)
      √ tidak mengubah posisi yang sudah berada di dalam arena (2 ms)
    normalizeVector
      √ harus menormalkan magnitudo vektor menjadi 1 (1 ms)
      √ mengembalikan { x: 0, y: 0 } untuk vektor nol (1 ms)

PASS tests/health.test.ts
  Express Backend Health API
    GET /api/v1/health
      √ harus mengembalikan status 200 dan payload HealthStatusResponse yang valid (85 ms)
      √ harus menyertakan security headers dari helmet (13 ms)
    Handling Unknown Routes
      √ harus mengembalikan HTTP 404 untuk rute yang tidak terdaftar (10 ms)

Test Suites: 2 passed, 2 total
Tests:       10 passed, 10 total
Snapshots:   0 total
Time:        5.565 s
```

### C. Hasil `npm run lint`
```text
> battleground-monorepo@0.1.0 lint
> eslint . --ext .ts,.tsx
(Exit code 0)
```
