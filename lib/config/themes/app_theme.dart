import 'dart:io';

import '/config/themes/app_colors.dart';
import '/config/themes/app_typography.dart';
import '/config/themes/default_typography.dart';
import '/config/themes/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Kelas [AppTheme] menyediakan pengaturan tema utama (cahaya dan gelap)
/// yang digunakan secara menyeluruh di dalam aplikasi.
class AppTheme {
  /// Mengembalikan konfigurasi [ThemeData] yang digunakan untuk mode terang (Light Mode).
  static ThemeData get light {
    return ThemeData(
      // Mengatur palet dasar skema warna dari warna utama aplikasi.
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surfaceTint: Colors.white,
      ),
      // Menerapkan font Poppins pada tema keseluruhan aplikasi.
      fontFamily: FontFamily.poppins,
      
      // Pengaturan khusus visual elemen input atau form.
      inputDecorationTheme: inputDecorationTheme(),
      
      // Pengaturan desain standar elemen checkbox.
      checkboxTheme: checkboxThemeData(),
      
      // Pengaturan desain standar elemen opsi radio.
      radioTheme: radioThemeData(),
      
      // Pengaturan desain standar elemen switch (toggle).
      switchTheme: switchThemeData(),
      
      // Desain standar panel navigasi bagian bawah layar.
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      
      // Desain bilah aplikasi (AppBar) dibagian atas layar.
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          statusBarColor: AppColors.primary,
        ),
      ),
      
      // Desain pemisah antar tab menggunakan warna sekunder.
      tabBarTheme: const TabBarThemeData(indicatorColor: AppColors.secondary),
      
      // Deklarasi tipografi default berisikan aturan bentuk dan model teks dasar.
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
      
      // Implementasi font yang diekstensi lewat [AppTypography].
      extensions: const [
        AppTypography(
          headline1: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          title1: TextStyle(fontSize: 40),
          title2: TextStyle(fontSize: 34),
          title3: TextStyle(fontSize: 30),
          title4: TextStyle(fontSize: 28),
          subtitle1: TextStyle(fontSize: 24),
          subtitle2: TextStyle(fontSize: 20),
          subtitle3: TextStyle(fontSize: 18),
          subtitle4: TextStyle(fontSize: 16),
          body1: TextStyle(fontSize: 14),
          body2: TextStyle(fontSize: 13),
          body3: TextStyle(fontSize: 11),
          small: TextStyle(fontSize: 9),
          verySmall: TextStyle(fontSize: 8),
          link: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ],
    );
  }

  /// Mengembalikan konfigurasi [ThemeData] yang digunakan untuk mode gelap (Dark Mode).
  static ThemeData get dark {
    return ThemeData(
      // Mengatur palet dasar skema warna dari warna utama aplikasi versi mode gelap.
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surfaceTint: Colors.transparent,
        brightness: Brightness.dark,
      ),
      fontFamily: FontFamily.poppins,
      inputDecorationTheme: inputDecorationTheme(),
      checkboxTheme: checkboxThemeData(),
      radioTheme: radioThemeData(),
      switchTheme: switchThemeData(),
      
      // Memoles gaya dari lembar bawah yang mengapung (bottom sheet).
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      
      // Tema panel navigasi bawah dengan memoles gaya sedikit pada bayangan elemen.
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        elevation: 2,
      ),
      
      // Adaptasi system overlay dari bilah aplikasi (AppBar).
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Platform.isIOS || Platform.isMacOS
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: Colors.black,
          statusBarColor: AppColors.primary,
        ),
      ),
      tabBarTheme: const TabBarThemeData(indicatorColor: AppColors.secondary),
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
      extensions: const [
        AppTypography(
          headline1: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          title1: TextStyle(fontSize: 40),
          title2: TextStyle(fontSize: 34),
          title3: TextStyle(fontSize: 30),
          title4: TextStyle(fontSize: 28),
          subtitle1: TextStyle(fontSize: 24),
          subtitle2: TextStyle(fontSize: 20),
          subtitle3: TextStyle(fontSize: 18),
          subtitle4: TextStyle(fontSize: 16),
          body1: TextStyle(fontSize: 14),
          body2: TextStyle(fontSize: 13),
          body3: TextStyle(fontSize: 11),
          small: TextStyle(fontSize: 9),
          verySmall: TextStyle(fontSize: 8),
          link: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ],
    );
  }

  /// Membuat visual konfigurasi [CheckboxThemeData] untuk komponen Checkbox.
  static CheckboxThemeData checkboxThemeData() {
    return CheckboxThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      side: const BorderSide(color: Color(0xFFCFCFCF)),
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondary;
        }
        return null;
      }),
    );
  }

  /// Membuat visual konfigurasi [RadioThemeData] untuk komponen RadioButton.
  static RadioThemeData radioThemeData() {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondary;
        }
        return null;
      }),
    );
  }

  /// Membuat visual konfigurasi [SwitchThemeData] untuk komponen Toggle / Switch.
  static SwitchThemeData switchThemeData() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((
        states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((
        states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.secondary;
        }
        return null;
      }),
    );
  }

  /// Membuat visual konfigurasi [InputDecorationTheme] untuk kolom / area input teks dari pengguna.
  static InputDecorationTheme inputDecorationTheme() {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
