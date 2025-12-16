# Push Notification Feature untuk Alarm & Timer

## Fitur Baru

Aplikasi ini sekarang mendukung **push notification** untuk alarm dan timer dengan pengingat otomatis:

### Notifikasi Alarm
- ⏰ **1 jam sebelum alarm berbunyi**: Notifikasi pengingat pertama
- ⏰ **10 menit sebelum alarm berbunyi**: Notifikasi pengingat kedua
- 🔔 Notifikasi akan dijadwalkan ulang otomatis untuk alarm berulang
- ❌ Notifikasi akan dihapus otomatis saat alarm dihapus atau dinonaktifkan

### Notifikasi Timer
- ⏲️ **1 jam sebelum timer selesai**: Notifikasi pengingat pertama
- ⏲️ **10 menit sebelum timer selesai**: Notifikasi pengingat kedua
- ❌ Notifikasi akan dihapus otomatis saat timer dihentikan, direset, atau dibatalkan
- ℹ️ Notifikasi hanya dijadwalkan untuk timer dengan durasi lebih dari 11 menit

## Cara Kerja

### Alarm
1. Saat alarm baru ditambahkan, sistem otomatis menjadwalkan 2 notifikasi
2. Saat alarm diupdate, notifikasi lama dihapus dan yang baru dijadwalkan
3. Saat alarm dihapus, semua notifikasi terkait langsung dibatalkan
4. Saat alarm dinonaktifkan, notifikasi langsung dibatalkan
5. Untuk alarm berulang, notifikasi dijadwalkan ulang setelah alarm berbunyi

### Timer
1. Saat timer dimulai dengan durasi > 11 menit, sistem menjadwalkan 2 notifikasi
2. Saat timer dihentikan, semua notifikasi langsung dibatalkan
3. Saat timer direset, semua notifikasi langsung dibatalkan
4. Jika timer < 11 menit, notifikasi tidak dijadwalkan

## Permission Android

Aplikasi menggunakan permission berikut:
- `SCHEDULE_EXACT_ALARM`: Untuk penjadwalan notifikasi tepat waktu (Android 12+)
- `USE_EXACT_ALARM`: Untuk alarm tepat waktu (Android 12+)
- `POST_NOTIFICATIONS`: Untuk menampilkan notifikasi (Android 13+)
- `RECEIVE_BOOT_COMPLETED`: Untuk mempertahankan notifikasi setelah reboot

## Implementasi Teknis

### File yang Dimodifikasi/Dibuat:
1. **`lib/core/services/notification_service.dart`** (BARU)
   - Service utama untuk mengelola notifikasi lokal
   - Menggunakan `flutter_local_notifications` dan `timezone`
   - Mendukung scheduling notifikasi dengan waktu tepat

2. **`lib/core/services/alarm_service.dart`** (DIUPDATE)
   - Integrasi dengan notification service
   - Auto-schedule notifikasi saat alarm dibuat/diupdate
   - Auto-cancel notifikasi saat alarm dihapus
   - Re-schedule notifikasi untuk alarm berulang

3. **`lib/core/services/time_service.dart`** (DIUPDATE)
   - Integrasi dengan notification service
   - Auto-schedule notifikasi saat timer dimulai
   - Auto-cancel notifikasi saat timer dihentikan/direset

4. **`android/app/src/main/AndroidManifest.xml`** (DIUPDATE)
   - Penambahan permission yang diperlukan

5. **`pubspec.yaml`** (DIUPDATE)
   - Penambahan dependencies:
     - `flutter_local_notifications: ^18.0.1`
     - `timezone: ^0.10.0`

## Icon Notifikasi

Notifikasi menggunakan **icon yang sama dengan launcher** aplikasi (`@mipmap/ic_launcher`). Ini memastikan konsistensi visual antara aplikasi dan notifikasi.

### Konfigurasi Icon:
```dart
const AndroidNotificationDetails(
  'alarm_timer_channel',
  'Alarm & Timer',
  icon: '@mipmap/ic_launcher', // Icon sama dengan launcher
  importance: Importance.high,
  priority: Priority.high,
);
```

Icon diambil dari:
- **Android**: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS**: Icon otomatis menggunakan app icon

## Bug Fixes

### ✅ Bug yang Diperbaiki:
1. **Service tidak terhapus saat data dihapus**: 
   - Sekarang saat alarm/timer dihapus, semua service dan notifikasi terkait langsung dibersihkan
   
2. **Notifikasi tetap muncul setelah alarm/timer dihapus**:
   - Implementasi proper cleanup untuk semua notifikasi terjadwal
   
3. **Memory leak dari timer/alarm yang tidak dibersihkan**:
   - Proper disposal dan cancellation untuk semua timer dan notifikasi

## Testing

Untuk menguji fitur ini:

### Test Alarm:
1. Buat alarm baru dengan waktu 2 jam dari sekarang
2. Cek apakah notifikasi muncul 1 jam sebelumnya
3. Cek apakah notifikasi muncul 10 menit sebelumnya
4. Hapus alarm sebelum berbunyi dan pastikan notifikasi tidak muncul lagi

### Test Timer:
1. Set timer dengan durasi 1 jam 30 menit
2. Start timer
3. Cek apakah notifikasi muncul 30 menit kemudian (1 jam sebelum selesai)
4. Stop timer dan pastikan notifikasi 10 menit tidak muncul

## Catatan
- Timezone default diset ke `Asia/Jakarta`, bisa disesuaikan di `notification_service.dart`
- Notifikasi menggunakan channel `alarm_timer_channel` dengan importance HIGH
- Semua notifikasi ID digenerate dari hash string untuk menghindari konflik
