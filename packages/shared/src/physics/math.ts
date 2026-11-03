import { Vector2D, ArenaDimensions } from '../contracts/game.contract';

/**
 * Menghitung jarak euclidean antara dua koordinat 2D.
 */
export function calculateDistance(p1: Vector2D, p2: Vector2D): number {
  const dx = p2.x - p1.x;
  const dy = p2.y - p1.y;
  return Math.sqrt(dx * dx + dy * dy);
}

/**
 * Deteksi benturan lingkaran (circle-to-circle collision) antara dua entitas ber-hitbox radius.
 */
export function checkCircleCollision(
  c1: { x: number; y: number; radius: number },
  c2: { x: number; y: number; radius: number }
): boolean {
  const dist = calculateDistance(c1, c2);
  return dist <= c1.radius + c2.radius;
}

/**
 * Mengunci koordinat posisi entitas agar selalu berada di dalam batas dinding arena.
 */
export function clampToArena(
  pos: Vector2D,
  radius: number,
  bounds: ArenaDimensions
): Vector2D {
  return {
    x: Math.max(radius, Math.min(bounds.width - radius, pos.x)),
    y: Math.max(radius, Math.min(bounds.height - radius, pos.y))
  };
}

/**
 * Menormalkan vektor ke panjang satuan (unit vector).
 */
export function normalizeVector(v: Vector2D): Vector2D {
  const mag = Math.sqrt(v.x * v.x + v.y * v.y);
  if (mag === 0) return { x: 0, y: 0 };
  return {
    x: v.x / mag,
    y: v.y / mag
  };
}

