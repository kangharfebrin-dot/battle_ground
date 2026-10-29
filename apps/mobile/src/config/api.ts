/**
 * Konfigurasi API Base URL untuk Mobile Client.
 * 
 * PANDUAN JARINGAN:
 * - iOS Simulator: 'http://localhost:4000'
 * - Android Emulator: 'http://10.0.2.2:4000' (10.0.2.2 merujuk pada localhost komputer host)
 * - Perangkat Fisik (Expo Go): 'http://<IP-LAN-KOMPUTER>:4000' (contoh: 'http://192.168.1.50:4000')
 * 
 * PERINGATAN KEAMANAN:
 * Nilai variabel EXPO_PUBLIC_* masuk ke dalam bundle aplikasi. DILARANG menyimpan kredensial
 * server, private key, atau database secret di sini.
 */
export const API_BASE_URL: string =
  process.env.EXPO_PUBLIC_API_URL || 'http://localhost:4000';

