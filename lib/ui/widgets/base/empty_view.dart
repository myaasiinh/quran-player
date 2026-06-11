import 'package:quran_player/ui/widgets/sky_appbar.dart';
import '/ui/widgets/sky_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget yang digunakan untuk menampilkan status "Kosong" (Empty State),
/// biasanya digunakan saat data list kosong atau tidak ada hasil pencarian.
class EmptyView extends StatelessWidget {
  /// Konstruktor untuk widget [EmptyView].
  const EmptyView({
    super.key,
    this.emptyImage,
    this.emptyImageWidget,
    this.emptyTitle,
    this.emptySubtitle,
    this.physics,
    this.imageHeight,
    this.imageWidth,
    this.verticalSpacing = 24,
    this.horizontalSpacing = 24,
    this.titleStyle,
    this.subtitleStyle,
    this.retryText,
    this.onRetry,
    this.retryWidget,
    this.emptyRetryEnabled = false,
  });

  /// Widget gambar kustom yang akan ditampilkan. Jika null, akan menggunakan gambar dari [emptyImage].
  final Widget? emptyImageWidget;

  /// Path aset gambar yang akan ditampilkan jika konten kosong.
  final String? emptyImage;

  /// Teks judul untuk kondisi kosong.
  final String? emptyTitle;

  /// Teks subjudul atau deskripsi untuk kondisi kosong.
  final String? emptySubtitle;

  /// Fisika scroll yang diaplikasikan pada [SingleChildScrollView].
  final ScrollPhysics? physics;

  /// Tinggi dari gambar.
  final double? imageHeight;

  /// Lebar dari gambar.
  final double? imageWidth;

  /// Jarak spasial vertikal antar elemen.
  final double verticalSpacing;

  /// Jarak spasial horizontal untuk sisi kiri dan kanan.
  final double horizontalSpacing;

  /// Gaya teks khusus untuk judul kosong.
  final TextStyle? titleStyle;

  /// Gaya teks khusus untuk subjudul kosong.
  final TextStyle? subtitleStyle;

  /// Teks kustom untuk tombol coba lagi.
  final String? retryText;

  /// Callback ketika tombol coba lagi ditekan.
  final VoidCallback? onRetry;

  /// Widget kustom untuk menggantikan tombol coba lagi bawaan.
  final Widget? retryWidget;

  /// Menentukan apakah tombol coba lagi harus diaktifkan dan ditampilkan.
  final bool emptyRetryEnabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: verticalSpacing,
          horizontal: horizontalSpacing,
        ),
        physics: physics,
        child: Column(
          children: [
            // Gambar penanda kosong
            emptyImageWidget ??
                Image.asset(
                  emptyImage ?? AppImages.imgEmpty,
                  height: imageHeight,
                  width: imageWidth,
                ),
            SizedBox(height: verticalSpacing),
            // Judul
            Text(
              emptyTitle ?? 'txt_empty_list_title'.tr,
              textAlign: TextAlign.center,
              style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: verticalSpacing / 6),
            // Subjudul
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                emptySubtitle ?? 'txt_empty_list_subtitle'.tr,
                textAlign: TextAlign.center,
                style: subtitleStyle,
              ),
            ),
            SizedBox(height: verticalSpacing),
            // Tombol coba lagi jika diaktifkan
            if (emptyRetryEnabled && onRetry != null)
              retryWidget ??
                  SkyButton(
                    wrapContent: true,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    text: retryText ?? 'txt_reload'.tr,
                    onPressed: onRetry,
                  ),
          ],
        ),
      ),
    );
  }
}
