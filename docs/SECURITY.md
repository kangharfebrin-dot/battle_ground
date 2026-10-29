# Keamanan Mobile Client dan Backend

Status: Diperbarui & Diterapkan pada Fondasi Monorepo (2026-10-29).

## 1. Prinsip Keamanan Utama

1. **Zero Trust pada Client Input**:
   - Seluruh input dan payload dari mobile client dianggap tidak tepercaya.
   - Skor, damage, eliminasi, dan validasi pergerakan tidak boleh dipercayakan kepada client.
2. **Pencegahan Kebocoran Secret**:
   - Dilarang menaruh database credential, private key, secret tokens, atau API admin keys pada bundle Expo mobile.
   - Variabel `EXPO_PUBLIC_*` hanya digunakan untuk endpoint publik (misalnya URL backend publik).
3. **Penyembunyian Detail Internal (No Stack Leak)**:
   - Server tidak mengekspos stack trace atau error internal pada response HTTP (terutama saat `NODE_ENV=production`).
4. **Sanitasi Logging**:
   - Dilarang mencetak password, token, header Authorization, atau data personal (PII) ke console/log server.

---

## 2. Kontrol Keamanan yang Telah Diterapkan (Fase Fondasi)

- **Helmet**: Dipasang pada middleware Express untuk menyetel security headers HTTP standar (XSS filter, noSniff, frameguard, dll.).
- **CORS Terkendali**: Middleware CORS dikonfigurasi melalui variabel environment `CORS_ORIGIN` (bukan hardcoded).
- **Body Parser Payload Limit**: `express.json({ limit: '10kb' })` membatasi ukuran request body untuk mencegah serangan Denial of Service berbasis memory exhaustion.
- **Validasi Port & Environment**: Saat server start, konfigurasi divalidasi oleh `loadConfig()` untuk mencegah miskonfigurasi runtime.
- **Centralized Error Handler**: Seluruh exception yang tidak tertangani ditangkap dan diformat menjadi pesan JSON aman (`500 Internal Server Error`).

---

## 3. Kontrol Keamanan Tahap Selanjutnya (TBD)

- **Rate Limiting**: Penerapan rate limiter (seperti `express-rate-limit`) pada route publik.
- **Otentikasi & Otorisasi**: Verifikasi token JWT / Bearer pada endpoint mutasi privat.
- **WebSocket Handshake Validation**: Validasi token dan rate limit event per socket connection.
