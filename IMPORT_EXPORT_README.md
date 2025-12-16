# Import/Export Data Feature

## Deskripsi
Fitur ini memungkinkan pengguna untuk mem-backup dan restore semua data aplikasi Za Time dalam format JSON.

## Data yang Di-export/Import

### 1. Theme Settings
- Warna primary
- Warna background
- Font primary (untuk clock)
- Font secondary (untuk UI)
- Ukuran font (clock, second, stopwatch, timer, dll)
- Warna card background
- Pengaturan snackbar
- Pengaturan tampilan (show day, date, stopwatch, timer)

### 2. Day Label Colors (Clock Page)
- Warna untuk setiap hari dalam seminggu (Senin-Minggu)
- Setiap hari memiliki warna kustom yang dapat diatur

### 3. Stopwatch State
- Status stopwatch saat ini (running/stopped)
- Waktu mulai
- Waktu akumulasi
- History stopwatch per hari

### 4. Timer State
- Status timer saat ini (running/stopped)
- Waktu yang tersisa
- Waktu awal/durasi timer
- Waktu berakhir

### 5. Stopwatch History & Settings
- Riwayat stopwatch harian
- Target jam per hari
- Threshold warna untuk kalender

### 6. Alarms
- Semua alarm yang tersimpan
- Pengaturan alarm (waktu, repeat, dll)

## Cara Menggunakan

### Export Data
1. Buka Settings page
2. Scroll ke bagian "Data Backup"
3. Klik tombol "Export Data"
4. File JSON akan dibuat dengan nama `za_time_backup_[timestamp].json`
5. File disimpan di `aplikasi documents directory`
6. Anda bisa share file tersebut melalui dialog yang muncul

### Import Data
1. Buka Settings page
2. Scroll ke bagian "Data Backup"
3. Klik tombol "Import Data"
4. Pilih file backup JSON yang sudah di-export sebelumnya
5. Konfirmasi import (akan mengganti semua data yang ada)
6. Data akan di-restore dan aplikasi akan refresh

## Format File

File backup berformat JSON dengan struktur:
```json
{
  "export_version": "1.0.0",
  "export_date": "2025-12-16T05:00:00.000Z",
  "theme": { ... },
  "day_colors": { ... },
  "stopwatch": { ... },
  "timer": { ... },
  "stopwatch_history": { ... },
  "alarms": { ... }
}
```

## Dependencies
- `path_provider`: Untuk mendapatkan path directory
- `file_picker`: Untuk memilih file saat import
- `share_plus`: Untuk share file backup

## Notes
- Backup file disimpan di aplikasi's documents directory
- Format JSON memudahkan portabilitas antar device
- Import akan mengganti semua data yang ada (tidak merge)
- Setelah import, semua service akan di-reload otomatis
