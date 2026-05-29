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
  const SplashView({super.key});
  static const String route = '/splash';

  @override
  Widget build(BuildContext context) {
    // Explicit find untuk menjamin controller teregistrasi saat view dibangun.
    Get.find<SplashController>();

    return ColoredStatusBar(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // Menggunakan background gradient premium untuk kesan spiritual dan modern.
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
            children: [
              // Latar belakang animasi kustom Mandala Painter (OP UI).
              Center(child: MandalaPainterWidget()),
              // Konten teks dan indikator progres.
              Center(
                child: SplashContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Konten utama pada Splash screen dipisahkan untuk menjaga keterbacaan kode (SoC).
class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ikon modern yang merepresentasikan Al-Quran.
        const Icon(
          Icons.auto_stories,
          size: 100,
          color: Colors.white,
        ),
        const SizedBox(height: 24),
        // Nama aplikasi terlokalisasi.
        Text(
          'txt_quran_title'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        // Indikator pemuatan statis namun terlihat dinamis dengan background animasi.
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        ),
      ],
    );
  }
}
