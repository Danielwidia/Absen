# Sekolah Kristen Dorkas - Mobile Management System

Aplikasi mobile management untuk Sekolah Kristen Dorkas yang dibangun menggunakan Flutter. Aplikasi ini mencakup fitur untuk Siswa, Guru, Karyawan, dan Admin dengan sistem keamanan Biometrik (FaceID/Fingerprint) dan GPS.

## 🚀 Fitur Utama

### 1. Multi-Role Access
*   **Admin:** Kelola absensi (download laporan), kelola jadwal (kelas, mapel, guru), daftar akun guru & siswa, bank soal, dan atur jadwal ujian.
*   **Guru:** Absensi (FaceID & GPS), jadwal global & mengajar, manajemen soal online, jurnal guru, generate soal AI, penilaian, dan materi pembelajaran.
*   **Siswa:** Absensi (FaceID & GPS), jadwal kelas & piket, struktur kelas, soal online, dan jurnal kelas.
*   **Karyawan:** Absensi, tugas harian, dan laporan kerja.

### 2. Sistem Absensi Canggih
*   **Biometric Security:** Verifikasi FaceID atau Fingerprint saat pendaftaran akun dan setiap kali melakukan absensi.
*   **GPS Tracking:** Memastikan pengguna berada di lokasi sekolah saat melakukan absensi.
*   **Google Sheets Integration:** Laporan absensi otomatis terkirim ke Google Sheets secara real-time.

### 3. Keamanan & Database
*   **Supabase:** Digunakan untuk menyimpan data akun, jadwal, dan bank soal.
*   **Local Auth:** Integrasi dengan sistem keamanan native Android & iOS.

## 🛠️ Persiapan & Instalasi

### Prasyarat
*   Flutter SDK (v3.0.0 atau lebih baru)
*   Dart SDK
*   Android Studio / VS Code

### Langkah Instalasi
1.  Clone repository ini atau download source code.
2.  Buka terminal di root project dan jalankan:
    ```bash
    flutter pub get
    ```
3.  Konfigurasi Supabase:
    Buka `lib/main.dart` dan masukkan URL serta Anon Key Anda:
    ```dart
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
    ```
4.  Konfigurasi Google Sheets:
    Buka `lib/services/attendance_service.dart` dan ganti `googleSheetUrl` dengan URL Web App dari Google Apps Script Anda.

### Menjalankan Aplikasi
```bash
flutter run
```

## 🔑 Akun Default Admin
*   **Username:** `ADM`
*   **Password:** `admin321`

## 📱 Konfigurasi Platform

### Android
*   Pastikan `AndroidManifest.xml` sudah memiliki izin:
    *   `android.permission.USE_BIOMETRIC`
    *   `android.permission.ACCESS_FINE_LOCATION`
*   `MainActivity` menggunakan `FlutterFragmentActivity`.

### iOS
*   Izin FaceID dan Lokasi sudah dikonfigurasi di `Info.plist`.

## 🌐 Deploy ke GitHub
Untuk mengunggah ke GitHub:
1. `git init`
2. `git add .`
3. `git commit -m "Initial commit Sekolah Dorkas"`
4. `git remote add origin https://github.com/USERNAME/REPO_NAME.git`
5. `git push -u origin master`

---
© 2026 Sekolah Kristen Dorkas. All rights reserved.
