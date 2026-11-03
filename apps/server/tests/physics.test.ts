import {
  calculateDistance,
  checkCircleCollision,
  clampToArena,
  normalizeVector
} from '@battleground/shared';

describe('Shared Game Physics & Mathematics', () => {
  describe('calculateDistance', () => {
    it('harus menghitung jarak euclidean secara akurat', () => {
      const p1 = { x: 0, y: 0 };
      const p2 = { x: 3, y: 4 };
      expect(calculateDistance(p1, p2)).toBe(5);
    });
  });

  describe('checkCircleCollision', () => {
    it('harus mendeteksi tabrakan saat jarak antar-pusat <= jumlah radius', () => {
      const c1 = { x: 10, y: 10, radius: 5 };
      const c2 = { x: 18, y: 10, radius: 5 }; // Jarak 8 <= 10 (tabrakan)
      expect(checkCircleCollision(c1, c2)).toBe(true);
    });

    it('harus mendeteksi tidak ada tabrakan saat lingkaran terpisah', () => {
      const c1 = { x: 0, y: 0, radius: 5 };
      const c2 = { x: 20, y: 0, radius: 5 }; // Jarak 20 > 10 (tidak tabrakan)
      expect(checkCircleCollision(c1, c2)).toBe(false);
    });
  });

  describe('clampToArena', () => {
    const arena = { width: 500, height: 400 };

    it('harus membatasi posisi di dalam batas dinding arena', () => {
      const outsidePos = { x: -10, y: 450 };
      const radius = 15;
      const clamped = clampToArena(outsidePos, radius, arena);

      expect(clamped.x).toBe(15); // x terkunci pada batas kiri
      expect(clamped.y).toBe(385); // y terkunci pada batas bawah (400 - 15)
    });

    it('tidak mengubah posisi yang sudah berada di dalam arena', () => {
      const insidePos = { x: 250, y: 200 };
      const radius = 15;
      const clamped = clampToArena(insidePos, radius, arena);

      expect(clamped).toEqual({ x: 250, y: 200 });
    });
  });

  describe('normalizeVector', () => {
    it('harus menormalkan magnitudo vektor menjadi 1', () => {
      const v = { x: 10, y: 0 };
      const norm = normalizeVector(v);
      expect(norm).toEqual({ x: 1, y: 0 });
    });

    it('mengembalikan { x: 0, y: 0 } untuk vektor nol', () => {
      const v = { x: 0, y: 0 };
      expect(normalizeVector(v)).toEqual({ x: 0, y: 0 });
    });
  });
});

