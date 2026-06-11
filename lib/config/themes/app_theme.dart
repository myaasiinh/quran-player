import 'dart:io';

import '/config/themes/app_colors.dart';
import '/config/themes/app_typography.dart';
import '/config/themes/default_typography.dart';
import '/config/themes/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Kelas [AppTheme] menyediakan pengaturan tema utama (terang dan gelap)
/// yang digunakan secara menyeluruh di dalam aplikasi.
/// 
/// Kelas ini mengelompokkan semua konfigurasi visual seperti warna,
/// tipografi, dan gaya komponen UI agar konsisten di seluruh layar.
class AppTheme {
  /// Mengembalikan konfigurasi [ThemeData] yang digunakan untuk mode terang (Light Mode).
  /// 
  /// Mengatur berbagai aspek visual seperti warna dasar, font, gaya input,
  /// dan elemen UI lainnya yang sesuai dengan tema terang aplikasi.
  static ThemeData get light {
    // Membuat dan mengembalikan objek ThemeData untuk mode terang
    return ThemeData(
      // Mengatur palet dasar skema warna dari warna utama aplikasi.
      // Menggunakan `ColorScheme.fromSeed` untuk menghasilkan skema warna yang harmonis
      // berdasarkan warna bibit (seed color).
      colorScheme: ColorScheme.fromSeed(
        // Warna utama aplikasi sebagai dasar warna
        seedColor: AppColors.primary,
        // Warna permukaan (surface tint) diatur menjadi putih
        surfaceTint: Colors.white,
      ),
      
      // Menerapkan font Poppins sebagai font bawaan (default) pada tema keseluruhan aplikasi.
      fontFamily: FontFamily.poppins,
      
      // Pengaturan khusus visual elemen input atau form (seperti TextField).
      inputDecorationTheme: inputDecorationTheme(),
      
      // Pengaturan desain standar elemen kotak centang (checkbox).
      checkboxTheme: checkboxThemeData(),
      
      // Pengaturan desain standar elemen opsi radio (radio button).
      radioTheme: radioThemeData(),
      
      // Pengaturan desain standar elemen sakelar (switch atau toggle).
      switchTheme: switchThemeData(),
      
      // Desain standar panel navigasi bagian bawah layar (bottom navigation bar).
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        // Warna ikon dan teks saat item dipilih menjadi warna utama
        selectedItemColor: AppColors.primary,
        // Warna ikon dan teks saat item tidak dipilih menjadi abu-abu
        unselectedItemColor: Colors.grey,
      ),
      
      // Desain bilah aplikasi (AppBar) di bagian atas layar.
      appBarTheme: const AppBarTheme(
        // Menghilangkan efek warna tint pada permukaan AppBar agar transparan
        surfaceTintColor: Colors.transparent,
        // Mengatur gaya overlay sistem seperti bilah status (status bar) dan navigasi sistem
        systemOverlayStyle: SystemUiOverlayStyle(
          // Kecerahan bilah status diatur ke terang (teks/ikon akan berwarna gelap)
          statusBarBrightness: Brightness.light,
          // Warna latar belakang bilah navigasi sistem (di bagian bawah layar ponsel) menjadi hitam
          systemNavigationBarColor: Colors.black,
          // Warna latar belakang bilah status (di atas layar) menggunakan warna utama aplikasi
          statusBarColor: AppColors.primary,
        ),
      ),
      
      // Desain standar pemisah antar tab (TabBar).
      // Indikator tab yang aktif menggunakan warna sekunder.
      tabBarTheme: const TabBarThemeData(indicatorColor: AppColors.secondary),
      
      // Deklarasi tipografi bawaan berisikan aturan bentuk dan model teks dasar.
      // Menggunakan konstanta dari [DefaultTypography] agar lebih terstruktur dan rapi.
      textTheme: TextTheme(
        // Teks berukuran sangat besar
        displayLarge: DefaultTypography.displayLarge,
        // Teks berukuran cukup besar
        displayMedium: DefaultTypography.displayMedium,
        // Teks judul berukuran kecil
        titleSmall: DefaultTypography.titleSmall,
        // Teks isi/badan berukuran besar
        bodyLarge: DefaultTypography.bodyLarge,
        // Teks isi/badan berukuran sedang
        bodyMedium: DefaultTypography.bodyMedium,
        // Teks isi/badan berukuran kecil
        bodySmall: DefaultTypography.bodySmall,
        // Teks label berukuran besar (misal untuk tombol)
        labelLarge: DefaultTypography.labelLarge,
        // Teks label berukuran sedang
        labelMedium: DefaultTypography.labelMedium,
        // Teks label berukuran kecil
        labelSmall: DefaultTypography.labelSmall,
      ),
      
      // Implementasi ekstensi tema khusus aplikasi, seperti tipografi tambahan
      // yang diekstensi melalui kelas [AppTypography].
      extensions: const [
        AppTypography(
          // Teks headline ukuran 34 dengan ketebalan ekstra tebal (w800)
          headline1: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          // Teks headline ukuran 26 dengan ketebalan ekstra tebal (w800)
          headline2: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          // Teks headline ukuran 20 dengan ketebalan tebal (w700)
          headline3: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          // Teks headline ukuran 16 dengan ketebalan tebal (w700)
          headline4: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          // Berbagai varian ukuran teks untuk judul (title)
          title1: TextStyle(fontSize: 40),
          title2: TextStyle(fontSize: 34),
          title3: TextStyle(fontSize: 30),
          title4: TextStyle(fontSize: 28),
          // Berbagai varian ukuran teks untuk subjudul (subtitle)
          subtitle1: TextStyle(fontSize: 24),
          subtitle2: TextStyle(fontSize: 20),
          subtitle3: TextStyle(fontSize: 18),
          subtitle4: TextStyle(fontSize: 16),
          // Berbagai varian ukuran teks untuk isi pesan (body)
          body1: TextStyle(fontSize: 14),
          body2: TextStyle(fontSize: 13),
          body3: TextStyle(fontSize: 11),
          // Ukuran teks kecil dan sangat kecil
          small: TextStyle(fontSize: 9),
          verySmall: TextStyle(fontSize: 8),
          // Gaya teks khusus untuk tautan (link) dengan warna biru
          link: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ],
    );
  }

