# Strategi Testing dan Verifikasi

Status command dan hasil tes aktual belum diverifikasi.

## Sebelum testing
Identifikasi package manager, lockfiles, scripts dan workspace. Pastikan tes tidak menyasar database produksi atau menghapus data. Catat command dan hasil aktual; jangan mengklaim sukses tanpa bukti.

## Mobile
Rencanakan unit tests untuk logic, screen/component tests untuk flow penting, dan device/manual tests untuk layout, touch, navigation, lifecycle, permissions, network errors, loading dan offline jika didukung.

## Express
Uji validation, status/payload, auth/authorization, data boundaries, error handler, rate limit bila ada, dan concurrency/idempotency yang relevan. Isolasi database test dari data produksi.

## Game logic
Uji boundary values, state transitions, input ilegal, ordering, reconnect jika relevan, serta determinisme bila diperlukan. Pisahkan logic dari rendering jika sesuai dengan arsitektur.

## Integration dan E2E
Uji alur client-backend dengan environment test. Jika multiplayer, uji beberapa client, koneksi lambat/putus, reconnect, resync dan request manipulatif.

## Build/kualitas
Ambil command dari manifest aktual untuk tests, lint, typecheck dan build. Bila environment tidak tersedia, laporkan blocked-by-environment terpisah dari bug kode.

## Definition of Done
Acceptance criteria terpenuhi, tests relevan dijalankan, regression diketahui dicatat, secret tidak terekspos, dan dokumentasi API/data/behavior diperbarui.