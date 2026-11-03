# Rencana Implementasi & Roadmap Battle Ground PC

Dokumen ini memetakan tahapan evolusi transformasi Battle Ground dari aplikasi mobile awal menjadi game PC native 2D tactical arena shooter.

## 1. Ikhtisar Tahapan (Roadmap Overview)

```mermaid
gantt
    title Roadmap Pengembangan Battle Ground PC
    dateFormat  YYYY-MM-DD
    section Fase 1: Fondasi Native PC
    Audit & Struktur Monorepo        :done, f1_1, 2026-11-01, 2026-11-02
    Setup Project Godot 4.x         :done, f1_2, 2026-11-02, 2026-11-03
    Scene Menu, Arena & Player      :done, f1_3, 2026-11-03, 2026-11-03
    Combat, Dummy & Telemetri HUD   :done, f1_4, 2026-11-03, 2026-11-03
    Validasi Headless & Dokumen     :done, f1_5, 2026-11-03, 2026-11-03

    section Fase 2: Realtime Multiplayer
    WebSocket Network Client        :active, f2_1, 2026-11-04, 2026-11-08
    Sinkronisasi Server-Otoritatif  :f2_2, 2026-11-08, 2026-11-14
    Lobby & Matchmaking Room        :f2_3, 2026-11-14, 2026-11-20

    section Fase 3: Visual & Audio Polish
    Aset Sprite 2D & Partikel VFX   :f3_1, 2026-11-21, 2026-11-28
    Soundtrack & Efek Suara WAV     :f3_2, 2026-11-28, 2026-12-05
    Screen Shake & Combat Juice     :f3_3, 2026-12-05, 2026-12-10

    section Fase 4: Distribusi & Rilis
    Ekspor Windows, Linux, macOS    :f4_1, 2026-12-11, 2026-12-18
    Integrasi Steam / Desktop Hub   :f4_2, 2026-12-18, 2026-12-25
```

## 2. Rincian Pekerjaan Setiap Fase

### Fase 1: Fondasi Offline Playable PC (STATUS: SELESAI / COMPLETED)
- [x] Audit komprehensif monorepo, backend, mobile client, dan shared packages (`docs/PC_MIGRATION_AUDIT.md`).
- [x] Standardisasi package data agnostik: `packages/game-data` (JSON) dan `packages/protocol` (JSON Schema).
- [x] Inisialisasi project Godot 4.7.2 (`apps/pc-client/project.godot`) dengan renderer GL Compatibility.
- [x] Konfigurasi Input Map untuk kontrol PC (WASD, Mouse Aim 360°, Space Dash, Shift Sprint, 1-3 Weapon Switch, ESC Pause).
- [x] Implementasi autoload: `GameDataLoader`, `SettingsManager`, `AudioManager`.
- [x] Scene `Player` (`CharacterBody2D`) dengan pergerakan, dash, rotasi mouse, dan kamera halus (`Camera2D`).
- [x] Sistem senjata: Pistol, Shotgun, Assault Rifle dengan reload otomatis dan manual.
- [x] Dinding pembatas arena (`StaticBody2D`) dan rintangan balok taktis (`arena_bounds.gd`).
- [x] Target dummy latihan dengan deteksi tabrakan proyektil dan respawn berkala.
- [x] Antarmuka HUD telemetri tempur: HP Bar, Ammo Clip, Nama Senjata, Timer 5 menit, dan Skor eliminasi.
- [x] Pause Menu overlay (`process_mode = ALWAYS`) untuk Resume, Restart, dan Keluar.
- [x] Main Menu dengan judul, opsi Play Solo Practice, Settings dialog, dan Quit.
- [x] Skrip uji headless smoke test (`apps/pc-client/tests/test_headless_smoke.gd`) terverifikasi 4/4 PASS.

### Fase 2: Realtime Multiplayer & Integrasi Server
- [ ] Implementasi modul `network_client.gd` berbasis `WebSocketPeer` di `apps/pc-client/scripts/networking/`.
- [ ] Endpoint room dan WebSocket gateway di `apps/server/src/`.
- [ ] Implementasi loop simulasi game di server (server-authoritative game loop 30 Hz).
- [ ] Sinkronisasi state via `player-input.schema.json` dan `game-state.schema.json`.
- [ ] Rekonsiliasi prediksi klien untuk meminimalkan persepsi latensi.
- [ ] Antarmuka lobby room untuk join match via kode room atau quick match.

### Fase 3: Visual Polish & Asset Pipeline
- [ ] Penggantian rendering prosedural dengan sheet sprite profesional (karakter militer/cyber, senjata kustom).
- [ ] Efek partikel moncong senjata (muzzle flash), asap reload, dan percikan benturan peluru (sparks).
- [ ] Efek feedback pertempuran: Dynamic screen shake saat menembakkan shotgun atau menerima damage.
- [ ] Impor file audio berkualitas tinggi (.wav untuk SFX, .ogg untuk musik ambient arena tegang).
- [ ] Desain font bitmap/vektor kustom untuk HUD arcade modern.

### Fase 4: Build, Optimasi & Rilis Multi-Platform
- [ ] Ekspor biner Windows Desktop (`.exe` mandiri dengan ikon dan metadata versi).
- [ ] Ekspor dan pengujian native Linux (Ubuntu/Debian x86_64).
- [ ] Ekspor dan pengujian native macOS (Universal binary ARM64/x86_64).
- [ ] Integrasi antarmuka pemetaan ulang tombol keyboard (key remapping UI) di Settings.
- [ ] Validasi keamanan & batas kecepatan paket jaringan untuk mencegah manipulasi kecepatan (speed-hack).

