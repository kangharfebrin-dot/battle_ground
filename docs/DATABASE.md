# Database dan Model Data

Status schema aktual: belum diverifikasi. Tidak ada tabel, kolom, relasi atau engine database yang dinyatakan sebagai fakta.

## Prosedur audit
1. Cari migration, schema, model/entity, ORM config, query, repository, seeder dan database tests.
2. Identifikasi cara inisialisasi koneksi dan nama environment variables tanpa menampilkan nilainya.
3. Dokumentasikan primary/foreign key, constraints, indexes, nullability, defaults, cascade, timestamps dan soft delete jika ada.
4. Cocokkan model dengan query/route aktif; file model saja tidak membuktikan ia dipakai.
5. Catat strategi migration, backup, rollback, retensi dan penghapusan data berdasarkan bukti.
6. Jangan menjalankan reset/drop/truncate atau migration terhadap database bersama/produksi saat audit.

## Domain
Entitas seperti pemain, match, inventory, skor, reward, leaderboard, transaksi atau profil belum ditetapkan. Jangan mengarang tabel hanya karena lazim dalam game. Model diturunkan dari kebutuhan yang disetujui dan alur nyata.

## Format per entitas
Nama dan lokasi definisi; tujuan dan pemilik data; fields/types/nullability/default/constraints; key dan relasi; index dan alasan; migration/rollback; access/retention/deletion; tests.

## Integritas dan concurrency
Jika operasi dapat bersamaan, tentukan transaction, idempotency, conflict handling dan sumber kebenaran. Jangan mengandalkan urutan request client.

## Informasi yang dibutuhkan
Database/ORM aktual, migration/schema, query aktif, requirements persistence, retention/delete policy, serta consistency model untuk fitur online jika relevan.