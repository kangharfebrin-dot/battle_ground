# Instruksi Utama AI Agent

## Konteks
Baca PRD.md, README.md, docs/AUDIT_REPORT.md, dan dokumen relevan sebelum mengubah kode. Periksa instruksi repo yang sudah ada.

## Verifikasi
Audit struktur repo, package manifests, lockfiles, konfigurasi Expo, entrypoint Express, route, middleware, database, tests, dan CI yang benar-benar tersedia. Bedakan fakta, kebutuhan disepakati, usulan, dan TBD. Jangan mengarang fitur, endpoint, tabel, dependency, command, atau hasil test.

## Arsitektur
Stack yang diminta adalah React Native Expo dan Express. Struktur monorepo, bahasa JS/TS, database, ORM, autentikasi, realtime transport, dan hosting belum diverifikasi. Pertahankan arsitektur aktual dan jangan mengganti framework/menambah layanan utama tanpa alasan tertulis.

## Gameplay dan integritas
Jangan menetapkan mekanika hanya dari nama Battle Ground. Konfirmasi genre, game loop, jumlah pemain, kondisi menang/kalah, lifecycle match, dan online/offline. Jika multiplayer kompetitif dipilih, evaluasi otoritas server. Jangan menganggap matchmaking, realtime, inventory, ranking, chat, monetisasi atau anti-cheat tersedia tanpa bukti.

## Mobile/backend
Jangan menaruh secret server di aplikasi Expo atau konfigurasi yang masuk bundle klien. Validasi input pada server. Jangan mempercayai skor, reward atau hasil kompetitif dari klien tanpa validasi server-side jika relevan.

## Database, keamanan, kualitas
Baca schema/migration aktual sebelum mengubah model data. Jangan reset/drop/truncate database tanpa izin. Jangan menaruh secret di source, log, dokumentasi atau commit. Buat .env.example hanya setelah nama variabel yang benar-benar dipakai sudah diaudit. Temukan command test/lint/typecheck/build dari manifest; jangan mengklaim lolos jika tidak dijalankan.

## Batas tindakan
Jangan commit, push, deploy, mengubah secret, menghapus data, atau mengubah infrastruktur tanpa otorisasi yang jelas. Hindari refactor di luar scope dan pertahankan perubahan pengguna.

## Laporan
Laporkan file berubah, tes yang benar-benar dijalankan beserta hasil, risiko, keputusan terbuka, dan langkah selanjutnya. Perbarui dokumentasi saat keputusan atau behavior berubah.