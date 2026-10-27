---
name: implement-gameplay-feature
description: Implementasikan fitur gameplay yang sudah memiliki requirement dan acceptance criteria.
---

# Implement Gameplay Feature

## Sebelum coding
1. Baca AGENTS.md, PRD.md, BUSINESS_RULES.md, ARCHITECTURE.md, API.md, DATABASE.md dan TESTING.md yang relevan.
2. Pastikan requirement, precondition, state transition, failure path dan acceptance criteria jelas.
3. Periksa code pattern aktual serta file yang akan tersentuh.
4. Jika keputusan game design penting belum ada atau bertentangan, hentikan implementasi dan laporkan keputusan yang dibutuhkan.

## Implementasi
1. Pertahankan arsitektur dan dependencies aktual tanpa keputusan yang disetujui.
2. Pisahkan UI, game logic, networking dan persistence sesuai struktur yang ada.
3. Validasi input tidak tepercaya di server.
4. Untuk hasil kompetitif/economy, pastikan client bukan sumber kebenaran tunggal jika online multiplayer dipilih.
5. Tangani loading, error, reconnect, duplicate requests, lifecycle dan edge cases yang relevan.
6. Jangan ubah file/behavior di luar scope tanpa alasan.

## Verifikasi
Tambahkan/update tests, jalankan command aktual, review diff untuk perubahan tidak sengaja dan secret, serta perbarui docs terkait.

## Laporan
Jelaskan behavior, file berubah, keputusan, tests dan hasil aktual, limitations dan remaining work.