# Arsitektur Sistem

Status: draft konseptual, perlu dicocokkan dengan repo aktual.

## Fakta
Stack yang diminta adalah React Native Expo dan Express. Monorepo/dua repo, JS/TS, protokol, database, ORM, layanan eksternal, autentikasi, realtime dan hosting belum diketahui.

## Alur tingkat tinggi
Mobile client (React Native Expo) berkomunikasi dengan Express melalui protokol yang belum diverifikasi. Persistence dan layanan eksternal hanya dimasukkan jika dibutuhkan dan ditemukan/disetujui.

## Audit mobile
Telusuri entrypoint, navigation, screens, reusable components, asset pipeline, state, local storage, app lifecycle, Expo config, native modules, permissions dan API client. Jangan menambahkan library sebelum memeriksa yang sudah digunakan.

## Audit backend
Periksa entrypoint, registered routers, middleware, validation, auth, authorization, CORS, rate limiting, service/repository jika ada, database initialization, error handler, logging, health check dan graceful shutdown.

## Realtime/game state
Realtime belum dikonfirmasi. Jika game real-time multiplayer, desain protokol, server authority, update rate, ordering, latency budget, reconnect, state resync dan validasi aksi sebelum memilih teknologi. Jangan mengasumsikan WebSocket atau Socket.IO tersedia.

## Prinsip desain
- UI menangani input dan presentasi state.
- Server memvalidasi request dan aturan yang memengaruhi integritas hasil.
- Data kompetitif tidak boleh bergantung pada klaim client saja.
- API dan pesan harus terversi, konsisten, serta diuji.
- Minimalkan data pribadi dan batasi akses.

## Keputusan terbuka
| Keputusan | Status | Dampak |
|---|---|---|
| Monorepo atau repo terpisah | TBD | Workspace dan CI |
| JavaScript atau TypeScript | TBD | Type safety dan tooling |
| REST, realtime atau campuran | TBD | Kontrak jaringan |
| Database/ORM | TBD | Persistence dan migration |
| Model simulasi game | TBD | Fairness dan latency |
| Auth/session | TBD | Identitas dan akses |
| Observability/hosting | TBD | Operasi produksi |

Keputusan arsitektur besar dicatat dengan konteks, pilihan, keputusan, konsekuensi dan tanggal.