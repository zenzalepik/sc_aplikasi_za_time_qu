# Sistem Alarm - Dokumentasi

## Fitur Alarm

Sistem alarm yang telah diperbaiki dengan fitur lengkap:

### ✅ Fitur Utama

1. **Suara Alarm**
   - Menggunakan suara beep-beep pattern (seperti jam digital)
   - Pattern: 2 beep, pause, repeat
   - Menggunakan SystemSound.alert untuk kompatibilitas maksimal

2. **Vibrasi Panjang**
   - Pattern vibrasi: 500ms ON, 200ms OFF, repeat
   - Berulang terus menerus selama alarm berbunyi

3. **Auto-Stop**
   - Alarm akan otomatis berhenti setelah 3 menit
   - Setelah auto-stop, alarm akan snooze otomatis

4. **Auto-Restart (Snooze)**
   - Setelah alarm berhenti (auto-stop atau manual snooze)
   - Alarm akan berbunyi lagi setelah 5 menit
   - Dapat dimatikan dengan tombol "Stop"

### 📱 Cara Menggunakan

1. **Menambah Alarm**
   - Tap tombol `+` di kanan bawah
   - Pilih waktu alarm
   - Alarm otomatis aktif

2. **Menghidupkan/Mematikan Alarm**
   - Toggle switch di samping waktu alarm
   - Hijau = aktif, Abu-abu = nonaktif

3. **Menghapus Alarm**
   - Tap icon hapus (trash) di samping alarm

4. **Saat Alarm Berbunyi**
   - Layar alarm otomatis muncul
   - **Tombol Stop**: Matikan alarm sepenuhnya
   - **Tombol Snooze**: Tunda alarm 5 menit

### 🔧 Implementasi Teknis

#### File-file Penting:
- `lib/core/services/alarm_service.dart` - Service utama alarm
- `lib/features/alarm/data/models/alarm_model.dart` - Model data alarm
- `lib/features/alarm/presentation/pages/alarm_page.dart` - Halaman daftar alarm
- `lib/features/alarm/presentation/pages/alarm_ringing_screen.dart` - Layar alarm berbunyi

#### Dependencies:
- `audioplayers` - Audio playback (backup)
- `vibration` - Vibrasi device
- `shared_preferences` - Penyimpanan alarm
- `flutter_local_notifications` - Notifikasi (future use)
- `android_alarm_manager_plus` - Background alarm (future use)

#### Permissions (Android):
- `VIBRATE` - Untuk getaran
- `WAKE_LOCK` - Untuk menjaga alarm tetap berjalan

### ⏰ Timeline Alarm

```
Alarm Set (07:00)
    ↓
Alarm Rings (07:00)
    ↓
[3 minutes beeping + vibration]
    ↓
Auto-Stop (07:03)
    ↓
[5 minutes silent]
    ↓
Auto-Restart (07:08)
    ↓
[Repeat cycle]
```

### 🎯 Customization

Untuk mengubah durasi:
- **Max ring duration**: Edit `maxRingDuration` di `alarm_service.dart` (default: 180 detik = 3 menit)
- **Snooze interval**: Edit `snoozeInterval` di `alarm_service.dart` (default: 300 detik = 5 menit)
- **Beep pattern**: Edit pattern di `_playSystemBeep()` (default: 400ms per beep)
- **Vibration pattern**: Edit array `pattern` di `_startRinging()` (default: [0, 500, 200, 500, 200, 500, 200])

### 🐛 Troubleshooting

**Alarm tidak berbunyi:**
- Pastikan alarm dalam status ON (toggle hijau)
- Cek volume device tidak dalam mode silent
- Pastikan app memiliki permission yang diperlukan

**Vibrasi tidak bekerja:**
- Pastikan device mendukung vibrasi
- Cek permission VIBRATE sudah disetujui
- Pastikan device tidak dalam mode hemat baterai ekstrem

**Alarm tidak muncul di waktu yang tepat:**
- Service cek alarm setiap 10 detik
- Jadi alarm bisa berbunyi dalam range ±10 detik dari waktu yang diset
