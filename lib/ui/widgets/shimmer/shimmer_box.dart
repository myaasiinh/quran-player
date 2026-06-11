import '/ui/widgets/sky_box.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget abstrak utilitas kustom [ShimmerBox] ini digunakan secara masif di aplikasi 
/// guna menampilkan animasi efek memuat (shimmer skeleton loading) yang mensimulasikan bentuk
/// balok atau sebuah kotak persegi panjang yang padat (box).
class ShimmerBox extends StatelessWidget {
  /// Konstruktor widget generik [ShimmerBox].
  /// Semua parameter opsional agar mudah disesuaikan dan diterapkan instan tanpa konfigurasi kompleks di UI.
  const ShimmerBox({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.baseColor,
  });

  /// Parameter yang merepresentasikan pengaturan properti Tinggi total komponen kotak shimmer (skeleton).
  final double? height;
  
  /// Parameter yang merepresentasikan pengaturan properti Lebar total fisik dari kotak shimmer.
  final double? width;
  
  /// Parameter untuk menentukan proporsi tingkat radius sudut tumpul (lengkungan bezel) dari komponen kotak. 
  /// Jika tidak disuplai (null), nilai kelengkungan standar baloknya adalah 6 px.
  final double? borderRadius;
  
  /// Mengatur margin eksternal (jarak kosong batas area terluar) di sekeliling wilayah kotak animasi shimmer ini.
  final EdgeInsets? margin;
  
  /// Membawa referensi palet warna dasar spesifik untuk background di bawah pantulan sinar shimmer. 
  /// Apabila nilainya tidak diisi (kosong), tema otomatis mendasarkan paduan warna default abu-abu netral (grey.shade300).
  final Color? baseColor;

  /// Merender representasi visual kerangka kotak [ShimmerBox] statis.
  @override
  Widget build(BuildContext context) {
    // Membangkitkan animasi Shimmer yang disediakan oleh pustaka package ketiga (`shimmer`).
    // Menggunakan ekstensi mode `.fromColors` untuk memberikan warna kustom highlight sapuan kuas sinar berjalan.
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300, // Warna kerangka pondasi aslinya sebelum disapu cahaya (abu-abu pudar default).
      highlightColor: Colors.white, // Warna pancaran sinar mengkilap yang menyapu kerangka dasar tersebut (warna putih terang).
      // Membalutnya pada [SkyBox] yakni container kotak multifungsi custom app agar lebih praktis mengurus bentuk pinggiran radius serta shadow.
      child: SkyBox(
        margin: margin, // Meneruskan properti jarak margin terluar ke layout komponen SkyBox.
        height: height, // Menyematkan proporsi tinggi.
        width: width, // Menyematkan ukuran properti fisik lebar.
        borderRadius: borderRadius ?? 6, // Memberikan perlakuan pinggiran kotak yang membulat (default 6 points).
        enabledCard: false, // Menonaktifkan efek card elevation shadow yang berlebihan, sehingga skeleton pure kotak mati.
        color: Colors.grey, // Warna blok isian dari komponen Box itu sendiri (secara teknis akan ditutupi baseColor oleh shimmer wrapper).
        child: const SizedBox.shrink(), // Kotak skeleton isinya kosong hampa, tidak membawa elemen child widget lagi sehingga ukuran direduksi (SizedBox.shrink).
      ),
    );
  }
}
