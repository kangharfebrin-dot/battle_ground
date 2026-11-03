# Changelog

Seluruh perubahan signifikan pada dokumentasi dan implementasi kode dicatat di sini.

## 0.4.0 — 2026-10-29

### Ditambahkan
- Modul gameplay arena 2D Solo Practice (`apps/mobile/src/game/SoloPracticeArena.tsx`):
  - Game loop 60 FPS menggunakan `requestAnimationFrame`.
  - Karakter pemain dengan penunjuk arah bidik dan pembatasan gerak dinding arena.
  - Komponen `VirtualJoystick` (`PanResponder`) untuk translasi dan aiming/firing.
  - Mekanisme penembakan proyektil, patroli target dummy, circle collision detection, deduksi HP pemain dan dummy.
  - Penghitungan skor eliminasi, Game Over overlay, dan tombol Reset Solo Practice instan.
- Modul fisika matematika bersama di `@battleground/shared` (`calculateDistance`, `checkCircleCollision`, `clampToArena`, `normalizeVector`).
- Unit test fisika di `apps/server/tests/physics.test.ts` (7 test cases baru, total 10 test suite Jest lolos).
- Integrasi ESLint monorepo (`.eslintrc.json`) dan script `npm run lint`.
- Tab switcher pada `apps/mobile/App.tsx` untuk berpindah instan antara Solo Practice Arena dan Status Server Monitor.
- Aset placeholder resmi di `apps/mobile/assets/` (`icon.png`, `splash.png`, `adaptive-icon.png`, `favicon.png`).

### Diperbaiki
- Menyelesaikan 3 isu peringatan `expo-doctor`:
  - Menghubungkan aset `icon.png` dan `splash.png` yang valid di `apps/mobile/app.json`.
  - Memperbaiki `apps/mobile/metro.config.js` agar mewarisi default `watchFolders` Expo dan menambahkan root monorepo.
  - Memperbarui `react-native` ke versi `0.76.9` yang 100% kompatibel dengan Expo SDK 52.
- Hasil verifikasi `npx expo-doctor`: **18/18 checks passed**.

---

## 0.3.0 — 2026-10-29

- Inisialisasi struktur monorepo npm workspaces (`apps/mobile`, `apps/server`, `packages/shared`).
- Package `@battleground/shared` dengan kontrak TypeScript untuk `HealthStatusResponse` dan error envelope.
- Backend Express pada `apps/server` dengan endpoint `GET /api/v1/health`, middleware Helmet, CORS terkonfigurasi, error handling terpusat, validasi environment, dan graceful shutdown.
- Integration test backend menggunakan Jest dan Supertest.
- Aplikasi React Native Expo pada `apps/mobile` dengan layar status koneksi backend.

---

## 0.2.0 — 2026-10-27

- Menyelesaikan audit awal repository berbasis bukti (Greenfield verification).
- Memperbarui `docs/AUDIT_REPORT.md` dengan hasil eksekusi perintah aktual dan temuan terstruktur (AUD-001, AUD-002, AUD-003).

---

## 0.1.0 — 2026-10-27

- Menambahkan paket dokumentasi awal Battle Ground.
- Menambahkan instruksi AI agent, Rules kontekstual, dan Agent Skills.
