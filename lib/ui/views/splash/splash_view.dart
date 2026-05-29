import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/config/themes/app_colors.dart';
import 'package:quran_player/ui/views/splash/splash_controller.dart';
import 'package:quran_player/ui/views/splash/widgets/mandala_painter_widget.dart';
import 'package:quran_player/ui/widgets/colored_status_bar.dart';

/// [SplashView] adalah representasi visual dari startup aplikasi.
/// Principal Note: View ini menggunakan SplashController untuk akses
/// state lifecycle yang dikelola oleh GetX.
class SplashView extends GetView<SplashController> {
  /// Konstruktor konstan untuk optimasi performa widget.
  const SplashView({super.key});

  /// Rute navigasi unik untuk halaman Splash.
  static const String route = '/splash';

  @override
  Widget build(BuildContext context) {
    /// Explicit find untuk menjamin controller teregistrasi saat view dibangun.
    Get.find<SplashController>();

    return ColoredStatusBar(
      child: Scaffold(
        body: Container(
          /// Mengatur lebar container memenuhi layar.
          width: double.infinity,

          /// Mengatur tinggi container memenuhi layar.
          height: double.infinity,

          /// Menggunakan background gradient premium untuk kesan spiritual dan modern.
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E3C72),
                Color(0xFF2A5298),
                AppColors.primary,
              ],
            ),
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              /// Latar belakang animasi kustom Mandala Painter (OP UI).
              MandalaPainterWidget(),

              /// Konten teks dan ikon yang diletakkan tepat di tengah mandala.
              SplashContent(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Konten utama pada Splash screen dipisahkan untuk menjaga keterbacaan kode (SoC).
class SplashContent extends StatelessWidget {
  /// Konstruktor konstan untuk SplashContent.
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      /// Mengatur alignment vertikal di tengah.
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Ikon modern yang merepresentasikan Al-Quran, diposisikan di pusat mandala.
        const Icon(
          Icons.auto_stories,
          size: 80,
          color: Colors.white,
        ),

        /// Memberikan jarak antara ikon dan teks.
        const SizedBox(height: 16),

        /// Nama aplikasi terlokalisasi dengan gaya font premium.
        Text(
          'txt_quran_title'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black26,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
