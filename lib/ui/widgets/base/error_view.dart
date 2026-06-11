import 'package:quran_player/ui/widgets/sky_appbar.dart';
import '/ui/widgets/sky_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget yang digunakan untuk menampilkan kondisi error pada antarmuka pengguna.
/// Widget ini lengkap dengan gambar ilustrasi, pesan error, dan tombol coba lagi.
class ErrorView extends StatelessWidget {
  /// Konstruktor untuk membuat instance dari widget [ErrorView].
  const ErrorView({
    super.key,
    this.errorImage,
    this.errorImageWidget,
    this.errorTitle,
    this.errorSubtitle,
    this.onRetry,
    this.retryText,
    this.verticalSpacing = 24,
    this.horizontalSpacing = 24,
    this.imageHeight,
    this.imageWidth,
    this.titleStyle,
    this.subtitleStyle,
    this.retryWidget,
    this.physics,
  });

  /// Path string untuk aset gambar yang menandakan terjadinya kesalahan.
  final String? errorImage;

  /// Widget kustom untuk menggantikan gambar bawaan dari aset [errorImage].
  final Widget? errorImageWidget;

  /// Teks judul pesan error utama yang akan ditampilkan.
  final String? errorTitle;

  /// Teks subjudul pesan error, biasanya berupa ajakan untuk mencoba lagi.
  final String? errorSubtitle;

  /// Teks kustom untuk label pada tombol coba lagi.
  final String? retryText;

  /// Fungsi callback yang akan dieksekusi ketika pengguna menekan tombol coba lagi.
  final VoidCallback? onRetry;

  /// Nilai jarak spasial vertikal antar komponen di dalam layar error.
  final double verticalSpacing;

  /// Nilai jarak spasial horizontal pada sisi kiri dan kanan layar error.
  final double horizontalSpacing;

  /// Nilai tinggi khusus untuk gambar error yang ditampilkan.
  final double? imageHeight;

  /// Nilai lebar khusus untuk gambar error yang ditampilkan.
  final double? imageWidth;

  /// Gaya teks khusus untuk judul pesan error.
  final TextStyle? titleStyle;

  /// Gaya teks khusus untuk subjudul pesan error.
  final TextStyle? subtitleStyle;

  /// Widget kustom untuk menggantikan tombol bawaan fungsi coba lagi.
  final Widget? retryWidget;

  /// Fisika scroll yang diaplikasikan pada widget konten agar dapat menyesuaikan dengan perilaku platform.
  final ScrollPhysics? physics;

  /// Menggambarkan antarmuka pengguna untuk [ErrorView].
  @override
  Widget build(BuildContext context) {
    // Membungkus seluruh konten ke tengah layar
    return Center(
      // Membuat konten bisa digulir jika ukurannya melebihi layar
      child: SingleChildScrollView(
        // Menentukan perilaku scroll (misalnya BouncingScrollPhysics)
        physics: physics,
        // Memberikan jarak bantalan (padding) pada konten yang dapat digulir
        padding: EdgeInsets.symmetric(
          // Memberikan padding vertikal berdasarkan [verticalSpacing]
          vertical: verticalSpacing,
          // Memberikan padding horizontal berdasarkan [horizontalSpacing]
          horizontal: horizontalSpacing,
        ),
        // Menyusun elemen-elemen secara vertikal
        child: Column(
          children: [
            // Gambar ilustrasi error
            // Menggunakan widget kustom jika ada, atau menggunakan gambar default
            errorImageWidget ??
                // Menampilkan gambar dari aset yang telah ditentukan
                Image.asset(
                  // Menggunakan path gambar error yang diberikan atau default
                  errorImage ?? AppImages.imgError,
                  // Mengatur tinggi gambar
                  height: imageHeight,
                  // Mengatur lebar gambar
                  width: imageWidth,
                ),
            // Memberikan jarak vertikal antara gambar dan judul dua kali lipat
            SizedBox(height: verticalSpacing * 2),
            // Judul Error
            // Widget teks untuk judul pesan error
            Text(
              // Menampilkan judul kustom atau teks default terjemahan
              errorTitle ?? 'txt_err_general_formal'.tr,
              // Meratakan teks ke tengah
              textAlign: TextAlign.center,
              // Menggunakan gaya teks kustom atau dari tema utama
              style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
            // Memberikan jarak vertikal yang kecil antara judul dan subjudul
            const SizedBox(height: 8),
            // Subjudul Error / Ajakan mencoba lagi
            // Widget teks untuk subjudul pesan error
            Text(
              // Menampilkan subjudul kustom atau teks default terjemahan
              errorSubtitle ?? 'txt_tap_retry'.tr,
              // Meratakan teks ke tengah
              textAlign: TextAlign.center,
              // Menggunakan gaya teks yang telah ditentukan untuk subjudul
              style: subtitleStyle,
            ),
            // Memberikan jarak vertikal sebelum tombol coba lagi
            SizedBox(height: verticalSpacing),
            // Tombol Coba Lagi
            // Menggunakan widget tombol kustom jika ada, atau menggunakan SkyButton default
            retryWidget ??
                // Widget tombol kustom dari proyek
                SkyButton(
                  // Membungkus ukuran tombol sesuai dengan isi konten
                  wrapContent: true,
                  // Menentukan tinggi standar tombol
                  height: 50,
                  // Memberikan padding horizontal di dalam tombol
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // Menampilkan teks tombol kustom atau teks default terjemahan
                  text: retryText ?? 'txt_retry'.tr,
                  // Mengeksekusi fungsi onRetry saat tombol ditekan
                  onPressed: onRetry,
                ),
          ],
        ),
      ),
    );
  }
}
