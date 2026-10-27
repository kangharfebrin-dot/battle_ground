# Aturan Bisnis dan Gameplay

Status: aturan gameplay belum dikonfirmasi. Ini daftar keputusan, bukan spesifikasi final.

## Keputusan inti
Tetapkan genre, core loop, mode permainan, kondisi menang/kalah, pause/resume, game over dan flow pascapertandingan sebelum implementasi fitur utama.

## Lifecycle
Jika sesuai, definisikan state dan transisi seperti idle, matchmaking, ready, in-progress, paused, completed, cancelled dan disconnected. Jangan pakai state yang tidak diperlukan.

## Multiplayer
Jika dipilih, tetapkan jumlah pemain, team rules, server authority, join/leave, disconnect/reconnect, timeout, late join, hasil pertandingan dan penanganan abuse. Client bukan sumber kebenaran tunggal untuk hasil kompetitif.

## Progression/economy
Akun, XP, level, inventory, reward, currency, shop, ranking, monetisasi dan retensi belum diputuskan. Untuk setiap fitur yang disetujui dokumentasikan validasi, batas nilai, ownership, transaksi/idempotency dan edge cases.

## Format aturan
Setiap rule punya ID, trigger/precondition, aktor, state transition, authoritative source, failure behavior, idempotency, contoh dan tests.

| ID | Keputusan | Status |
|---|---|---|
| BR-001 | Genre dan core loop | TBD |
| BR-002 | Online/offline mode | TBD |
| BR-003 | Kondisi menang/kalah | TBD |
| BR-004 | Persistence progress | TBD |

Jangan mengisi TBD dengan asumsi agent tanpa persetujuan pemilik produk.