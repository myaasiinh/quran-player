import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_player/config/environment/app_env.dart';
import 'package:quran_player/config/themes/app_theme.dart';
import 'package:quran_player/config/themes/theme_manager.dart';
import 'package:quran_player/core/localization/app_translations.dart';
import 'package:quran_player/core/localization/locale_manager.dart';
import 'package:quran_player/service_locator.dart';
import 'package:quran_player/ui/routes/app_routes.dart';
import 'package:quran_player/ui/views/404_500/crash_error_view.dart';
import 'package:quran_player/ui/views/404_500/unknown_page.dart';

/// Fungsi utama [main] merupakan gerbang masuk awal sekaligus titik eksekusi pertama dari seluruh aplikasi.
/// Principal Engineer Note: Menggunakan pola async main (asinkronus) demi memastikan
/// seluruh dependensi kritikal (seperti Storage, Dependency Injection, dan pengenalan Environment) 
/// telah selesai dimuat sebelum antarmuka (UI) mulai dirender ke layar pengguna.
void main() async {
  // Menjamin kerangka kerja (framework) dasar Flutter telah terinisialisasi dan tersambung dengan mulus ke platform host (iOS/Android).
  WidgetsFlutterBinding.ensureInitialized();

  // Memulai sinkronisasi pemuatan pendaftaran (registrasi) dependensi kelas injeksi melalui Service Locator.
  await ServiceLocator.init();

  // Melakukan evaluasi terhadap lingkungan eksekusi saat ini
  if (AppEnv.env.isDev) {
    // Mode Development (Pengembangan): 
    // Menggunakan package DevicePreview untuk menguji responsivitas berbagai ukuran layar gawai di simulator/emulator.
    runApp(DevicePreview(builder: (context) => const App()));
  } else {
    // Mode Production/Staging (Siap Rilis / Publikasi): 
    // Menginisialisasi basis format pelokalan sistem tanggal spesifik zona Indonesia ('id').
    await initializeDateFormatting('id');
    // Menjalankan aplikasi secara murni tanpa bantuan alat testing.
    runApp(const App());
  }
}

/// [App] berfungsi sebagai super-parent (root widget) di puncak hierarki aplikasi.
/// Objek ini bertugas merakit integrasi inti seperti: pengonfigurasian tema, tata kelola routing navigasi, 
/// hingga penyetelan lokalisasi ragam bahasa.
class App extends StatelessWidget {
  /// Konstruktor statis komponen App.
  const App({super.key});

  /// Blok pembangunan pondasi elemen penampil visual (UI).
  @override
  Widget build(BuildContext context) {
    // Menggunakan GetX sebagai listener pada tipe ThemeManager 
    // agar dapat mengawasi reaktivitas pergantian antara tema Terang (Light) dan Gelap (Dark).
    return GetX<ThemeManager>(
      // Builder akan merender ulang jika terdapat perubahan dalam subjek theme
      builder: (theme) => GetMaterialApp(
        // Menyembunyikan spanduk kecil merah 'DEBUG' yang biasa nangkring di pojok kanan atas aplikasi masa dev.
        debugShowCheckedModeBanner: false,
        // Menyematkan judul resmi untuk referensi aplikasi pada tingkat sistem task manager perangkat (OS).
        title: 'Quran Player',
        
        // --- Konfigurasi Tema Global ---
        // Mendeklarasikan skema perwajahan versi cerah.
        theme: AppTheme.light,
        // Mendeklarasikan skema perwajahan versi pekat.
        darkTheme: AppTheme.dark,
        // Mengamati flag reactive apakah sedang memakai dark mode atau sebaliknya.
        themeMode: (theme.isDark.isTrue) ? ThemeMode.dark : ThemeMode.light,
        
        // --- Konfigurasi Lokalisasi (Multi-bahasa) ---
        // Kamus berisi himpunan terjemahan kalimat per kunci lokal aplikasi (Bahasa).
        translations: AppTranslation(),
        // Memungut rekaman pilihan kode bahasa yang saat ini disukai oleh user dari LocaleManager.
        locale: LocaleManager.find.getCurrentLocale,
        // Menyediakan bahasa rujukan andai deteksi bahasa pertama keliru atau gagal dikalkulasi (English).
        fallbackLocale: LocaleManager.find.fallbackLocale,
        // Menentukan delegasi kelas material sistem penentu kaidah penyajian lokalisasi komponen OS.
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // Merangkum rentetan pilihan dialek bahasa valid yang diperbolehkan di aplikasi ini.
        supportedLocales: LocaleManager.find.locales.values,
        
        // --- Konfigurasi Routing / Navigasi Halaman ---
        // Mengalokasikan kumpulan daftar definisi seluruh jalur jalan antarmuka (Routing Table).
        getPages: AppPages.routes,
        // Menyebutkan kode lokasi layar apa yang harus pertama dituju persis sehabis startup.
        initialRoute: AppPages.initial,
        // Alamat tangkap (Fallback Route) ke layar unknown andai kode navigasi tiada dalam daftar routes.
        unknownRoute: unknownPage,
        
        // Builder ini membungkus struktur paling luar guna menangkap malfungsi (exception) yang belum tertangani di tingkat komponen UI.
        builder: (context, child) {
          // Mereplace mekanisme error penampil "Layar Merah Maut (Red Screen of Death)" khas bawaan flutter 
          // ke widget kustom CrashErrorView buatan sendiri yang jauh lebih ramah pengguna.
          ErrorWidget.builder = (error) {
            return CrashErrorView(errorDetails: error);
          };
          // Mengeksekusi anak rute sebagaimana aslinya jika tak ada error.
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
