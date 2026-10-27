# Build, Deployment, dan Release

Status pipeline dan hosting belum diketahui. Dokumen ini adalah checklist untuk disesuaikan setelah audit.

## Mobile
- Verifikasi Expo SDK, app config, package manager, scripts, native plugins, asset dan permissions.
- Identifikasi proses build yang sudah digunakan.
- Pisahkan config development, preview/staging dan production.
- Validasi API base URL serta konfigurasi non-secret di tiap environment.
- Simpan signing credentials dan token pada secret store; jangan masukkan ke repo.
- Uji instalasi, cold start, jaringan, lifecycle, permissions dan flow penting pada device target.
- Catat versioning, release notes dan rollback/distribution process.

## Express backend
- Verifikasi runtime version, start script, port binding, health check dan storage.
- Konfigurasikan secret melalui runtime environment.
- Pastikan HTTPS/proxy configuration benar bila digunakan.
- Validasi migration, backup dan restore sebelum perubahan schema.
- Siapkan log, monitoring, graceful shutdown dan rollback.
- Gunakan least privilege untuk database dan layanan eksternal.

## Release checklist
Tests/lint/typecheck/build yang relevan telah dijalankan; variable terdokumentasi tanpa secret; tidak ada credential di commit/artifact; API compatibility/migrations/rollback/privacy/observability diperiksa; smoke test dilakukan pada build yang akan dirilis.

## TBD
Hosting backend, database, domain, CI/CD, Expo/EAS workflow, signing/distribution Android/iOS, monitoring dan backup provider. Jangan menebak layanan atau command deployment.