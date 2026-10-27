---
trigger: always_on
---

# Mobile and Backend Security Rules

- Perlakukan semua data client sebagai input tidak tepercaya.
- Jangan menaruh secret server/database/private key/token permanen dalam bundle Expo.
- Verifikasi authorization server-side pada setiap resource privat dan mutasi.
- Validasi tipe, ukuran, format, rentang dan state pada boundary server.
- Jangan mempercayai skor/reward/hasil game dari client untuk konteks kompetitif tanpa validasi server.
- Jangan log password, token, secret atau data personal yang tidak dibutuhkan.
- Jangan memasukkan credential asli ke .env.example.
- Jangan mematikan validation/security control hanya untuk membuat error hilang.
- Audit dependency dan konfigurasi sebelum menyatakan sistem aman.
- Laporkan risiko dengan bukti file/baris, dampak dan mitigasi.