# Pedoman UI/UX Mobile Game

Status: panduan awal, belum dicocokkan dengan layar dan aset aplikasi yang sesungguhnya.

## Prinsip
- Prioritaskan keterbacaan dan area sentuh nyaman di layar ponsel.
- Hormati safe area, notch, status bar, navigation bar, dan variasi aspect ratio.
- Gunakan hierarki visual konsisten untuk navigasi, aksi utama, informasi penting dan feedback.
- Bedakan loading, empty, error, offline, disabled, success dan destructive action.
- Jangan mengandalkan warna saja untuk membedakan status.
- Hindari animasi berat yang mengganggu input dan performa.
- Uji ukuran layar serta font yang didukung.

## Jika gameplay real-time
Evaluasi latency input, area kontrol, dukungan tangan kiri/kanan, gesture conflict, HUD, feedback hit/damage dan safe area. Ini checklist kondisional, bukan asumsi adanya fitur tersebut.

## Design system
Audit komponen yang ada sebelum membuat duplikasi. Setelah desain aktual diperiksa, dokumentasikan warna, typography, spacing, radius, tombol/state, modal, form, toast, dialog, empty state dan error state.

## Accessibility/perangkat
Gunakan label screen reader bermakna, kontras memadai, ukuran target yang cukup, serta uji perangkat kecil/low-end. Hormati reduced-motion bila sesuai.

## Keputusan terbuka
Art direction, palet, orientasi, target FPS/perangkat, bahasa, audio, haptics, motion dan accessibility requirements.