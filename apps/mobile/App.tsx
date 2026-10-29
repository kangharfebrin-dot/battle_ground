import React, { useState, useEffect, useCallback } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  ActivityIndicator,
  SafeAreaView,
  StatusBar,
  ScrollView
} from 'react-native';
import { HealthStatusResponse } from '@battleground/shared';
import { API_BASE_URL } from './src/config/api';

export default function App() {
  const [loading, setLoading] = useState<boolean>(false);
  const [healthData, setHealthData] = useState<HealthStatusResponse | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [lastChecked, setLastChecked] = useState<string | null>(null);

  const checkBackendHealth = useCallback(async () => {
    setLoading(true);
    setErrorMessage(null);

    const controller = new AbortController();
    const timeoutDurationMs = 6000; // 6 detik batas timeout
    const timeoutId = setTimeout(() => controller.abort(), timeoutDurationMs);

    try {
      const targetUrl = `${API_BASE_URL}/api/v1/health`;
      const response = await fetch(targetUrl, {
        signal: controller.signal,
        headers: {
          Accept: 'application/json'
        }
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new Error(`Server merespons dengan HTTP status ${response.status}`);
      }

      const data: HealthStatusResponse = await response.json();

      if (!data || data.status !== 'ok') {
        throw new Error('Payload health dari server tidak valid.');
      }

      setHealthData(data);
      setLastChecked(new Date().toLocaleTimeString());
    } catch (err: unknown) {
      clearTimeout(timeoutId);
      if (err instanceof Error) {
        if (err.name === 'AbortError') {
          setErrorMessage(`Koneksi timeout (${timeoutDurationMs / 1000}s). Pastikan server aktif dan alamat API benar.`);
        } else {
          setErrorMessage(err.message || 'Gagal tersambung ke backend.');
        }
      } else {
        setErrorMessage('Terjadi kesalahan jaringan yang tidak diketahui.');
      }
      setHealthData(null);
      setLastChecked(new Date().toLocaleTimeString());
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    checkBackendHealth();
  }, [checkBackendHealth]);

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar barStyle="light-content" backgroundColor="#0F172A" />
      <ScrollView contentContainerStyle={styles.container}>
        {/* Game Header */}
        <View style={styles.header}>
          <Text style={styles.badge}>MOBILE CLIENT</Text>
          <Text style={styles.gameTitle}>BATTLE GROUND</Text>
          <Text style={styles.gameSubtitle}>Top-Down Arena Shooter 2D</Text>
        </View>

        {/* Connectivity Card */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Status Konektivitas Backend</Text>

          {/* Target URL Info */}
          <View style={styles.targetBox}>
            <Text style={styles.targetLabel}>Target API URL:</Text>
            <Text style={styles.targetValue}>{API_BASE_URL}/api/v1/health</Text>
          </View>

          {/* Dynamic Status Section */}
          <View style={styles.statusSection}>
            {loading && (
              <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#6366F1" />
                <Text style={styles.loadingText}>Memeriksa status server...</Text>
              </View>
            )}

            {!loading && errorMessage && (
              <View style={[styles.feedbackBox, styles.errorBox]}>
                <View style={styles.indicatorRow}>
                  <View style={[styles.statusDot, styles.dotError]} />
                  <Text style={styles.errorHeading}>Koneksi Gagal</Text>
                </View>
                <Text style={styles.errorDescription}>{errorMessage}</Text>
                <View style={styles.hintContainer}>
                  <Text style={styles.hintTitle}>Panduan Konfigurasi Jaringan:</Text>
                  <Text style={styles.hintItem}>• iOS Simulator: http://localhost:4000</Text>
                  <Text style={styles.hintItem}>• Android Emulator: http://10.0.2.2:4000</Text>
                  <Text style={styles.hintItem}>• Perangkat Fisik (Expo Go): http://&lt;IP-LAN&gt;:4000</Text>
                </View>
              </View>
            )}

            {!loading && healthData && (
              <View style={[styles.feedbackBox, styles.successBox]}>
                <View style={styles.indicatorRow}>
                  <View style={[styles.statusDot, styles.dotSuccess]} />
                  <Text style={styles.successHeading}>Terhubung ke Server</Text>
                </View>
                <View style={styles.dataGrid}>
                  <Text style={styles.dataLabel}>Service:</Text>
                  <Text style={styles.dataValue}>{healthData.service}</Text>

                  <Text style={styles.dataLabel}>Status:</Text>
                  <Text style={[styles.dataValue, styles.statusOkText]}>
                    {healthData.status.toUpperCase()}
                  </Text>

                  <Text style={styles.dataLabel}>Uptime:</Text>
                  <Text style={styles.dataValue}>{healthData.uptime} detik</Text>

                  <Text style={styles.dataLabel}>Environment:</Text>
                  <Text style={styles.dataValue}>{healthData.environment}</Text>

                  <Text style={styles.dataLabel}>Versi:</Text>
                  <Text style={styles.dataValue}>{healthData.version}</Text>

                  <Text style={styles.dataLabel}>Timestamp:</Text>
                  <Text style={styles.dataValue}>{healthData.timestamp}</Text>
                </View>
              </View>
            )}
          </View>

          {lastChecked && (
            <Text style={styles.lastCheckedText}>Pemeriksaan terakhir: {lastChecked}</Text>
          )}

          {/* Action Button */}
          <TouchableOpacity
            style={[styles.actionButton, loading && styles.buttonDisabled]}
            onPress={checkBackendHealth}
            disabled={loading}
            activeOpacity={0.8}
          >
            <Text style={styles.buttonText}>
              {loading ? 'Sedang Memeriksa...' : 'Uji Koneksi Ulang (Retry)'}
            </Text>
          </TouchableOpacity>
        </View>

        {/* Architecture Note */}
        <View style={styles.footerNote}>
          <Text style={styles.footerText}>
            Dual Joystick & Realtime Socket.IO terencana pada fase berikutnya.
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#0F172A'
  },
  container: {
    padding: 24,
    justifyContent: 'center',
    minHeight: '100%'
  },
  header: {
    alignItems: 'center',
    marginBottom: 28
  },
  badge: {
    backgroundColor: '#312E81',
    color: '#818CF8',
    fontSize: 11,
    fontWeight: '700',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 6,
    letterSpacing: 1.2,
    marginBottom: 8
  },
  gameTitle: {
    fontSize: 34,
    fontWeight: '900',
    color: '#F8FAFC',
    letterSpacing: 2.5
  },
  gameSubtitle: {
    fontSize: 14,
    color: '#94A3B8',
    marginTop: 4,
    fontWeight: '500'
  },
  card: {
    backgroundColor: '#1E293B',
    borderRadius: 18,
    padding: 22,
    borderWidth: 1,
    borderColor: '#334155'
  },
  cardTitle: {
    fontSize: 17,
    fontWeight: '700',
    color: '#F1F5F9',
    marginBottom: 14
  },
  targetBox: {
    backgroundColor: '#0F172A',
    padding: 12,
    borderRadius: 10,
    marginBottom: 16
  },
  targetLabel: {
    fontSize: 11,
    color: '#64748B',
    textTransform: 'uppercase',
    fontWeight: '600'
  },
  targetValue: {
    fontSize: 13,
    color: '#38BDF8',
    marginTop: 2,
    fontWeight: '500'
  },
  statusSection: {
    minHeight: 160,
    justifyContent: 'center',
    marginBottom: 16
  },
  loadingContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 20
  },
  loadingText: {
    color: '#CBD5E1',
    marginTop: 12,
    fontSize: 14
  },
  feedbackBox: {
    padding: 16,
    borderRadius: 12,
    borderWidth: 1
  },
  indicatorRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10
  },
  statusDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    marginRight: 8
  },
  dotSuccess: {
    backgroundColor: '#22C55E'
  },
  dotError: {
    backgroundColor: '#EF4444'
  },
  errorBox: {
    backgroundColor: 'rgba(239, 68, 68, 0.08)',
    borderColor: '#EF4444'
  },
  errorHeading: {
    fontSize: 16,
    fontWeight: '700',
    color: '#F87171'
  },
  errorDescription: {
    fontSize: 13,
    color: '#FECACA',
    lineHeight: 18,
    marginBottom: 12
  },
  hintContainer: {
    backgroundColor: 'rgba(0, 0, 0, 0.25)',
    padding: 10,
    borderRadius: 8
  },
  hintTitle: {
    fontSize: 12,
    fontWeight: '600',
    color: '#FCA5A5',
    marginBottom: 4
  },
  hintItem: {
    fontSize: 11,
    color: '#F87171',
    lineHeight: 16
  },
  successBox: {
    backgroundColor: 'rgba(34, 197, 94, 0.08)',
    borderColor: '#22C55E'
  },
  successHeading: {
    fontSize: 16,
    fontWeight: '700',
    color: '#4ADE80'
  },
  dataGrid: {
    marginTop: 4
  },
  dataLabel: {
    fontSize: 11,
    color: '#94A3B8',
    marginTop: 4,
    textTransform: 'uppercase',
    fontWeight: '600'
  },
  dataValue: {
    fontSize: 13,
    color: '#E2E8F0',
    fontWeight: '500'
  },
  statusOkText: {
    color: '#4ADE80',
    fontWeight: '700'
  },
  lastCheckedText: {
    fontSize: 11,
    color: '#64748B',
    textAlign: 'center',
    marginBottom: 14
  },
  actionButton: {
    backgroundColor: '#4F46E5',
    paddingVertical: 14,
    borderRadius: 12,
    alignItems: 'center'
  },
  buttonDisabled: {
    opacity: 0.6
  },
  buttonText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '700'
  },
  footerNote: {
    marginTop: 20,
    alignItems: 'center'
  },
  footerText: {
    fontSize: 12,
    color: '#64748B',
    textAlign: 'center'
  }
});

