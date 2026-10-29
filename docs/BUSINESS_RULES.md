# Aturan Bisnis dan Gameplay

Status: Baseline Terkonfirmasi (Disepakati 2026-10-28 / 2026-10-29).

## 1. Aturan Inti Gameplay

- **Genre**: Top-Down Arena Shooter 2D.
- **Sistem Kontrol**: Dual Virtual Joystick:
  - **Joystick Kiri (Translasi)**: Menentukan arah pergerakan pemain (360 derajat) dan magnitudo kecepatan hingga `max_speed`.
  - **Joystick Kanan (Aim & Shoot)**: Menentukan orientasi bidikan proyektil (sudut derajat/radian). Pelepasan joystick atau penarikan melebihi ambang batas (*deadzone threshold*) memicu tembakan peluru (*firing rate cooldown*).
- **Mode Permainan**:
  1. **Realtime Synchronous Multiplayer**: Pertandingan bersama pemain lain di dalam arena room terpusat.
  2. **Solo Practice**: Mode latihan mandiri (offline atau bot match) untuk menguji responsivitas joystick, manuver gerak, dan bidikan.
- **Kondisi Kalah**: HP pemain mencapai 0 (Eliminasi).
- **Kondisi Menang**: Menjadi pemain terakhir yang bertahan (*Last Man Standing*) atau mengumpulkan skor eliminasi tertinggi ketika batas waktu match berakhir.
- **Arena Boundaries**: Arena memiliki batas dinding fisik persegi/poligon tertutup. Karakter dan proyektil tidak diizinkan menembus batas koordinat arena (`clamped to arena bounding box`).

---

## 2. Siklus Pertandingan (Match Lifecycle)

State pertandingan diatur dengan transisi linier:

```text
[LOBBY / MODE_SELECT] -> [MATCH_COUNTDOWN] -> [IN_PROGRESS] -> [MATCH_ENDED] -> [SUMMARY_VALIDATED]
```

1. **LOBBY / MODE_SELECT**: Pemain memilih mode (Multiplayer / Solo Practice) dan masuk ke antrean room.
2. **MATCH_COUNTDOWN**: 3 detik jeda persiapan sebelum pergerakan dan penembakan diizinkan.
3. **IN_PROGRESS**: Server mengolah input vektor joystick, mensimulasikan gerak, menghitung benturan proyektil, dan mendistribusikan snapshot ke seluruh klien.
4. **MATCH_ENDED**: Terpicu seketika sisa pemain bertahan = 1 atau timer pertandingan habis.
5. **SUMMARY_VALIDATED**: Server menghitung skor eliminasi akhir, mencatat status kemenangan, dan menyajikan ringkasan pertandingan.

---

## 3. Otoritas Server & Integritas Kompetitif (Server-Authoritative)

- **Input Klien yang Diterima Server**:
  - Klien HANYA mengirimkan vektor pergerakan joystick (`dx, dy`) dan trigger bidik/tembak (`aimAngle, fireTrigger, clientTimestamp`).
- **Validasi Server-Side**:
  - Server memvalidasi kecepatan maksimal karakter (mencegah manipulasi pergerakan/speedhack).
  - Server menghitung posisi peluru dan deteksi benturan hitbox (*raycasting / circle-collision*).
  - Server mendeteksi deduksi HP, pengurangan ammo, dan konfirmasi eliminasi.
- **Client Prediction & Interpolation**:
  - Mobile client diizinkan menerapkan *client prediction* lokal untuk posisi pemainnya sendiri dan *linear interpolation (lerp)* untuk entitas lawan agar animasi di layar Expo tetap halus pada target 60 FPS.

---

## 4. Matriks Aturan Terkonfirmasi

| ID | Aturan Bisnis / Gameplay | Authoritative Source | Status |
| --- | --- | --- | --- |
| BR-001 | Genre Top-Down Arena Shooter 2D | PRD & Game Design | Terkonfirmasi |
| BR-002 | Dual Virtual Joystick Controls (Move & Aim/Shoot) | Client Touch Engine | Terkonfirmasi |
| BR-003 | Mode Multiplayer Synchronous & Solo Practice | PRD & Room Gateway | Terkonfirmasi |
| BR-004 | Server-Authoritative State, Damage, HP & Score | Server Combat Engine | Terkonfirmasi |
| BR-005 | Kondisi Menang/Kalah (HP=0 & Timer Expire) | Match Lifecycle | Terkonfirmasi |
| BR-006 | Zero Trust Client Data (No Client Score Claim) | Backend Security | Terkonfirmasi |
