import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Kelas pembantu (helper) [BottomSheetHelper] digunakan untuk menampilkan berbagai jenis Bottom Sheet.
/// 
/// Menggunakan package pihak ketiga `modal_bottom_sheet` dan utilitas state management dari `get`.
/// Kelas ini memusatkan konfigurasi desain bottom sheet agar konsisten dan mudah digunakan kembali
/// di seluruh bagian aplikasi.
class BottomSheetHelper {
  /// Menampilkan Bottom Sheet dasar atau standar bawaan Material Design.
  /// 
  /// [child] adalah widget konten yang akan ditampilkan di dalam Bottom Sheet.
  /// Parameter lain dapat diatur untuk mengonfigurasi properti interaksi Bottom Sheet,
  /// seperti [isDismissible] untuk mengatur apakah sheet bisa ditutup dengan mengetuk di luarnya,
  /// atau [backgroundColor] untuk mengubah warna latar belakangnya.
  static Future<T?> basic<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor = Colors.transparent,
    Color? barrierColor,
    bool enableDrag = true,
  }) async {
    // Memanggil fungsi bawaan framework (showModalBottomSheet) dengan tipe generik T
    return showModalBottomSheet<T>(
      // Menggunakan konteks global yang disediakan oleh GetX
      context: Get.context!,
      // Mengatur apakah ketukan di luar area sheet akan menutupnya
      isDismissible: isDismissible,
      // Mengatur apakah sheet bisa di-scroll penuh ke atas (mengabaikan batas setengah layar)
      isScrollControlled: isScrollControlled,
      // Warna latar belakang keseluruhan (dibuat transparan agar kita bisa membentuknya sendiri)
      backgroundColor: backgroundColor,
      // Warna overlay layar di belakang sheet
      barrierColor: barrierColor,
      // Mengatur apakah sheet bisa ditutup dengan cara ditarik (di-drag) ke bawah
      enableDrag: enableDrag,
      // Fungsi builder untuk membuat dan merender tampilan isi sheet
      builder: (btmContext) => ColoredBox(
        // Menyesuaikan warna latar belakang dengan tema aplikasi saat ini
        color: Theme.of(Get.context!).scaffoldBackgroundColor,
        child: ConstrainedBox(
          // Membatasi tinggi maksimum Bottom Sheet agar tidak menutupi seluruh layar (menyisakan 50 piksel)
          constraints: BoxConstraints(maxHeight: Get.height - 50),
          child: Padding(
            // Memberikan spasi/padding standar: 24 (kiri, kanan, bawah), dan 12 (atas)
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            // Widget utama disisipkan di sini
            child: child,
          ),
        ),
      ),
    );
  }

  /// Menampilkan Bottom Sheet dengan sudut bagian atas yang melengkung (rounded).
  /// 
  /// Biasanya digunakan untuk memberikan tampilan yang lebih modern, tidak bersudut kaku di bagian atas.
  static Future<T?> rounded<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor = Colors.transparent,
    Color? barrierColor,
    bool enableDrag = true,
    double? height,
    bool expand = false,
  }) async {
    // Memanggil showModalBottomSheet seperti pada varian basic
    return showModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      enableDrag: enableDrag,
      barrierColor: barrierColor,
      builder: (btmContext) {
        return ConstrainedBox(
          // Membatasi tinggi sheet agar tidak sepenuhnya menutupi layar
          constraints: BoxConstraints(maxHeight: Get.height - 50),
          child: Container(
            // Menghias container untuk membuat sudut melengkung
            decoration: BoxDecoration(
              // Mengambil warna latar sesuai dengan warna scaffold aplikasi dari tema saat ini
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              // Memberikan lengkungan (radius melingkar 24 piksel) khusus pada sudut kiri atas dan kanan atas
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              // Menambahkan spasi dari dalam agar konten tidak menempel ke batas layar
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              // Meletakkan widget anak/konten utama di tengah area yang sudah diberi padding
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Menampilkan Bottom Sheet bergaya Bar.
  /// 
  /// Desain ini sering digunakan untuk tampilan modal yang posisinya merapat pada batas atas sheet,
  /// menampilkan elemen visual layaknya baris.
  static Future<T?> bar<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
    bool expand = false,
  }) async {
    // Memanggil showBarModalBottomSheet dari package eksternal modal_bottom_sheet
    return showBarModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      expand: expand,
      backgroundColor: backgroundColor,
      // Jika warna pelindung/barrier tidak disediakan, gunakan hitam dengan opasitas (black54)
      barrierColor: barrierColor ?? Colors.black54,
      builder: (btmContext) => Padding(
        // Spasi di sekeliling widget yang dituju
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: child,
      ),
    );
  }

  /// Menampilkan Bottom Sheet bergaya Cupertino (gaya bawaan perangkat iOS).
  /// 
  /// Tipe sheet ini memiliki indikator tarikan (drag indicator) berupa garis kecil di bagian atasnya,
  /// memberikan kesan pengalaman interaksi murni ala Apple iOS.
  static Future<T?> cupertino<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool enableBack = true,
    bool expand = false,
    Color? barrierColor,
  }) async {
    // Memanggil showCupertinoModalBottomSheet dari library
    return showCupertinoModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // Mengatur radius lengkung bagian atas menjadi 24 piksel
      topRadius: const Radius.circular(24),
      // Durasi animasi transisi ketika sheet muncul dan tertutup (600 milidetik)
      duration: const Duration(milliseconds: 600),
      // Menggunakan warna latar dari properti scaffold tema global
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      // Jika tidak ada spesifikasi, berikan latar belakang layar gelap berbayang (hitam 54%)
      barrierColor: barrierColor ?? Colors.black54,
      expand: expand,
      builder: (btmContext) => PopScope(
        // Mengontrol apakah aksi tombol kembali (back button/gesture) diizinkan untuk menutup modal ini
        canPop: enableBack,
        child: Material(
          child: Stack(
            // Mengatur orientasi widget turunan agar bertumpuk di bagian tengah-atas
            alignment: Alignment.topCenter,
            children: [
              // Membuat elemen indikator drag (garis horizontal penanda tarik di tengah atas)
              Positioned(
                top: 0,
                child: Container(
                  // Jarak dari batas atas sebesar 12 piksel
                  margin: const EdgeInsets.only(top: 12),
                  // Ketebalan dan lebar garis indikator
                  height: 6,
                  width: 80,
                  // Tampilan melengkung warna abu-abu
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // Area utama untuk mengisi widget turunan, diberi padding 24 dari semua sisi
              Padding(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menampilkan Modal Bottom Sheet gaya Material klasik yang disesuaikan melalui konfigurasi package.
  /// 
  /// Varian ini memberikan opsi pergerakan/animasi tambahan seperti pantulan (bounce effect).
  static Future<T?> material<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool enableBack = true,
    bool expand = false,
    Color? barrierColor,
  }) async {
    // Memanggil showMaterialModalBottomSheet untuk gaya material alternatif dari library
    return showMaterialModalBottomSheet<T>(
      context: Get.context!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // Mengatur durasi animasi modal
      duration: const Duration(milliseconds: 600),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      barrierColor: barrierColor ?? Colors.black54,
      expand: expand,
      // Menambahkan efek pantul otomatis saat modal didorong atau ditarik
      bounce: true,
      builder: (btmContext) => PopScope(
        // Menentukan apakah aksi mundur atau swipe kembali sistem boleh menutup lembar ini
        canPop: enableBack,
        child: Padding(
          // Ruang spasi batas pinggiran (margin/padding) konten utama
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: child,
        ),
      ),
    );
  }
}
