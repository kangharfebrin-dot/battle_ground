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

export interface TargetDummyState extends EntityState {
  isActive: boolean;
}

