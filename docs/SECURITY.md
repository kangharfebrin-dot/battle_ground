# Keamanan Mobile Client dan Backend

Status: baseline rekomendasi; audit source code belum dilakukan.

## Prinsip
- Anggap semua input dari mobile client tidak tepercaya.
- Validasi request di backend dan otorisasi setiap akses resource privat/mutasi.
- Jangan menaruh server secret, private key, database credential atau token permanen di bundle Expo.
- Gunakan HTTPS di lingkungan non-local.
- Jangan kirim stack trace atau detail internal pada response produksi.
- Jangan log password, token, secret atau data personal yang tidak dibutuhkan.

## Auth/session
Jika akun digunakan, dokumentasikan strategy auth, expiry, refresh/revocation, secure local storage, logout, pemulihan akun dan brute-force protection. Jangan mengasumsikan provider/library sebelum audit.

## Game integrity
Jika skor, reward, inventory, saldo atau ranking kompetitif berlaku, validasi perubahan sensitif di server. Pertimbangkan replay, race condition, idempotency, rate limits dan audit trail.

## Privacy
Kumpulkan data seperlunya. Tentukan tujuan, akses, retensi, backup dan penghapusan. Jangan memasukkan token/data personal ke log, telemetry, screenshot atau dokumentasi.

## Runtime hardening
Audit CORS, rate limit, body limits, validation, security headers, dependency advisories, upload handling jika ada, database permissions, error handling, logging dan graceful shutdown.

## Secret management
Simpan secret pada environment runtime/secret store. .env.example hanya memuat nama variabel aktual dan placeholder. Jika credential pernah terpublikasi, rencanakan rotasi melalui proses terotorisasi.

## Incident response
Dokumentasikan identifikasi dampak, pencabutan credential, pemulihan layanan, preservasi bukti dan laporan insiden. Jangan mengubah produksi tanpa otorisasi.