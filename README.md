# 📅 Schedule App Generator with Gemini AI

A powerful Flutter-based application that leverages the intelligence of **Google Gemini AI** to automatically generate, optimize, and manage your daily schedules.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Gemini](https://img.shields.io/badge/Gemini%20AI-4285F4?style=for-the-badge&logo=google-gemini&logoColor=white)](https://ai.google.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

## 🌟 Fitur Utama

-   **AI Schedule Generation**: Masukkan daftar kegiatan atau teks bebas, dan Gemini AI akan menyusun jadwal yang efisien untuk Anda.
-   **Smart Optimization**: Mengatur prioritas tugas secara otomatis berdasarkan urgensi.
-   **Modern UI**: Antarmuka bersih dan responsif yang dibangun dengan Flutter.
-   **Task Management**: Tambah, edit, dan hapus jadwal dengan mudah.
-   **Quick Summary**: Dapatkan ringkasan hari Anda yang dibuat oleh AI.

## 🚀 Teknologi yang Digunakan

-   **Frontend**: [Flutter](https://flutter.dev) (Dart)
-   **AI Engine**: [Google Gemini API](https://ai.google.dev/)
-   **State Management**: Provider / Riverpod (sesuaikan dengan yang Anda gunakan)
-   **Storage**: Local Storage (SharedPreferences / Sqflite)

## 🛠️ Persiapan & Instalasi

### Prasyarat
1.  [Flutter SDK](https://docs.flutter.dev/get-started/install) terinstal di mesin Anda.
2.  Dapatkan **API Key Gemini** secara gratis di [Google AI Studio](https://aistudio.google.com/).

### Langkah-langkah

1.  **Clone Repository**
    ```bash
    git clone [https://github.com/athallahmgq/schedule_app.git](https://github.com/athallahmgq/schedule_app.git)
    cd schedule_app
    ```

2.  **Instal Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi API Key**
    Buat file `.env` di root folder atau tambahkan API key Anda di file konfigurasi yang sesuai:
    ```env
    GEMINI_API_KEY=YOUR_API_KEY_HERE
    ```

4.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## 📸 Screenshots

| Home Screen | AI Generator | Task Details |
| :---: | :---: | :---: |
| ![Home](https://via.placeholder.com/200x400?text=Home+Screen) | ![Generator](https://via.placeholder.com/200x400?text=AI+Generator) | ![Detail](https://via.placeholder.com/200x400?text=Task+Details) |

*(Catatan: Ganti gambar di atas dengan screenshot asli aplikasi Anda)*

## 📂 Struktur Folder
```text
lib/
├── core/          # Konfigurasi, tema, dan utilitas
├── data/          # Model data dan penyedia data (API/Local)
├── providers/     # Logika state management
├── ui/            # Layar (screens) dan widget UI
└── main.dart      # Entry point aplikasi