  /// Mengembalikan konfigurasi [ThemeData] yang digunakan untuk mode gelap (Dark Mode).
  /// 
  /// Konfigurasi ini menyesuaikan palet warna, overlay sistem, dan
  /// elemen antarmuka lainnya agar lebih nyaman dilihat pada kondisi cahaya redup.
  static ThemeData get dark {
    // Membuat dan mengembalikan objek ThemeData untuk mode gelap
    return ThemeData(
      // Mengatur palet dasar skema warna dari warna utama aplikasi versi mode gelap.
      colorScheme: ColorScheme.fromSeed(
        // Warna dasar tetap menggunakan warna utama aplikasi
        seedColor: AppColors.primary,
        // Warna permukaan (surface tint) diatur menjadi transparan
        surfaceTint: Colors.transparent,
        // Menentukan kecerahan menjadi gelap (dark mode) untuk penyesuaian otomatis
        brightness: Brightness.dark,
      ),
      
      // Menerapkan font Poppins pada tema keseluruhan aplikasi.
      fontFamily: FontFamily.poppins,
      
      // Pengaturan khusus visual elemen input atau form.
      inputDecorationTheme: inputDecorationTheme(),
      
      // Pengaturan desain standar elemen kotak centang (checkbox).
      checkboxTheme: checkboxThemeData(),
      
      // Pengaturan desain standar elemen opsi radio.
      radioTheme: radioThemeData(),
      
      // Pengaturan desain standar elemen sakelar (switch atau toggle).
      switchTheme: switchThemeData(),
      
      // Memoles gaya dari lembar bawah yang mengapung (bottom sheet) untuk mode gelap.
      bottomSheetTheme: const BottomSheetThemeData(
        // Ketinggian bayangan (elevasi) diatur ke 8 agar lebih menonjol
        elevation: 8,
        // Memberikan bentuk sudut melengkung pada bagian atas kiri dan kanan (radius 24)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      
      // Tema panel navigasi bawah dengan memoles gaya pada bayangan elemen.
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        // Warna item terpilih menggunakan warna utama
        selectedItemColor: AppColors.primary,
        // Warna item tidak terpilih menggunakan warna abu-abu
        unselectedItemColor: Colors.grey,
        // Menambahkan elevasi ringan (bayangan) sebesar 2
        elevation: 2,
      ),
      
      // Adaptasi gaya overlay sistem dari bilah aplikasi (AppBar) untuk mode gelap.
      appBarTheme: AppBarTheme(
        // Mengatur gaya bilah status di sistem sesuai platform
        systemOverlayStyle: SystemUiOverlayStyle(
          // Kecerahan bilah status disesuaikan: gelap untuk iOS/MacOS, terang untuk Android
          statusBarBrightness: Platform.isIOS || Platform.isMacOS
              ? Brightness.dark
              : Brightness.light,
          // Warna bilah navigasi bawah sistem tetap hitam
          systemNavigationBarColor: Colors.black,
          // Warna latar bilah status menggunakan warna utama aplikasi
          statusBarColor: AppColors.primary,
        ),
      ),
      
      // Pengaturan garis indikator tab menggunakan warna sekunder
      tabBarTheme: const TabBarThemeData(indicatorColor: AppColors.secondary),
      
      // Deklarasi tipografi teks dasar menggunakan DefaultTypography
      textTheme: TextTheme(
        displayLarge: DefaultTypography.displayLarge,
        displayMedium: DefaultTypography.displayMedium,
        titleSmall: DefaultTypography.titleSmall,
        bodyLarge: DefaultTypography.bodyLarge,
        bodyMedium: DefaultTypography.bodyMedium,
        bodySmall: DefaultTypography.bodySmall,
        labelLarge: DefaultTypography.labelLarge,
        labelMedium: DefaultTypography.labelMedium,
        labelSmall: DefaultTypography.labelSmall,
      ),
      
      // Ekstensi gaya tipografi khusus aplikasi [AppTypography] untuk mode gelap
      extensions: const [
        AppTypography(
          // Headline ukuran terbesar dengan ketebalan ekstra tebal (w800)
          headline1: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Colors.black, // Menggunakan warna hitam
          ),
          // Headline ukuran cukup besar dengan ketebalan ekstra
          headline2: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          // Headline ukuran sedang dengan ketebalan tebal (w700)
          headline3: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          // Headline ukuran kecil dengan ketebalan tebal
          headline4: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          // Berbagai ukuran teks untuk judul (title)
          title1: TextStyle(fontSize: 40),
          title2: TextStyle(fontSize: 34),
          title3: TextStyle(fontSize: 30),
          title4: TextStyle(fontSize: 28),
          // Berbagai ukuran teks untuk subjudul (subtitle)
          subtitle1: TextStyle(fontSize: 24),
          subtitle2: TextStyle(fontSize: 20),
          subtitle3: TextStyle(fontSize: 18),
          subtitle4: TextStyle(fontSize: 16),
          // Berbagai ukuran teks untuk isi tulisan (body)
          body1: TextStyle(fontSize: 14),
          body2: TextStyle(fontSize: 13),
          body3: TextStyle(fontSize: 11),
          // Ukuran teks kecil dan sangat kecil
          small: TextStyle(fontSize: 9),
          verySmall: TextStyle(fontSize: 8),
          // Gaya teks khusus untuk tautan (link) berwarna biru
          link: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ],
    );
  }

