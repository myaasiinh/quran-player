import 'package:quran_player/ui/widgets/sky_appbar.dart';
import '/ui/widgets/sky_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget yang digunakan untuk menampilkan kondisi error,
/// lengkap dengan gambar, pesan error, dan tombol coba lagi.
class ErrorView extends StatelessWidget {
  /// Konstruktor untuk widget [ErrorView].
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

  /// Path aset gambar yang menandakan terjadinya kesalahan.
  final String? errorImage;

  /// Widget kustom untuk menggantikan gambar bawaan dari aset [errorImage].
  final Widget? errorImageWidget;

  /// Judul pesan error utama.
  final String? errorTitle;

  /// Subjudul pesan error, biasanya berupa ajakan untuk mencoba lagi.
  final String? errorSubtitle;

  /// Teks kustom untuk tombol coba lagi.
  final String? retryText;

  /// Callback ketika pengguna menekan tombol coba lagi.
  final VoidCallback? onRetry;

  /// Jarak spasial vertikal antar komponen di dalam layar error.
  final double verticalSpacing;

  /// Jarak spasial horizontal pada sisi kiri dan kanan layar.
  final double horizontalSpacing;

  /// Tinggi dari gambar error.
  final double? imageHeight;

  /// Lebar dari gambar error.
  final double? imageWidth;

  /// Gaya teks khusus untuk judul pesan error.
  final TextStyle? titleStyle;

  /// Gaya teks khusus untuk subjudul pesan error.
  final TextStyle? subtitleStyle;

  /// Widget tombol kustom untuk fungsi coba lagi.
  final Widget? retryWidget;

  /// Fisika scroll yang diaplikasikan pada widget konten.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: physics,
        padding: EdgeInsets.symmetric(
          vertical: verticalSpacing,
          horizontal: horizontalSpacing,
        ),
        child: Column(
          children: [
            // Gambar ilustrasi error
            errorImageWidget ??
                Image.asset(
                  errorImage ?? AppImages.imgError,
                  height: imageHeight,
                  width: imageWidth,
                ),
            SizedBox(height: verticalSpacing * 2),
            // Judul Error
            Text(
              errorTitle ?? 'txt_err_general_formal'.tr,
              textAlign: TextAlign.center,
              style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // Subjudul Error / Ajakan mencoba lagi
            Text(
              errorSubtitle ?? 'txt_tap_retry'.tr,
              textAlign: TextAlign.center,
              style: subtitleStyle,
            ),
            SizedBox(height: verticalSpacing),
            // Tombol Coba Lagi
            retryWidget ??
                SkyButton(
                  wrapContent: true,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  text: retryText ?? 'txt_retry'.tr,
                  onPressed: onRetry,
                ),
          ],
        ),
      ),
    );
  }
}
