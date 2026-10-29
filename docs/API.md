# API dan Kontrak Komunikasi

Status: Terverifikasi & Terimplementasi (Baseline Fondasi Monorepo 2026-10-29).

## 1. Fakta Terverifikasi

- **Arsitektur Endpoint**: Express modular router dimuat di bawah prefix `/api/v1`.
- **Format Envelope**: Seluruh endpoint mengembalikan JSON payload yang konsisten dan terikat dengan type dari `@battleground/shared`.
- **Keamanan**: Dilindungi oleh middleware `helmet`, `cors`, dan `express.json({ limit: '10kb' })`.

---

## 2. Kontrak Endpoint Riil

### `GET /api/v1/health`

Memeriksa kesehatan dan ketersediaan layanan Express backend.

- **URL**: `/api/v1/health`
- **Method**: `GET`
- **Autentikasi**: Tidak ada (Endpoint Publik)
- **Content-Type**: `application/json`

#### Response Sukses (`200 OK`)

```json
{
  "status": "ok",
  "service": "battleground-server",
  "timestamp": "2026-10-29T08:30:00.000Z",
  "uptime": 124,
  "environment": "development",
  "version": "0.1.0"
}
```

#### TypeScript Definition (`@battleground/shared`)

```typescript
export interface HealthStatusResponse {
  status: 'ok' | 'degraded' | 'down';
  service: string;
  timestamp: string;
  uptime: number;
  environment: string;
  version: string;
}
```

---

### Penanganan Error Rute Tidak Ditemukan (`404 Not Found`)

Jika klien memanggil endpoint yang tidak terdaftar (misalnya `/api/v1/non-existent`):

```json
{
  "error": {
    "message": "Route Not Found"
  }
}
```

---

### Penanganan Server Internal Error (`500 Internal Server Error`)

Jika terjadi unhandled exception pada controller:

- **Mode Development (`NODE_ENV=development`)**:
  ```json
  {
    "error": {
      "message": "Detail pesan error spesifik"
    }
  }
  ```
- **Mode Production (`NODE_ENV=production`)**:
  ```json
  {
    "error": {
      "message": "Internal Server Error"
    }
  }
  ```
  *(Stack trace tidak pernah diekspos ke klien; dicatat aman ke log server)*.

---

## 3. Rencana Endpoint Tahap Selanjutnya (TBD)

| Method | Path | Tujuan | Status |
| --- | --- | --- | --- |
| POST | `/api/v1/matches/create` | Inisialisasi room arena baru | TBD (Tahap Realtime Match) |
| POST | `/api/v1/matches/join` | Pemain bergabung ke arena | TBD (Tahap Realtime Match) |
| GET | `/api/v1/leaderboard` | Papan peringkat pemain | TBD (Tahap Persistence) |
