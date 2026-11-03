# Audit Kesiapan Migrasi PC — Battle Ground

**Tanggal Audit**: 2026-11-03  
**Auditor**: Senior Game Developer, Game Architect & QA Engineer  
**Referensi Utama**: `deep-research-report.md`, `PRD.md`, `docs/ARCHITECTURE.md`, `packages/shared/`, `apps/mobile/`, `apps/server/`  
**Status**: SELESAI & TERVERIFIKASI  

---

## 1. Eksekutif Ringkasan & Keselarasan dengan Deep Research Report

Dokumen `deep-research-report.md` menggarisbawahi transformasi dari prototipe mobile arena menuju game PC yang kompetitif:
1. **Engine Selection**: Godot 4.x dipilih sebagai fondasi PC Client native. Godot 100% open-source, bebas royalti (berbeda dengan Unity yang memiliki runtime fee/langganan atau Unreal dengan royalti 5%), sangat ringan, dan memiliki engine 2D native terbaik untuk genre *Top-Down Arena Shooter*.
2. **Input Separation**: Memisahkan kontrol sentuh (dual touch joystick di mobile) dengan arsitektur keyboard & mouse presisi tinggi di PC (WASD + Mouse Aiming 360°).
3. **Server-Authoritative Architecture**: Tetap mempertahankan Express + TypeScript di backend, dengan pemisahan kontrak jaringan (`packages/protocol`) dan data permainan (`packages/game-data`) berbasis JSON/JSON Schema agar dapat dikonsumsi bersama oleh TypeScript (Mobile & Server) dan GDScript (Godot PC).
4. **Preservasi Aset & Logika**: Klien mobile React Native Expo dan backend Express yang sudah berjalan tetap dipertahankan 100% tanpa regresi.

---

## 2. Inventarisasi Kondisi Repositori Terkini

### A. Fitur yang Sudah Benar-Benar Berfungsi (Verified Working)
| Komponen | Status | Bukti / File |
| :--- | :--- | :--- |
| **Express Backend Baseline** | Berfungsi | `apps/server/src/app.ts` (`GET /api/v1/health`, helmet, CORS, centralized error handling, unit/integration tests). |
| **Shared Physics & Math Library** | Berfungsi | `packages/shared/src/physics/math.ts` (`calculateDistance`, `checkCircleCollision`, `clampToArena`, `normalizeVector`). Teruji 10/10 test Jest lulus. |
| **Mobile Client (React Native Expo)** | Berfungsi | `apps/mobile/App.tsx`, SDK 52 (18/18 checks passed pada `expo-doctor`). |
| **Mobile Solo Practice Arena** | Berfungsi | `apps/mobile/src/game/SoloPracticeArena.tsx` (60 FPS loop, touch dual joystick via `PanResponder`, collision, damage, ammo, reset). |
| **Monorepo Tooling & CI** | Berfungsi | Root `package.json`, TypeScript strict, ESLint 8 (`npm run lint`), lockfile terpadu. |

### B. Fitur yang Masih Berupa Prototipe
- **Simulasi Game Loop**: Saat ini simulasi combat berjalan secara lokal di client mobile (`requestAnimationFrame`). Belum ada tick loop dedicated di backend.
- **Bot Behavior**: Dummy bot di mobile masih bergerak secara linear bouncing (pantulan koordinat dinding sederhana), belum menggunakan *Finite State Machine* (FSM) yang cerdas.

### C. Fitur yang Baru Direncanakan (Roadmap PC)
- **PC Native Client**: Proyek Godot 4.x di `apps/pc-client/`.
- **Sistem Kontrol Keyboard & Mouse**: WASD movement, crosshair mouse aiming, sprint, reload, custom keybindings.
- **Kamera 2D Dinamis**: Camera2D dengan smooth follow, look-ahead mouse offset, dan arena bounding limits.
- **Bot AI FSM Tingkat Lanjut**: State Machine (Patrol, Detect, Chase, Aim, Attack, Evade, Take Damage).
- **Audio & Visual Effects**: Sound effect tembakan, ledakan, hit feedback, muzzle flash, damage numbers, dan background music.
- **Shared Data & Protocol**: `packages/game-data` (JSON) dan `packages/protocol` (JSON Schema) untuk sinkronisasi multiplayer.

### D. Kode yang Dapat Digunakan Kembali (Reusable)
1. **Aturan Fisika & Matematika**: Konsep circle-collision, bounding box clamp, dan kalkulasi jarak di `packages/shared/src/physics/math.ts` dapat diimplementasikan 1:1 di GDScript.
2. **Parameter Gameplay**: Ukuran hitbox karakter (radius 16-18px), kecepatan peluru (9 unit/tick), damage peluru (20 HP), HP maksimal pemain (100 HP).
3. **Backend Server Foundation**: Server Express yang sudah ada akan tetap digunakan dan diperluas dengan WebSocket/Socket.IO gateway di Phase 5.

### E. Kode yang Perlu Direfaktor
- Pemisahan konstanta gameplay dan schema dari TypeScript-only ke format agnostik (JSON & JSON Schema) agar GDScript tidak perlu mengurai file `.ts`.

### F. Kode Khusus untuk PC
- Node tree scene Godot (`.tscn`), script GDScript (`.gd`), project settings (`project.godot`), shader/material canvas 2D, dan export template Windows (`.exe`).

### G. Dependency & Status Kualitas Codebase
- **TypeScript**: 0 error (`npm run typecheck` lulus).
- **ESLint**: 0 error, 0 warning (`npm run lint` lulus).
- **Backend/Shared Tests**: 10/10 test lulus (`npm test`).
- **Expo Doctor**: 18/18 checks passed.
- **Host Toolchain**: Node.js `v24.20.0`, npm `11.19.0`, Godot Engine `4.7.2.stable.official` terpasang di path pengguna.

---

## 3. Rencana Eksekusi Phase 1

1. **Inisialisasi Project Godot 4.x** di `apps/pc-client/project.godot`:
   - Konfigurasi resolusi 1280x720 (resizable, keep_height aspect).
   - Renderer 2D compatibility / forward+.
   - Setup Action Input Map (W, A, S, D, Mouse, LMB, R, Shift, Space, ESC, 1, 2, 3).
2. **Penyusunan Paket Agnostik**:
   - `packages/game-data/`: JSON konfigurasi karakter, senjata, dan arena.
   - `packages/protocol/`: JSON Schema kontrak state dan komunikasi.
3. **Implementasi Scene & Script Godot**:
   - `scenes/main/main.tscn`: Root game manager & scene switching.
   - `scenes/menu/main_menu.tscn`: Tampilan menu utama (Play Solo, Settings, Exit).
   - `scenes/arena/arena.tscn`: Arena pertempuran dengan dinding fisik (StaticBody2D).
   - `scenes/player/player.tscn`: Karakter pemain (CharacterBody2D) + Camera2D smoothing + rotasi hadap mouse.
   - `scenes/ui/hud.tscn`: HUD overlay minimalis (HP, ammo, timer, crosshair).
4. **Verifikasi Headless & Test**:
   - Validasi struktur file Godot via Godot console CLI `--check-only` atau `--headless`.
   - Menjalankan seluruh test suite monorepo untuk memastikan nol regresi.

