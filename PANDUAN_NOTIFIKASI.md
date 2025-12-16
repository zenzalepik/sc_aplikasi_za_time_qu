# 🔔 Panduan Pengguna - Notifikasi Alarm & Timer

## Fitur Notifikasi Otomatis

Aplikasi ZaTimeQu sekarang dilengkapi dengan notifikasi pintar yang akan mengingatkan Anda sebelum alarm berbunyi atau timer selesai!

---

## ⏰ Notifikasi Alarm

### Kapan Notifikasi Muncul?
- **1 Jam Sebelumnya**: Pengingat pertama
- **10 Menit Sebelumnya**: Pengingat kedua (final reminder)

### Contoh Penggunaan:

#### Skenario 1: Alarm Sekali
```
Anda set alarm pukul 07:00
→ Notifikasi 1: Pukul 06:00 - "1 jam lagi alarm akan berbunyi"
→ Notifikasi 2: Pukul 06:50 - "10 menit lagi alarm akan berbunyi"
→ Alarm berbunyi: Pukul 07:00
```

#### Skenario 2: Alarm Berulang (Senin-Jumat)
```
Anda set alarm pukul 05:30 untuk Senin-Jumat
→ Setiap Senin-Jumat:
  - Pukul 04:30: Notifikasi "1 jam lagi"
  - Pukul 05:20: Notifikasi "10 menit lagi"
  - Pukul 05:30: Alarm berbunyi
→ Notifikasi otomatis dijadwalkan ulang untuk hari berikutnya
```

#### Skenario 3: Menghapus Alarm
```
Anda hapus alarm sebelum berbunyi
→ Semua notifikasi terjadwal langsung dibatalkan
→ Tidak ada notifikasi yang akan muncul
✓ Bebas bug!
```

---

## ⏲️ Notifikasi Timer

### Kapan Notifikasi Muncul?
- **1 Jam Sebelumnya**: Jika timer > 1 jam
- **10 Menit Sebelumnya**: Jika timer > 10 menit
- **Tidak Ada Notifikasi**: Jika timer ≤ 10 menit (terlalu pendek)

### Contoh Penggunaan:

#### Skenario 1: Timer Lama (2 jam)
```
Anda set timer 2 jam (120 menit)
→ Start pukul 14:00
→ Notifikasi 1: Pukul 15:00 - "1 jam lagi timer akan selesai"
→ Notifikasi 2: Pukul 15:50 - "10 menit lagi timer akan selesai"
→ Timer selesai: Pukul 16:00
```

#### Skenario 2: Timer Sedang (30 menit)
```
Anda set timer 30 menit
→ Start pukul 10:00
→ Notifikasi: Pukul 10:20 - "10 menit lagi timer akan selesai"
→ Timer selesai: Pukul 10:30
(Tidak ada notifikasi 1 jam karena timer < 1 jam)
```

#### Skenario 3: Timer Pendek (5 menit)
```
Anda set timer 5 menit
→ Tidak ada notifikasi (timer terlalu pendek)
→ Timer langsung berbunyi setelah 5 menit
```

#### Skenario 4: Menghentikan Timer
```
Timer sedang berjalan, Anda klik "Stop" atau "Reset"
→ Semua notifikasi terjadwal langsung dibatalkan
→ Tidak ada notifikasi yang akan muncul
✓ Bebas bug!
```

---

## 🔧 Tips Penggunaan

### ✅ DO (Lakukan):
1. **Izinkan Notifikasi**: Pastikan aplikasi memiliki izin notifikasi
2. **Jangan Batalkan di Tengah Jalan**: Jika Anda tidak ingin notifikasi, hapus/matikan alarm atau stop timer
3. **Gunakan Label**: Beri label pada alarm agar notifikasi lebih jelas

### ❌ DON'T (Hindari):
1. **Force Close Aplikasi**: Biarkan aplikasi berjalan di background
2. **Clear App Data**: Akan menghapus semua alarm dan timer
3. **Nonaktifkan Notifikasi Sistem**: Notifikasi tidak akan muncul

---

## 🐛 Bug yang Sudah Diperbaiki

| Bug Lama                                    | Solusi Baru                    |
| ------------------------------------------- | ------------------------------ |
| Notifikasi tetap muncul meski alarm dihapus | ✅ Auto-cancel saat hapus alarm |
| Service timer tidak terhapus saat reset     | ✅ Proper cleanup di semua aksi |
| Memory leak dari notifikasi                 | ✅ Semua resource dibersihkan   |
| Notifikasi duplikat saat update alarm       | ✅ Cancel old, schedule new     |

---

## 📱 Permission yang Dibutuhkan

Saat pertama kali membuka aplikasi, Anda mungkin diminta izin:

1. **Notifikasi** (Android 13+)
   - Untuk menampilkan pengingat
   - Klik "Izinkan" / "Allow"

2. **Alarm & Reminder** (Android 12+)
   - Untuk penjadwalan tepat waktu
   - Klik "Izinkan" / "Allow"

---

## ❓ FAQ

**Q: Kenapa notifikasi tidak muncul?**
A: Pastikan:
- Izin notifikasi sudah diberikan
- Battery optimization tidak membatasi aplikasi
- Notifikasi aplikasi tidak di-silent

**Q: Apakah notifikasi akan muncul jika HP dalam mode silent?**
A: Ya, notifikasi tetap muncul (visual), tapi tidak bersuara

**Q: Apakah notifikasi akan tetap ada setelah restart HP?**
A: Alarm yang sudah terjadwal akan otomatis dijadwalkan ulang

**Q: Berapa lama sebelumnya notifikasi muncul?**
A: Selalu 1 jam dan 10 menit sebelum waktu target

---

## 💡 Saran Penggunaan

### Untuk Bangun Pagi:
```
Set alarm 06:00 dengan label "Bangun Pagi"
→ 05:00: Notifikasi "Bangun Pagi - 1 jam lagi"
→ 05:50: Notifikasi "Bangun Pagi - 10 menit lagi"
→ 06:00: Alarm berbunyi
```

### Untuk Memasak:
```
Set timer 45 menit untuk "Masak Nasi"
→ 35 menit kemudian: "Masak Nasi - 10 menit lagi"
→ Timer selesai
```

### Untuk Meeting:
```
Set alarm 14:00 Senin-Jumat "Meeting Tim"
→ Setiap hari kerja dapat pengingat otomatis
```

---

Selamat menggunakan fitur notifikasi! 🎉
