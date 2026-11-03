# API dan Kontrak Komunikasi

Status: Terverifikasi & Terimplementasi (Diperbarui 2026-10-29).

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

---

## 3. Kontrak Tipe Data Bersama (`@battleground/shared`)

### Kontrak Status & Respon
```typescript
export interface HealthStatusResponse {
  status: 'ok' | 'degraded' | 'down';
  service: string;
  timestamp: string;
  uptime: number;
  environment: string;
  version: string;
}

export interface ApiErrorResponse {
  error: {
    message: string;
    code?: string;
  };
}
```

### Kontrak Entitas & Fisika Gameplay
```typescript
export interface Vector2D {
  x: number;
  y: number;
}

export interface ArenaDimensions {
  width: number;
  height: number;
}

export interface EntityState {
  id: string;
  x: number;
  y: number;
  radius: number;
  hp: number;
  maxHp: number;
}

export interface PlayerState extends EntityState {
  angle: number; // Sudut hadap/aim dalam radian
  speed: number;
}

export interface ProjectileState {
  id: string;
  x: number;
  y: number;
  vx: number;
  vy: number;
  radius: number;
  damage: number;
  distanceTraveled: number;
  maxDistance: number;
}
```

### Utilitas Matematika Fisika Teruji
- `calculateDistance(p1: Vector2D, p2: Vector2D): number`
- `checkCircleCollision(c1, c2): boolean`
- `clampToArena(pos: Vector2D, radius: number, bounds: ArenaDimensions): Vector2D`
- `normalizeVector(v: Vector2D): Vector2D`

---

## 4. Rencana Endpoint Tahap Selanjutnya (TBD)

| Method | Path | Tujuan | Status |
| --- | --- | --- | --- |
| POST | `/api/v1/matches/create` | Inisialisasi room arena baru | TBD (Tahap Realtime Match) |
| POST | `/api/v1/matches/join` | Pemain bergabung ke arena | TBD (Tahap Realtime Match) |
| GET | `/api/v1/leaderboard` | Papan peringkat pemain | TBD (Tahap Persistence) |
