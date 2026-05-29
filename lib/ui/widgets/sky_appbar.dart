import 'package:flutter/material.dart';
import 'package:quran_player/config/themes/app_colors.dart';
import 'package:quran_player/ui/widgets/base/base_appbar.dart';

/* author
   myaasiinh@gmail.com
*/

/// [SkyAppBar] menyediakan desain AppBar terstandarisasi untuk aplikasi.
/// Principal Note: Menggunakan pola factory method untuk konsistensi visual di seluruh layar.
abstract class SkyAppBar {
  /// [primary] AppBar standar dengan background warna utama.
  static PreferredSizeWidget primary({
    required String title,
    bool centerTitle = false,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    double? elevation,
  }) {
    return BaseAppBar(
      title: title,
      centerTitle: centerTitle,
      action: actions,
      backgroundColor: backgroundColor ?? AppColors.primary,
      titleStyle: TextStyle(color: textColor ?? Colors.white),
      iconColor: iconColor ?? Colors.white,
      elevation: elevation,
    );
  }

  /// [secondary] AppBar standar dengan background warna permukaan (surface/white).
  static PreferredSizeWidget secondary({
    required String title,
    bool centerTitle = false,
    List<Widget>? action,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    double? elevation,
  }) {
    return BaseAppBar(
      title: title,
      centerTitle: centerTitle,
      action: action,
      backgroundColor: backgroundColor ?? AppColors.white,
      titleStyle: TextStyle(color: textColor ?? AppColors.black),
      iconColor: iconColor ?? AppColors.black,
      elevation: elevation,
    );
  }
}
