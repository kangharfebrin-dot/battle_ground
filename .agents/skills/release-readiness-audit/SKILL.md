---
name: release-readiness-audit
description: Periksa kesiapan rilis mobile client dan Express backend.
---

# Release Readiness Audit

## Prosedur
1. Baca AGENTS.md, PRD.md, SECURITY.md, TESTING.md dan DEPLOYMENT.md.
2. Periksa git status/branch, versions, manifests, lockfiles, config dan perubahan belum tercatat.
3. Jalankan tests, lint, typecheck dan build commands yang memang ada. Jangan menebak command.
4. Periksa mobile build config, API URL, permissions, assets, signing dan secret storage.
5. Periksa Express startup, health check, authorization, rate limits jika ada, error handling, migrations/backup dan logs.
6. Uji critical flow dan failure cases sesuai requirement.
7. Review API/schema compatibility, observability, rollback, privacy dan secret exposure.
8. Jangan deploy, publish, commit, push, ubah secret atau jalankan migration produksi tanpa izin.
9. Pisahkan blocker, high risk, minor issue dan rekomendasi.

## Output
Berikan keputusan ready/conditionally ready/not ready dengan alasan; temuan berbukti, severity dan reproduksi; tests/build yang benar-benar dijalankan; blocker; serta risiko dan persetujuan yang masih diperlukan.