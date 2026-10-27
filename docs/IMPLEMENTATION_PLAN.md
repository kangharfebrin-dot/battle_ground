# Rencana Implementasi

Status: draft; bukan bukti bahwa fase atau fitur sudah selesai.

## Fase 1 — Audit
Periksa struktur, git status, manifests/lockfiles, Expo config, Express entrypoint/routes, database, tests, CI, build dan deployment. Catat temuan dengan bukti. Jangan ubah kode pada audit awal.

## Fase 2 — Product decisions
Konfirmasi genre, core loop, platform/perangkat, mode online/offline, kontrol, kondisi menang/kalah, performa, akun, persistence dan fitur prioritas. Perbarui TBD setelah keputusan disetujui.

## Fase 3 — Technical baseline
Cocokkan arsitektur target dengan implementasi aktual. Putuskan database, auth, networking/realtime, hosting, analytics dan monitoring hanya jika dibutuhkan. Buat migration/API plan bila relevan.

## Fase 4 — Vertical slice
Untuk tiap fitur: requirement → data/API design → client/UI → backend → test → review → dokumentasi. Implementasi bertahap dengan verifikasi end-to-end.

## Fase 5 — Hardening/release
Regression testing, security review, performance profiling, device testing, build verification, smoke test dan rollback plan. Catat risiko dan limitation.

## Definition of Done
Acceptance criteria disetujui, arsitektur diikuti, tes relevan dijalankan dengan hasil tercatat, tidak ada secret/data bocor, dokumentasi diperbarui, dan risiko tersisa dilaporkan.

Urutan akhir dapat berubah setelah audit memperlihatkan kondisi aktual repo.