import React, { useRef, useState, useMemo } from 'react';
import {
  StyleSheet,
  View,
  PanResponder,
  GestureResponderEvent,
  PanResponderGestureState
} from 'react-native';

export interface JoystickEvent {
  x: number; // Nilai ternormalisasi [-1, 1]
  y: number; // Nilai ternormalisasi [-1, 1]
  angle: number; // Sudut hadap dalam radian
  magnitude: number; // Jarak dari pusat [0, 1]
  active: boolean;
}

interface VirtualJoystickProps {
  size?: number;
  knobSize?: number;
  color?: string;
  onMove?: (event: JoystickEvent) => void;
  onRelease?: () => void;
}

export const VirtualJoystick: React.FC<VirtualJoystickProps> = ({
  size = 110,
  knobSize = 44,
  color = '#6366F1',
  onMove,
  onRelease
}) => {
  const maxRadius = (size - knobSize) / 2;
  const [knobPosition, setKnobPosition] = useState<{ x: number; y: number }>({ x: 0, y: 0 });
  const [isActive, setIsActive] = useState<boolean>(false);

  // Menyimpan ref callback agar PanResponder selalu memanggil callback terbaru
  const onMoveRef = useRef(onMove);
  onMoveRef.current = onMove;

  const onReleaseRef = useRef(onRelease);
  onReleaseRef.current = onRelease;

  const panResponder = useMemo(
    () =>
      PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onMoveShouldSetPanResponder: () => true,

        onPanResponderGrant: () => {
          setIsActive(true);
        },

        onPanResponderMove: (
          _evt: GestureResponderEvent,
          gestureState: PanResponderGestureState
        ) => {
          const dx = gestureState.dx;
          const dy = gestureState.dy;
          const distance = Math.sqrt(dx * dx + dy * dy);

          let clampedX = dx;
          let clampedY = dy;

          if (distance > maxRadius) {
            clampedX = (dx / distance) * maxRadius;
            clampedY = (dy / distance) * maxRadius;
          }

          setKnobPosition({ x: clampedX, y: clampedY });

          const normalizedX = clampedX / maxRadius;
          const normalizedY = clampedY / maxRadius;
          const angle = Math.atan2(dy, dx);
          const magnitude = Math.min(1, distance / maxRadius);

          if (onMoveRef.current) {
            onMoveRef.current({
              x: normalizedX,
              y: normalizedY,
              angle,
              magnitude,
              active: true
            });
          }
        },

        onPanResponderRelease: () => {
          setIsActive(false);
          setKnobPosition({ x: 0, y: 0 });

          if (onMoveRef.current) {
            onMoveRef.current({
              x: 0,
              y: 0,
              angle: 0,
              magnitude: 0,
              active: false
            });
          }

          if (onReleaseRef.current) {
            onReleaseRef.current();
          }
        },

        onPanResponderTerminate: () => {
          setIsActive(false);
          setKnobPosition({ x: 0, y: 0 });

          if (onReleaseRef.current) {
            onReleaseRef.current();
          }
        }
      }),
    [maxRadius]
  );

  return (
    <View
      style={[
        styles.base,
        {
          width: size,
          height: size,
          borderRadius: size / 2,
          borderColor: isActive ? color : 'rgba(255, 255, 255, 0.2)'
        }
      ]}
      {...panResponder.panHandlers}
    >
      {/* Knob virtual joystick */}
      <View
        style={[
          styles.knob,
          {
            width: knobSize,
            height: knobSize,
            borderRadius: knobSize / 2,
            backgroundColor: color,
            transform: [
              { translateX: knobPosition.x },
              { translateY: knobPosition.y }
            ],
            opacity: isActive ? 1 : 0.6
          }
        ]}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  base: {
    backgroundColor: 'rgba(15, 23, 42, 0.6)',
    borderWidth: 2,
    justifyContent: 'center',
    alignItems: 'center'
  },
  knob: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.4,
    shadowRadius: 4,
    elevation: 4
  }
});

