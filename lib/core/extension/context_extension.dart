import '/config/themes/app_typography.dart';
import 'package:flutter/material.dart';

/// Ekstensi pada [BuildContext] untuk mempermudah akses properti tema dan gaya.
extension ContextExtension on BuildContext {
  /// Mengambil [ColorScheme] dari tema saat ini.
  /// 
  /// Memudahkan akses ke skema warna seperti `context.colorScheme`.
  ColorScheme? get colorScheme => Theme.of(this).colorScheme;

  /// Mengecek apakah tema aplikasi saat ini menggunakan mode gelap (Dark Mode).
  /// 
  /// Mengembalikan [true] jika brightness dari tema adalah [Brightness.dark].
  bool get isDarkMode {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark;
  }

  /// Mengambil custom typography [AppTypography] dari ekstensi tema saat ini.
  /// 
  /// Memastikan bahwa [AppTypography] telah ditambahkan ke dalam `ThemeData.extensions`.
  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;

  /// Mengambil [TextTheme] dari tema saat ini.
  /// 
  /// Memudahkan akses ke properti teks seperti `context.textTheme`.
  TextTheme get textTheme => Theme.of(this).textTheme;
}
