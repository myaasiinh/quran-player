import 'package:flutter/material.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget AppBar kustom dasar yang dapat digunakan kembali.
/// Mengimplementasikan [PreferredSizeWidget] agar dapat langsung dipakai
/// pada properti `appBar` di widget [Scaffold].
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Konstruktor untuk widget [BaseAppBar].
  const BaseAppBar({
    super.key,
    this.title,
    this.action,
    this.backgroundColor,
    this.centerTitle = false,
    this.titleStyle,
    this.iconColor,
    this.elevation,
    this.height,
    this.iconSize,
  });

  /// Judul yang akan ditampilkan pada AppBar.
  final String? title;

  /// Warna latar belakang AppBar.
  final Color? backgroundColor;

  /// Daftar widget tindakan (action) yang ditampilkan di sisi kanan AppBar.
  final List<Widget>? action;

  /// Menentukan apakah judul harus diletakkan di tengah.
  final bool? centerTitle;

  /// Warna untuk ikon-ikon bawaan (seperti tombol kembali) di AppBar.
  final Color? iconColor;

  /// Gaya teks kustom untuk judul AppBar.
  final TextStyle? titleStyle;

  /// Tingkat elevasi (bayangan di bawah AppBar).
  final double? elevation;

  /// Tinggi kustom untuk AppBar.
  /// Jika null, tinggi akan mengikuti nilai default `kToolbarHeight`.
  final double? height;

  /// Ukuran ikon pada AppBar.
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: Text(title ?? '', style: titleStyle),
      backgroundColor: backgroundColor,
      elevation: elevation,
      actions: action,
      iconTheme: IconThemeData(color: iconColor, size: iconSize),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
