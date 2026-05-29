import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';

/// [CrashError_View] adalah halaman fallback saat terjadi System Failure (HTTP 500).
/// Principal Note: Menggunakan pendekatan spiritual dengan kutipan Al-Quran untuk
/// menenangkan pengguna saat menghadapi kesalahan teknis yang tidak terduga.
class CrashErrorView extends StatelessWidget {
  const CrashErrorView({required this.errorDetails, super.key});
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.colorScheme!.surface,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Ikon peringatan spiritual (Sabar & Tawakal).
            Icon(
              Icons.sentiment_very_dissatisfied_rounded,
              size: 100,
              color: context.colorScheme!.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),

            /// Judul Error (Terlokalisasi).
            Text(
              'txt_crash_error_title'.tr,
              textAlign: TextAlign.center,
              style: context.typography.headline3.copyWith(
                color: context.colorScheme!.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            /// Kutipan Ayat Al-Quran untuk Error 500 (QS. Al-Baqarah: 286).
            /// Principal Note: Memberikan konteks Quranic pada aplikasi bertema Quran.
            const Text(
              '"Allah tidak membebani seseorang melainkan sesuai dengan kesanggupannya."',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            /// Pesan Error untuk User atau Developer.
            Text(
              kDebugMode
                  ? errorDetails.exceptionAsString()
                  : 'txt_crash_error_message'.tr,
              textAlign: TextAlign.center,
              style: context.typography.body1,
            ),
            const SizedBox(height: 48),

            /// Tombol Refresh/Kembali.
            ElevatedButton.icon(
              onPressed: Get.back,
              icon: const Icon(Icons.refresh),
              label: Text('txt_retry'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme!.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
