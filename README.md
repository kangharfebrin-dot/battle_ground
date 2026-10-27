# Battle Ground Mobile Game — Documentation Pack

> **Status: DRAFT / IMPLEMENTATION NOT AUDITED**
>
> Dokumen ini disusun berdasarkan informasi yang diberikan: aplikasi game mobile bertema “Battle Ground”, klien React Native Expo, dan backend Express. Repository/source code aktual belum tersedia di sesi penyusunan ini. Karena itu, dokumen ini tidak mengklaim bahwa folder, endpoint, database, fitur, library realtime, atau pipeline deployment tertentu sudah ada.

## Tujuan

Paket ini menjadi titik awal dokumentasi untuk membantu AI agent mengembangkan aplikasi secara konsisten. Bagian yang belum diketahui sengaja ditandai `TBD`, `Belum diverifikasi`, atau `Usulan`, bukan diisi dengan hasil rekaan.

## Dokumen utama

- `PRD.md` — sasaran produk, kebutuhan, batasan, dan keputusan produk yang masih terbuka.
- `AGENTS.md` — instruksi persisten untuk AI agent.
- `docs/AUDIT_REPORT.md` — batas audit dan temuan yang benar-benar bisa dikonfirmasi.
- `docs/ARCHITECTURE.md` — batas teknologi yang diketahui dan arsitektur yang perlu diverifikasi.
- `docs/DATABASE.md` — status bukti schema database; tidak mengarang tabel.
- `docs/API.md` — status kontrak API; tidak mengarang route.
- `docs/UI_UX.md` — prinsip UI/UX untuk klien game mobile.
- `docs/BUSINESS_RULES.md` — keputusan gameplay dan ekonomi yang belum ditetapkan.
- `docs/SECURITY.md` — prinsip keamanan untuk mobile client dan backend.
- `docs/TESTING.md` — strategi tes tanpa mengarang perintah package manager.
- `docs/DEPLOYMENT.md` — checklist deployment, bukan klaim hosting saat ini.
- `docs/IMPLEMENTATION_PLAN.md` — urutan kerja yang disarankan.
- `docs/PROGRESS.md` — status dokumentasi dan audit.
- `CHANGELOG.md` — perubahan dokumentasi.
- `.agents/rules/` — aturan kontekstual Antigravity.
- `.agents/skills/` — prosedur kerja yang dapat dipakai ulang oleh agent.

## Cara menggunakan paket

1. Paket ini ditempatkan di root repository game. Tinjau konflik jika ada file yang sudah ada.
2. Jalankan audit awal sesuai `docs/AUDIT_REPORT.md` dan Skill `audit-existing-project`.
3. Perbarui dokumen dengan bukti dari source code, `package.json`, konfigurasi Expo, server entrypoint, route, model/schema database, test, dan workflow CI yang benar-benar ada.
4. Konfirmasi keputusan produk yang ditulis sebagai `TBD` di `PRD.md` dan `docs/BUSINESS_RULES.md`.
5. Implementasi fitur hanya dimulai setelah dokumen tidak lagi bertentangan dengan kebutuhan yang disepakati.

## Environment variables

`.env.example` **belum dibuat** karena file konfigurasi dan nama environment variable aktual belum diaudit. Jangan menambahkan nama variabel yang belum dipakai kode. Setelah audit, buat `.env.example` berisi nama variabel yang benar-benar digunakan dan hanya nilai placeholder; jangan pernah memasukkan secret asli.

## Aturan kejujuran dokumentasi

- Bedakan **Fakta hasil pemeriksaan**, **Kebutuhan yang disepakati**, **Usulan arsitektur**, dan **Pertanyaan terbuka**.
- Jangan mencatat endpoint, tabel, fitur, status implementasi, atau perintah build sebagai fakta sebelum diverifikasi.
- Setiap klaim “lulus tes” harus memiliki bukti perintah yang dijalankan dan hasilnya.
- Paket ini hanya berisi dokumentasi dan aturan agent. Source code aplikasi tidak dibuat atau diubah oleh proses penyusunan paket ini.
