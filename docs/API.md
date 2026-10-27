# API dan Kontrak Komunikasi

Status endpoint aktual: belum diverifikasi. Tidak ada route HTTP/event realtime yang dicatat sebagai fakta.

## Audit API
- Temukan entrypoint Express dan router yang benar-benar diregistrasikan.
- Catat method/path, middleware, handler, validator, auth, authorization, service dan persistence setiap endpoint.
- Catat status HTTP, success/error response dan side effect aktual.
- Cari OpenAPI/Swagger, Postman, versioning, client API mobile dan integration tests.
- Pastikan route benar-benar dipasang, bukan hanya didefinisikan namun tidak digunakan.
- Jangan menyertakan credential atau data personal pada contoh request.

## Format tiap endpoint
| Field | Informasi |
|---|---|
| ID/tujuan | Perilaku bisnis |
| Method + path | Persis seperti implementasi |
| Access control | Berdasarkan middleware/logic |
| Request | Path/query/body, types, validasi dan batas |
| Success/error | HTTP status dan payload aktual |
| Side effects | Perubahan data/event/transaksi |
| Idempotency/concurrency | Jika relevan |
| Rate limit | Nilai dan sumber konfigurasi |
| Evidence | File/baris dan test |

## Realtime
Jika diperlukan, dokumentasikan transport, auth koneksi, event schema/version, ukuran pesan, validation, ordering, ack, timeout/retry, reconnect, resync, rate limiting dan observability.

## Standar ke depan
Validasi input server-side, gunakan error contract konsisten, jangan membocorkan stack trace atau data yang tidak berhak dilihat, dan jangan membuat breaking change tanpa persetujuan serta strategi migrasi. Pilih OpenAPI/Postman setelah memeriksa tooling aktual.