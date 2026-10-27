---
name: audit-existing-project
description: Audit repository Battle Ground sebelum implementasi atau refactor.
---

# Audit Existing Project

## Tujuan
Memahami implementasi aktual berbasis bukti tanpa mengubah aplikasi.

## Langkah
1. Baca AGENTS.md, PRD.md, README.md dan docs/AUDIT_REPORT.md.
2. Periksa git status; pertahankan semua perubahan pengguna.
3. Inventarisasi folder, manifests, lockfiles, runtime, scripts dan dependencies.
4. Audit Expo config, entrypoint, screens/navigation, state, assets, permissions, native modules dan API client.
5. Audit Express entrypoint, registered routes, middleware, validation, auth, persistence dan error handling.
6. Temukan schema/migration, tests, CI, build config dan deployment artifacts.
7. Sertakan bukti path/baris. Jalankan hanya command read-only atau tests yang aman.
8. Jangan tampilkan nilai secret; catat nama key dan lokasi saja.
9. Pisahkan fakta, risiko potensial, pertanyaan terbuka dan rekomendasi.
10. Perbarui docs/AUDIT_REPORT.md serta dokumen teknis berdasarkan bukti.

## Batasan
Jangan mengubah feature code, schema database, commit, push atau deploy dalam skill audit ini.

## Output
Stack dan struktur yang ditemukan; alur modul; API/database/tests/build yang diverifikasi; temuan severity-evidence-impact-recommendation; dokumen berubah; command dan hasil aktual; serta area yang belum diketahui.