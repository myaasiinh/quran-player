import 'package:flutter/material.dart';

/* author
   myaasiinh@gmail.com
*/

/// [AppColors] mendefinisikan palet warna global aplikasi.
/// Principal Note: Menggunakan kombinasi warna spiritual yang menenangkan
/// (Deep Blue & Golden Sand) untuk kenyamanan visual jangka panjang.
abstract class AppColors {
  /// Warna Utama: Deep Spiritual Blue.
  static const Color primary = Color(0xFF0F4C81);
  static const Color primaryDark = Color(0xFF0A3656);
  static const Color primaryDarkest = Color(0xFF072439);
  static const Color primaryLight = Color(0xFFE3F2FD);

  /// Warna Sekunder: Warm Golden Sand (Aksen Premium).
  static const Color secondary = Color(0xFFD4AF37);
  static const Color accent = Color(0xFFF9A825);

  /// Warna Dasar Permukaan.
  static const Color black = Color(0xFF121212);
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF5F7FA);

  /// Warna Status Sistem.
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  /// Palette Shades untuk konsistensi desain UI.
  static const Color shadesPrimary10 = Color(0xFFE1F5FE);
  static const Color shadesPrimary20 = Color(0xFFB3E5FC);
  static const Color textColor80 = Color(0xFF424242);
  static const Color textColor100 = Color(0xFF212121);
}
