# Product Requirements Document — Battle Ground Mobile Game

- Status: DRAFT, menunggu keputusan produk dan audit implementasi.
- Mobile: React Native Expo (sesuai permintaan).
- Backend: Express (sesuai permintaan).
- Genre dan mode game: belum dikonfirmasi.

## Ringkasan
Produk yang direncanakan adalah game mobile dengan nama kerja Battle Ground. Istilah tersebut tidak otomatis berarti battle royale, shooter, atau multiplayer realtime. Game loop, target pemain, platform, online/offline, dan model bisnis belum diketahui.

## Tujuan awal
- Pengalaman mobile yang stabil pada perangkat sasaran.
- Batas tanggung jawab client dan backend yang jelas.
- Codebase yang bisa diuji, dipelihara, dan dikembangkan AI agent secara konsisten.

## Platform dan pengguna
Target usia, Android/iOS, versi OS minimum, orientasi, bahasa, guest/account, offline support, controller, aksesibilitas, dan target performa: TBD.

## Scope
Stack yang diminta dan kebutuhan dokumentasi merupakan satu-satunya kebutuhan terkonfirmasi. Login, lobby, matchmaking, multiplayer realtime, map, karakter, senjata, inventory, ranking, chat/voice, clan, leaderboard, battle pass, iklan, in-app purchase, spectator, serta anti-cheat belum menjadi baseline sampai dikonfirmasi.

## Kebutuhan fungsional
Kebutuhan rinci menunggu game design yang disetujui. Tiap kebutuhan harus memiliki ID, aktor, prioritas, alur utama, precondition, alur gagal, acceptance criteria, dan test terkait.

| ID | Kebutuhan | Status |
|---|---|---|
| FR-001 | Ditentukan setelah genre dan core loop disepakati | TBD |

## Nonfunctional
- Validasi data tidak tepercaya di backend.
- Rahasia server tidak dimasukkan ke bundle mobile.
- Target FPS, startup, ukuran bundle, perangkat minimum, dan reliability ditetapkan lalu diukur.
- Data pemain dikumpulkan seminimal mungkin, dengan aturan akses, retensi, serta penghapusan yang jelas.

## Keputusan terbuka
1. Genre dan core gameplay loop?
2. Single-player, offline, online asynchronous atau realtime multiplayer?
3. Jumlah pemain per match dan kondisi menang/kalah?
4. Akun, progress, inventory, leaderboard atau economy dibutuhkan?
5. Platform, perangkat minimum, orientasi, dan target FPS?
6. Database, autentikasi, hosting, monetisasi, analytics dan monitoring?
7. Target usia, bahasa, wilayah serta batasan privasi/konten?

Dokumen tetap draft sampai keputusan di atas disepakati. Perubahan harus mencatat dampak UI, API, data, keamanan, test, dan rilis.