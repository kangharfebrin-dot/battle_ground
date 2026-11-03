import React, { useState, useEffect, useRef, useCallback } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  Dimensions,
  LayoutChangeEvent
} from 'react-native';
import {
  checkCircleCollision,
  clampToArena,
  ArenaDimensions
} from '@battleground/shared';
import { VirtualJoystick, JoystickEvent } from './components/VirtualJoystick';

interface Player {
  x: number;
  y: number;
  radius: number;
  hp: number;
  maxHp: number;
  angle: number;
  speed: number;
}

interface Bullet {
  id: number;
  x: number;
  y: number;
  vx: number;
  vy: number;
  radius: number;
  damage: number;
  isPlayer: boolean;
  distanceTraveled: number;
  maxDistance: number;
}

interface TargetDummy {
  id: number;
  x: number;
  y: number;
  radius: number;
  hp: number;
  maxHp: number;
  vx: number;
  vy: number;
}

const PLAYER_MAX_HP = 100;
const DUMMY_MAX_HP = 60;
const BULLET_SPEED = 9;
const FIRE_COOLDOWN_MS = 220;

export const SoloPracticeArena: React.FC = () => {
  const [arenaBounds, setArenaBounds] = useState<ArenaDimensions>({
    width: Dimensions.get('window').width - 32,
    height: 320
  });

  // State tampilan UI
  const [playerHp, setPlayerHp] = useState<number>(PLAYER_MAX_HP);
  const [score, setScore] = useState<number>(0);
  const [isGameOver, setIsGameOver] = useState<boolean>(false);
  const [ammoCount, setAmmoCount] = useState<number>(30);

  // Mutable refs untuk rendering 60 FPS tanpa re-render lag
  const playerRef = useRef<Player>({
    x: 100,
    y: 160,
    radius: 16,
    hp: PLAYER_MAX_HP,
    maxHp: PLAYER_MAX_HP,
    angle: 0,
    speed: 3.5
  });

  const moveVectorRef = useRef<{ x: number; y: number }>({ x: 0, y: 0 });
  const aimVectorRef = useRef<{ angle: number; active: boolean; magnitude: number }>({
    angle: 0,
    active: false,
    magnitude: 0
  });

  const bulletsRef = useRef<Bullet[]>([]);
  const dummiesRef = useRef<TargetDummy[]>([
    { id: 1, x: 280, y: 100, radius: 18, hp: DUMMY_MAX_HP, maxHp: DUMMY_MAX_HP, vx: 0.8, vy: 0.5 },
    { id: 2, x: 380, y: 220, radius: 18, hp: DUMMY_MAX_HP, maxHp: DUMMY_MAX_HP, vx: -0.6, vy: 0.7 }
  ]);

  const lastFireTimeRef = useRef<number>(0);
  const bulletIdCounterRef = useRef<number>(0);
  const animationFrameIdRef = useRef<number>(0);

  // Trigger state untuk re-render tampilan visual entitas
  const [, setRenderTick] = useState<number>(0);

  // Inisialisasi posisi awal saat arena terukur
  const handleArenaLayout = (e: LayoutChangeEvent) => {
    const { width, height } = e.nativeEvent.layout;
    if (width > 0 && height > 0) {
      setArenaBounds({ width, height });
      playerRef.current.x = width * 0.25;
      playerRef.current.y = height * 0.5;
    }
  };

  // Reset sesi Solo Practice
  const resetPractice = useCallback(() => {
    playerRef.current = {
      x: arenaBounds.width * 0.25,
      y: arenaBounds.height * 0.5,
      radius: 16,
      hp: PLAYER_MAX_HP,
      maxHp: PLAYER_MAX_HP,
      angle: 0,
      speed: 3.5
    };

    dummiesRef.current = [
      { id: 1, x: arenaBounds.width * 0.65, y: arenaBounds.height * 0.3, radius: 18, hp: DUMMY_MAX_HP, maxHp: DUMMY_MAX_HP, vx: 0.8, vy: 0.5 },
      { id: 2, x: arenaBounds.width * 0.75, y: arenaBounds.height * 0.7, radius: 18, hp: DUMMY_MAX_HP, maxHp: DUMMY_MAX_HP, vx: -0.6, vy: 0.7 }
    ];

    bulletsRef.current = [];
    setPlayerHp(PLAYER_MAX_HP);
    setScore(0);
    setIsGameOver(false);
    setAmmoCount(30);
  }, [arenaBounds]);

  // Main 60 FPS Game Loop
  useEffect(() => {
    let isRunning = true;

    const gameLoop = () => {
      if (!isRunning) return;

      if (!isGameOver) {
        const player = playerRef.current;
        const moveVec = moveVectorRef.current;
        const aimVec = aimVectorRef.current;
        const now = Date.now();

        // 1. Update Pergerakan Pemain
        if (moveVec.x !== 0 || moveVec.y !== 0) {
          player.x += moveVec.x * player.speed;
          player.y += moveVec.y * player.speed;

          // Batasi di dalam arena
          const clamped = clampToArena(
            { x: player.x, y: player.y },
            player.radius,
            arenaBounds
          );
          player.x = clamped.x;
          player.y = clamped.y;
        }

        // 2. Update Sudut Bidikan Pemain
        if (aimVec.active) {
          player.angle = aimVec.angle;

          // 3. Mekanisme Tembakan (Shooting Trigger) saat joystick ditarik > threshold
          if (aimVec.magnitude > 0.4 && now - lastFireTimeRef.current >= FIRE_COOLDOWN_MS) {
            lastFireTimeRef.current = now;

            const vx = Math.cos(player.angle) * BULLET_SPEED;
            const vy = Math.sin(player.angle) * BULLET_SPEED;

            bulletIdCounterRef.current += 1;
            bulletsRef.current.push({
              id: bulletIdCounterRef.current,
              x: player.x + Math.cos(player.angle) * (player.radius + 6),
              y: player.y + Math.sin(player.angle) * (player.radius + 6),
              vx,
              vy,
              radius: 4,
              damage: 20,
              isPlayer: true,
              distanceTraveled: 0,
              maxDistance: 450
            });

            setAmmoCount((prev) => (prev > 0 ? prev - 1 : 30));
          }
        }

        // 4. Update Peluru & Deteksi Tabrakan
        const updatedBullets: Bullet[] = [];
        for (const bullet of bulletsRef.current) {
          bullet.x += bullet.vx;
          bullet.y += bullet.vy;
          bullet.distanceTraveled += Math.sqrt(bullet.vx * bullet.vx + bullet.vy * bullet.vy);

          // Hapus peluru jika menabrak dinding arena atau mencapai jarak maksimal
          const hitWall =
            bullet.x <= bullet.radius ||
            bullet.x >= arenaBounds.width - bullet.radius ||
            bullet.y <= bullet.radius ||
            bullet.y >= arenaBounds.height - bullet.radius;

          if (hitWall || bullet.distanceTraveled >= bullet.maxDistance) {
            continue; // Hancurkan peluru
          }

          // Cek tabrakan peluru pemain vs dummy bot
          let hitDummy = false;
          if (bullet.isPlayer) {
            for (const dummy of dummiesRef.current) {
              if (dummy.hp > 0 && checkCircleCollision(bullet, dummy)) {
                hitDummy = true;
                dummy.hp -= bullet.damage;

                // Jika dummy hancur, tambah skor eliminasi dan respawn
                if (dummy.hp <= 0) {
                  setScore((prev) => prev + 100);
                  dummy.hp = DUMMY_MAX_HP;
                  dummy.x = arenaBounds.width * 0.5 + Math.random() * (arenaBounds.width * 0.4);
                  dummy.y = 40 + Math.random() * (arenaBounds.height - 80);
                }
                break;
              }
            }
          }

          if (!hitDummy) {
            updatedBullets.push(bullet);
          }
        }
        bulletsRef.current = updatedBullets;

        // 5. Update Target Dummy (Patroli Sederhana di Arena)
        for (const dummy of dummiesRef.current) {
          dummy.x += dummy.vx;
          dummy.y += dummy.vy;

          if (dummy.x <= dummy.radius || dummy.x >= arenaBounds.width - dummy.radius) {
            dummy.vx *= -1;
          }
          if (dummy.y <= dummy.radius || dummy.y >= arenaBounds.height - dummy.radius) {
            dummy.vy *= -1;
          }

          // Cek tabrakan fisik pemain vs dummy (kontak langsung menghasilkan damage)
          if (checkCircleCollision(player, dummy)) {
            player.hp = Math.max(0, player.hp - 0.4);
            setPlayerHp(Math.round(player.hp));

            if (player.hp <= 0) {
              setIsGameOver(true);
            }
          }
        }
      }

      setRenderTick((tick) => (tick + 1) % 1000);
      animationFrameIdRef.current = requestAnimationFrame(gameLoop);
    };

    animationFrameIdRef.current = requestAnimationFrame(gameLoop);

    return () => {
      isRunning = false;
      cancelAnimationFrame(animationFrameIdRef.current);
    };
  }, [arenaBounds, isGameOver]);

  const player = playerRef.current;

  return (
    <View style={styles.container}>
      {/* HUD Header */}
      <View style={styles.hudContainer}>
        {/* HP Bar Pemain */}
        <View style={styles.hpSection}>
          <Text style={styles.hudLabel}>HP PEMAIN: {Math.max(0, playerHp)} / {PLAYER_MAX_HP}</Text>
          <View style={styles.hpBarBackground}>
            <View
              style={[
                styles.hpBarFill,
                {
                  width: `${Math.max(0, (playerHp / PLAYER_MAX_HP) * 100)}%`,
                  backgroundColor: playerHp > 40 ? '#22C55E' : '#EF4444'
                }
              ]}
            />
          </View>
        </View>

        {/* Skor & Status */}
        <View style={styles.scoreSection}>
          <Text style={styles.scoreText}>SKOR: {score}</Text>
          <Text style={styles.ammoText}>AMMO: {ammoCount}</Text>
        </View>

        {/* Tombol Reset Latihan */}
        <TouchableOpacity style={styles.resetButton} onPress={resetPractice} activeOpacity={0.7}>
          <Text style={styles.resetButtonText}>Reset Arena</Text>
        </TouchableOpacity>
      </View>

      {/* Arena 2D Playfield */}
      <View style={styles.arenaContainer} onLayout={handleArenaLayout}>
        <View style={[styles.arenaBorder, { width: arenaBounds.width, height: arenaBounds.height }]}>
          {/* Garis Grid Arena Visual */}
          <View style={styles.arenaGridH} />
          <View style={styles.arenaGridV} />

          {/* Render Target Dummies */}
          {dummiesRef.current.map((dummy) => (
            <View
              key={dummy.id}
              style={[
                styles.dummyEntity,
                {
                  width: dummy.radius * 2,
                  height: dummy.radius * 2,
                  borderRadius: dummy.radius,
                  left: dummy.x - dummy.radius,
                  top: dummy.y - dummy.radius
                }
              ]}
            >
              {/* Dummy HP indicator */}
              <View style={styles.dummyHpBar}>
                <View
                  style={[
                    styles.dummyHpFill,
                    { width: `${(dummy.hp / dummy.maxHp) * 100}%` }
                  ]}
                />
              </View>
            </View>
          ))}

          {/* Render Peluru Proyektil */}
          {bulletsRef.current.map((bullet) => (
            <View
              key={bullet.id}
              style={[
                styles.bulletEntity,
                {
                  width: bullet.radius * 2,
                  height: bullet.radius * 2,
                  borderRadius: bullet.radius,
                  left: bullet.x - bullet.radius,
                  top: bullet.y - bullet.radius
                }
              ]}
            />
          ))}

          {/* Render Karakter Pemain */}
          {!isGameOver && (
            <View
              style={[
                styles.playerEntity,
                {
                  width: player.radius * 2,
                  height: player.radius * 2,
                  borderRadius: player.radius,
                  left: player.x - player.radius,
                  top: player.y - player.radius
                }
              ]}
            >
              {/* Petunjuk Arah Bidik (Turret Pointer) */}
              <View
                style={[
                  styles.aimPointer,
                  {
                    transform: [
                      { rotate: `${player.angle}rad` },
                      { translateX: player.radius * 0.7 }
                    ]
                  }
                ]}
              />
            </View>
          )}

          {/* Overlay Game Over */}
          {isGameOver && (
            <View style={styles.gameOverOverlay}>
              <Text style={styles.gameOverTitle}>HP HABIS (TERELIMINASI)</Text>
              <Text style={styles.gameOverSubtitle}>Skor Eliminasi Akhir: {score}</Text>
              <TouchableOpacity style={styles.tryAgainButton} onPress={resetPractice} activeOpacity={0.8}>
                <Text style={styles.tryAgainText}>Ulangi Solo Practice</Text>
              </TouchableOpacity>
            </View>
          )}
        </View>
      </View>

      {/* Kontrol Dual Virtual Joystick */}
      <View style={styles.controlsContainer}>
        {/* Joystick Kiri: Pergerakan Translasi */}
        <View style={styles.joystickWrapper}>
          <Text style={styles.controlHint}>STICK KIRI (GERAK)</Text>
          <VirtualJoystick
            size={110}
            knobSize={46}
            color="#38BDF8"
            onMove={(e: JoystickEvent) => {
              moveVectorRef.current = { x: e.x, y: e.y };
            }}
            onRelease={() => {
              moveVectorRef.current = { x: 0, y: 0 };
            }}
          />
        </View>

        {/* Petunjuk Tengah */}
        <View style={styles.centerGuide}>
          <Text style={styles.guideText}>Tarik stik kanan untuk membidik & menembak</Text>
          <Text style={styles.guideSub}>Hindari kontak langsung dengan target merah!</Text>
        </View>

        {/* Joystick Kanan: Aiming & Shooting */}
        <View style={styles.joystickWrapper}>
          <Text style={styles.controlHint}>STICK KANAN (TEMBAK)</Text>
          <VirtualJoystick
            size={110}
            knobSize={46}
            color="#F43F5E"
            onMove={(e: JoystickEvent) => {
              aimVectorRef.current = {
                angle: e.angle,
                active: e.active,
                magnitude: e.magnitude
              };
            }}
            onRelease={() => {
              aimVectorRef.current = { angle: 0, active: false, magnitude: 0 };
            }}
          />
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#090D16',
    padding: 12
  },
  hudContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 8,
    paddingHorizontal: 8
  },
  hpSection: {
    flex: 1,
    marginRight: 16
  },
  hudLabel: {
    fontSize: 11,
    fontWeight: '700',
    color: '#CBD5E1',
    marginBottom: 4,
    letterSpacing: 0.8
  },
  hpBarBackground: {
    height: 12,
    backgroundColor: '#1E293B',
    borderRadius: 6,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: '#334155'
  },
  hpBarFill: {
    height: '100%',
    borderRadius: 6
  },
  scoreSection: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginRight: 12
  },
  scoreText: {
    fontSize: 13,
    fontWeight: '800',
    color: '#FACC15',
    letterSpacing: 1
  },
  ammoText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#38BDF8'
  },
  resetButton: {
    backgroundColor: '#334155',
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: 8
  },
  resetButtonText: {
    fontSize: 11,
    fontWeight: '700',
    color: '#F8FAFC'
  },
  arenaContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 4
  },
  arenaBorder: {
    backgroundColor: '#0F172A',
    borderColor: '#4F46E5',
    borderWidth: 2,
    borderRadius: 12,
    position: 'relative',
    overflow: 'hidden'
  },
  arenaGridH: {
    position: 'absolute',
    top: '50%',
    left: 0,
    right: 0,
    height: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.05)'
  },
  arenaGridV: {
    position: 'absolute',
    left: '50%',
    top: 0,
    bottom: 0,
    width: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.05)'
  },
  playerEntity: {
    position: 'absolute',
    backgroundColor: '#38BDF8',
    borderColor: '#BAE6FD',
    borderWidth: 2,
    shadowColor: '#38BDF8',
    shadowOpacity: 0.8,
    shadowRadius: 6,
    elevation: 6,
    justifyContent: 'center',
    alignItems: 'center'
  },
  aimPointer: {
    position: 'absolute',
    width: 14,
    height: 4,
    backgroundColor: '#F8FAFC',
    borderRadius: 2
  },
  dummyEntity: {
    position: 'absolute',
    backgroundColor: '#EF4444',
    borderColor: '#FCA5A5',
    borderWidth: 2,
    shadowColor: '#EF4444',
    shadowOpacity: 0.6,
    shadowRadius: 5,
    elevation: 4
  },
  dummyHpBar: {
    position: 'absolute',
    top: -8,
    left: 0,
    right: 0,
    height: 4,
    backgroundColor: '#1E293B',
    borderRadius: 2,
    overflow: 'hidden'
  },
  dummyHpFill: {
    height: '100%',
    backgroundColor: '#F87171'
  },
  bulletEntity: {
    position: 'absolute',
    backgroundColor: '#FACC15',
    shadowColor: '#FACC15',
    shadowOpacity: 0.9,
    shadowRadius: 4,
    elevation: 3
  },
  gameOverOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(15, 23, 42, 0.88)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20
  },
  gameOverTitle: {
    fontSize: 20,
    fontWeight: '900',
    color: '#EF4444',
    letterSpacing: 2,
    marginBottom: 6
  },
  gameOverSubtitle: {
    fontSize: 14,
    color: '#CBD5E1',
    marginBottom: 16
  },
  tryAgainButton: {
    backgroundColor: '#4F46E5',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 10
  },
  tryAgainText: {
    fontSize: 14,
    fontWeight: '700',
    color: '#FFFFFF'
  },
  controlsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    marginTop: 8,
    paddingHorizontal: 12
  },
  joystickWrapper: {
    alignItems: 'center'
  },
  controlHint: {
    fontSize: 10,
    fontWeight: '700',
    color: '#64748B',
    marginBottom: 6,
    letterSpacing: 1
  },
  centerGuide: {
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 20
  },
  guideText: {
    fontSize: 11,
    color: '#94A3B8',
    fontWeight: '600'
  },
  guideSub: {
    fontSize: 10,
    color: '#64748B',
    marginTop: 2
  }
});
