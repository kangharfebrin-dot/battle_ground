# Database dan Model Data

Status: Terverifikasi Greenfield (Fase Inisialisasi Fondasi Monorepo 2026-10-29).

## 1. Fakta Terverifikasi

- **Kondisi Aktual**: Belum ada database engine, ORM, schema migration, seeder, atau model data yang diimplementasikan pada fase ini.
- **Tabel / Koleksi**: Tidak ada tabel atau relasi aktif di codebase saat ini.
- **Environment Variables Database**: Belum digunakan pada implementasi fase inisialisasi awal.

## 2. Kebutuhan Data & Domain (Menunggu Tahap Persistensi)

Model data direncanakan untuk tahap berikutnya guna mendukung:
- **Profil Pemain**: ID akun / Guest UUID, display name, tanggal registrasi.
- **Riwayat Pertandingan (Match History)**: Match ID, mode (Multiplayer / Solo Practice), skor, jumlah eliminasi, durasi bertahan, timestamp.
- **Leaderboard**: Peringkat pemain berdasarkan akumulasi skor kemenangan.

## 3. Rekomendasi Teknologi & Strategi Migrasi

- **ORM / Query Builder**: Disarankan menggunakan Prisma atau Drizzle ORM dengan TypeScript untuk deklarasi skema tipe-aman (*type-safe*).
- **Database Engine**:
  - Development / Testing: SQLite (portabel, cepat, tanpa overhead setup lokal).
  - Production: PostgreSQL (mendukung concurrent connections dan transaksi reliabel).
- **Integritas & Aturan Keamanan Database**:
  - Dilarang keras melakukan perintah destruktif (`DROP TABLE`, `TRUNCATE`) tanpa izin eksplisit.
  - Credential database hanya boleh dibaca dari server environment variables; dilarang keras dimasukkan ke bundle mobile client.

## 4. Status Keputusan

| Domain Entitas | Kebutuhan | Status |
| --- | --- | --- |
| Player Account | Profil pemain & Guest UUID | TBD (Tahap Persistensi) |
| Match / Combat | Riwayat hasil match & skor akhir | TBD (Tahap Persistensi) |
| Leaderboard | Papan peringkat global | TBD (Tahap Persistensi) |
