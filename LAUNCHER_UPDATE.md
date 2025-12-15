# Update Launcher Icon dan Label Aplikasi

## ✅ Perubahan yang Dilakukan:

### 1. **Label Aplikasi Diubah menjadi "ZaTimeQu"**
   - File: `android/app/src/main/AndroidManifest.xml`
   - Label lama: `sc_aplikasi_za_time_qu`
   - Label baru: **`ZaTimeQu`**
   - Berlaku untuk:
     - App launcher (home screen)
     - Recent apps / Task switcher (tombol multitasking)
     - Settings → Apps

### 2. **Launcher Icon di Recent Apps Diperbaiki**
   - Menggunakan `flutter_launcher_icons` untuk generate icon
   - Icon source: `assets/logo_app.png`
   - Icon ter-generate untuk semua ukuran Android:
     - mipmap-mdpi (48x48)
     - mipmap-hdpi (72x72)
     - mipmap-xhdpi (96x96)
     - mipmap-xxhdpi (144x144)
     - mipmap-xxxhdpi (192x192)
   - Adaptive icon dengan background hitam (#000000)

## 📱 Cara Melihat Perubahan:

1. **Rebuild aplikasi**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test di Recent Apps**:
   - Buka aplikasi
   - Tekan tombol **Recent Apps** / **Multitasking** (tombol kotak/list di navigation bar)
   - Logo dan nama "ZaTimeQu" sekarang akan muncul dengan benar

## 🔧 File yang Diubah:

1. `android/app/src/main/AndroidManifest.xml` - Label aplikasi
2. `pubspec.yaml` - Konfigurasi flutter_launcher_icons
3. Icon files di `android/app/src/main/res/mipmap-*/` - Auto-generated

## 💡 Catatan:

- Icon di Recent Apps menggunakan file yang sama dengan launcher icon
- Jika ingin mengubah icon, ganti file `assets/logo_app.png` lalu jalankan:
  ```bash
  dart run flutter_launcher_icons
  ```
- Icon adaptive menggunakan background hitam agar sesuai dengan tema dark aplikasi

## 🎯 Nama Tombol yang Anda Sebutkan:

Tombol tersebut memiliki beberapa nama:
- **Recent Apps** (paling umum)
- **Overview button** 
- **Multitasking button**
- **Task switcher**

Di layar itu, aplikasi akan menampilkan:
- ✅ Icon: Logo aplikasi (dari `logo_app.png`)
- ✅ Nama: **ZaTimeQu**
- ✅ Preview: Screenshot terakhir aplikasi
