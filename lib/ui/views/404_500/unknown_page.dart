import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';

/// [UnknownPage] adalah view untuk menangani rute yang tidak terdaftar (HTTP 404).
/// Principal Note: Didesain dengan tema Islami untuk memberikan petunjuk jalan yang benar
/// saat navigasi tersesat di dalam aplikasi.
GetPage<dynamic> get unknownPage {
  return GetPage(
    name: '/unknown',
    page: UnknownView.new,
  );
}

class UnknownView extends StatelessWidget {
  const UnknownView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme!.primary.withValues(alpha: 0.1),
              context.colorScheme!.surface,
            ],
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Ikon Kompas / Penunjuk Arah (Spiritual Guidance).
            Icon(
              Icons.explore_off_rounded,
              size: 100,
              color: context.colorScheme!.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),

            /// Branding Al-Quran untuk konsistensi di halaman error.
            Text(
              'txt_quran_title'.tr,
              style: context.typography.body2.copyWith(
                color: context.colorScheme!.primary.withValues(alpha: 0.5),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            /// Judul Not Found.
            Text(
              'txt_not_found'.tr,
              textAlign: TextAlign.center,
              style: context.typography.headline3.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme!.primary,
              ),
            ),
            const SizedBox(height: 16),

            /// Kutipan Ayat Al-Quran untuk 404 (QS. Al-Fatihah: 6).
            const Text(
              '"Tunjukkanlah kami jalan yang lurus."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            /// Deskripsi Error (Terlokalisasi).
            const Text(
              'Maaf, halaman yang Anda cari tidak tersedia atau telah dipindahkan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45),
            ),
            const SizedBox(height: 48),

            /// Tombol kembali ke jalan yang benar (Home).
            ElevatedButton.icon(
              onPressed: () => Get.offAllNamed('/surah-list'),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Kembali ke Beranda'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme!.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