  /// Membuat visual konfigurasi [CheckboxThemeData] untuk komponen Checkbox.
  /// 
  /// Mengatur bentuk kotak centang, warna pinggiran, dan warna isi
  /// berdasarkan status interaksi komponen.
  static CheckboxThemeData checkboxThemeData() {
    return CheckboxThemeData(
      // Bentuk checkbox dengan sudut melengkung ringan (radius 4)
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      // Warna garis tepi (border) checkbox menggunakan abu-abu cerah
      side: const BorderSide(color: Color(0xFFCFCFCF)),
      // Mengatur warna pengisi checkbox secara dinamis berdasarkan state-nya
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        // Jika checkbox dalam kondisi nonaktif (disabled), gunakan warna default bawaan
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        // Jika checkbox sedang dipilih (selected), gunakan warna sekunder aplikasi
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondary;
        }
        // Kondisi lainnya, kembalikan ke nilai default null
        return null;
      }),
    );
  }

  /// Membuat visual konfigurasi [RadioThemeData] untuk komponen RadioButton.
  /// 
  /// Mengatur warna isi opsi radio berdasarkan statusnya saat ini,
  /// misalnya ketika sedang terpilih atau tidak aktif.
  static RadioThemeData radioThemeData() {
    return RadioThemeData(
      // Mengatur warna pengisi radio button secara dinamis
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        states,
      ) {
        // Jika radio button dinonaktifkan, kembalikan warna bawaan null
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        // Jika radio button dipilih, berikan warna sekunder aplikasi
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondary;
        }
        // Jika tidak terpilih, kembalikan null
        return null;
      }),
    );
  }

  /// Membuat visual konfigurasi [SwitchThemeData] untuk komponen Toggle / Switch.
  /// 
  /// Mengatur warna lingkaran penunjuk (thumb) dan jalur (track)
  /// menyesuaikan dengan aksi atau state komponen saat berinteraksi dengan pengguna.
  static SwitchThemeData switchThemeData() {
    return SwitchThemeData(
      // Mengatur warna tombol bulat pada switch (thumb) secara dinamis
      thumbColor: WidgetStateProperty.resolveWith<Color?>((
        states,
      ) {
        // Jika switch dinonaktifkan
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        // Jika switch diaktifkan (selected), gunakan warna utama
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
      // Mengatur warna latar belakang jalur switch (track) secara dinamis
      trackColor: WidgetStateProperty.resolveWith<Color?>((
        states,
      ) {
        // Jika switch dinonaktifkan
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        // Jika switch diaktifkan, gunakan warna sekunder untuk jalurnya
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondary;
        }
        return null;
      }),
    );
  }

  /// Membuat visual konfigurasi [InputDecorationTheme] untuk kolom / area input teks pengguna.
  /// 
  /// Mengatur garis batas (border) saat input sedang aktif, tidak aktif, atau terjadi kesalahan.
  static InputDecorationTheme inputDecorationTheme() {
    return InputDecorationTheme(
      // Garis tepi bawaan untuk kolom input dengan radius sudut 12 dan warna transparan
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      // Garis tepi saat input dalam kondisi diaktifkan (enabled) namun belum difokuskan
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      // Garis tepi saat input sedang diklik atau menjadi fokus (focused), menggunakan warna utama
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      // Garis tepi saat terjadi kesalahan validasi dan elemen sedang difokuskan, menggunakan warna utama
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
