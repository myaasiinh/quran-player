import 'package:flutter/material.dart';
import 'package:quran_player/config/themes/app_colors.dart';
import 'package:quran_player/ui/widgets/base/base_appbar.dart';

/* penulis
   myaasiinh@gmail.com
*/

/// [SkyAppBar] menyediakan desain bilah aplikasi (AppBar) yang terstandarisasi untuk keseluruhan aplikasi.
/// 
/// Catatan Utama (Principal Note): Kelas abstrak ini menggunakan pola desain metode pabrik (factory method) 
/// untuk memastikan bahwa seluruh konsistensi visual pada bilah aplikasi diterapkan secara global
/// dan mempermudah pemanggilan AppBar pada berbagai layar.
abstract class SkyAppBar {
  /// [primary] menghasilkan sebuah AppBar standar dengan warna latar belakang utama (primary color).
  /// 
  /// Metode ini digunakan untuk sebagian besar layar utama dalam aplikasi yang memerlukan
  /// tajuk berwarna dominan dan mencolok.
  static PreferredSizeWidget primary({
    // Judul yang akan ditampilkan pada AppBar
    required String title,
    // Status apakah posisi judul berada di tengah atau di kiri (default adalah false)
    bool centerTitle = false,
    // Kumpulan widget tindakan opsional (seperti ikon aksi di bagian kanan AppBar)
    List<Widget>? actions,
    // Warna latar belakang opsional (akan menggantikan default warna primer jika diisi)
    Color? backgroundColor,
    // Warna teks judul (default adalah putih)
    Color? textColor,
    // Warna ikon aksi atau navigasi (default adalah putih)
    Color? iconColor,
    // Elevasi (bayangan) dari AppBar (nilai double)
    double? elevation,
  }) {
    // Mengembalikan BaseAppBar (widget AppBar custom yang memuat kerangka utama)
    return BaseAppBar(
      // Menerapkan parameter ke dalam properti BaseAppBar
      title: title,
      centerTitle: centerTitle,
      action: actions,
      // Setel backgroundColor ke nilai kustom atau jatuh kembali (fallback) ke AppColors.primary
      backgroundColor: backgroundColor ?? AppColors.primary,
      // Mengatur style teks judul berdasarkan textColor kustom atau putih sebagai default
      titleStyle: TextStyle(color: textColor ?? Colors.white),
      // Mengatur warna kumpulan ikon pada AppBar
      iconColor: iconColor ?? Colors.white,
      // Mengatur properti ketebalan bayangan di bawah AppBar
      elevation: elevation,
    );
  }

  /// [secondary] menghasilkan AppBar standar yang memiliki warna latar belakang menyerupai permukaan (surface/white).
  /// 
  /// Metode ini biasanya digunakan untuk layar sekunder, modal, layar rincian (detail), atau lembar
  /// di mana warna primer bisa dirasa terlalu berat sebagai tajuk.
  static PreferredSizeWidget secondary({
    // Judul yang akan ditampilkan pada AppBar sekunder
    required String title,
    // Menentukan posisi tengah atau rata kiri untuk judul
    bool centerTitle = false,
    // Kumpulan widget untuk interaksi atau ikon di sebelah kanan
    List<Widget>? action,
    // Warna latar belakang yang bisa diatur kustom
    Color? backgroundColor,
    // Warna teks kustom (default adalah hitam)
    Color? textColor,
    // Warna ikon kustom (default adalah hitam)
    Color? iconColor,
    // Ketebalan bayangan AppBar (elevasi)
    double? elevation,
  }) {
    // Mengembalikan instance BaseAppBar dengan pengaturan pewarnaan spesifik mode sekunder
    return BaseAppBar(
      // Parameter dipetakan
      title: title,
      centerTitle: centerTitle,
      action: action,
      // Jatuh kembali pada warna putih (AppColors.white) untuk tema yang bersih/terang
      backgroundColor: backgroundColor ?? AppColors.white,
      // Teks diubah warnanya menjadi hitam untuk keterbacaan yang jelas terhadap latar putih
      titleStyle: TextStyle(color: textColor ?? AppColors.black),
      // Ikon diubah menjadi hitam agar kontras dengan warna latar putih
      iconColor: iconColor ?? AppColors.black,
      // Terapkan batas bayangan jika diberikan
      elevation: elevation,
    );
  }
}

/// [AppImages] bertindak sebagai kelas registri untuk semua path atau direktori aset gambar statis.
/// 
/// Catatan Utama (Principal Note): Pendekatan ini mempermudah penggantian jalur atau path aset gambar 
/// secara global tanpa harus mencari string yang bertebaran di seluruh file proyek.
abstract class AppImages {
  /// Path gambar untuk mengindikasikan status error secara umum.
  static const String imgError = 'assets/images/img_error.png';
  
  /// Path gambar untuk mengindikasikan data atau status kosong (empty state).
  static const String imgEmpty = 'assets/images/img_empty.png';
  
  /// Path gambar placeholder umum untuk avatar atau profil.
  static const String avatarPlaceholder =
      'assets/images/img_avatar_placeholder.png';
      
  /// Path gambar spesifik untuk placeholder avatar / foto pengguna.
  static const String imgPlaceholderUser =
      'assets/images/img_avatar_placeholder.png';
      
  /// Path gambar untuk mengindikasikan bahwa data tidak ditemukan (not found).
  static const String imgNotFound = 'assets/images/img_error.png';
}

/// [AppIcons] bertindak sebagai registri statis untuk semua lokasi aset ikon kustom.
/// 
/// Ini memusatkan pengaturan string path file ikon sehingga mengurangi risiko typo (salah ketik) 
/// pada komponen-komponen yang sering menggunakan ikon tersebut.
abstract class AppIcons {
  /// Ikon yang melambangkan status berhasil (success).
  static const String icSuccess = 'assets/icons/ic_success.png';
  
  /// Ikon yang melambangkan peringatan (warning) kepada pengguna.
  static const String icWarning = 'assets/icons/ic_warning.png';
  
  /// Ikon yang melambangkan terjadinya sebuah kesalahan (error).
  static const String icError = 'assets/icons/ic_error.png';
  
  /// Ikon indikator info (informasi tambahan atau panduan singkat).
  static const String icInfo = 'assets/icons/ic_info.png';
  
  /// Ikon untuk memperlihatkan status gagal, menggunakan aset error yang sama.
  static const String icFailed = 'assets/icons/ic_error.png';
}
