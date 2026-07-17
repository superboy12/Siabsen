# Siabsen - Sistem Informasi Absensi Pegawai Berbasis Cloud

Siabsen (Sistem Informasi Absensi) adalah platform kehadiran modern yang dirancang khusus untuk memenuhi standar instansi pemerintahan. Proyek ini memadukan kemudahan aplikasi seluler (*mobile app*) dengan keandalan sistem *backend* berbasis *cloud computing*. 

Aplikasi ini mengunggulkan fitur **Liveness Detection** dengan kecerdasan buatan (Google ML Kit Face Detection) untuk memastikan akurasi data kehadiran pegawai, mencegah kecurangan, dan memberikan antarmuka (*UI/UX*) yang profesional, formal, dan mudah digunakan (Material 3).

---

## 🏗️ Struktur Proyek

Proyek ini terdiri dari dua bagian utama (Monorepo):
1. **`cloud_backend/`**: REST API dan Admin Panel yang dibangun menggunakan Laravel 12.
2. **`cloud_attendance/`**: Aplikasi Mobile/Client yang dibangun menggunakan Flutter.

---

## 📱 Fitur Utama

### Aplikasi Mobile (Flutter)
- **Desain Profesional (Material 3)**: Antarmuka yang rapi dan responsif dengan kombinasi warna *Navy Blue* ala pemerintahan.
- **Liveness Detection & Face Tracking**: Deteksi wajah *real-time* yang dapat mendeteksi kedipan mata (*blink*), anggukan (*nod*), serta arah hadap (*head euler angles*).
- **Sistem Keamanan Kehadiran**: Dilengkapi *random challenge* (tantangan acak) sebelum absensi diproses untuk memastikan liveness pegawai.
- **Navigasi Terintegrasi**: Menggunakan `GoRouter` untuk pengalaman transisi antar layar yang mulus (Dashboard, Profil, Riwayat, Pengaturan).
- **Manajemen State**: Dibangun di atas fondasi arsitektur yang bersih (Clean Architecture) dengan manajemen state `Riverpod`.

### Backend (Laravel 12)
- **RESTful API**: Menyediakan jembatan data yang aman (*secure*) untuk dikonsumsi oleh aplikasi Flutter melalui autentikasi Laravel Sanctum.
- **Manajemen Data Kehadiran**: Logika pencatatan Check In dan Check Out pegawai.
- **Admin Dashboard & Pelaporan**: Fitur pengolahan dan rekapitulasi data absensi, lengkap dengan fitur Ekspor ke Excel (Menggunakan package *Maatwebsite/Excel*).
- **Clean Architecture & Repository Pattern**: Kode yang terstruktur dengan memisahkan *Controller*, *Service*, dan *Repository*.

---

## 🚀 Cara Instalasi dan Menjalankan

### Persyaratan Sistem
- **Flutter SDK**: Versi 3.12+ 
- **PHP**: Versi 8.3+ (Untuk Laravel)
- **Composer**: Untuk dependensi PHP
- **Database**: PostgreSQL / MySQL
- **Perangkat Mobile**: Emulator Android / iOS atau perangkat nyata (Fitur Kamera ML Kit HANYA bekerja pada OS Android/iOS).

### Menjalankan Backend (Laravel)
```bash
cd cloud_backend
composer install
cp .env.example .env
# Konfigurasi koneksi database Anda di file .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

### Menjalankan Mobile App (Flutter)
```bash
cd cloud_attendance
flutter pub get
# Jalankan pada emulator atau perangkat fisik Android/iOS yang terhubung
flutter run
```

---

## 🛠️ Teknologi yang Digunakan
- **Frontend**: [Flutter](https://flutter.dev/), Riverpod, GoRouter, Google ML Kit Face Detection.
- **Backend**: [Laravel 12](https://laravel.com/), Sanctum, Laravel Excel.

---

## 🔒 Lisensi
Dikembangkan untuk keperluan internal dan prototipe Sistem Informasi Pemerintahan. Seluruh hak cipta dan modifikasi diserahkan sepenuhnya kepada pemilik repositori.
