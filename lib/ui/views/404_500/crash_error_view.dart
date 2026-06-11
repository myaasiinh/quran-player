import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';

/// [CrashErrorView] adalah halaman fallback yang akan ditampilkan saat terjadi System Failure (misalnya error atau HTTP 500).
/// Principal Note: Menggunakan pendekatan spiritual dengan kutipan Al-Quran untuk
/// menenangkan pengguna saat menghadapi kesalahan teknis yang tidak terduga pada aplikasi.
class CrashErrorView extends StatelessWidget {
  /// Konstruktor untuk [CrashErrorView].
  /// Memerlukan [errorDetails] agar dapat menampilkan log error spesifik jika aplikasi berjalan pada mode debug.
  const CrashErrorView({required this.errorDetails, super.key});
  
  /// Detail dari flutter error yang berhasil ditangkap oleh sistem aplikasi.
  final FlutterErrorDetails errorDetails;

  /// Membangun antarmuka pengguna (UI) dari halaman fallback error ini.
  @override
  Widget build(BuildContext context) {
    // Menggunakan Scaffold untuk menyediakan struktur halaman dasar.
    return Scaffold(
      // Menggunakan Container yang membentang menutupi seluruh lebar layar.
      body: Container(
        width: double.infinity,
        // Menggunakan warna background yang sesuai dengan tema (surface).
        color: context.colorScheme!.surface,
        // Memberikan ruang (padding) di seluruh sisi container.
        padding: const EdgeInsets.all(32),
        // Mengatur elemen secara vertikal (kolom) dengan perataan di tengah.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Ikon peringatan spiritual (Sabar & Tawakal).
            /// Menampilkan ikon sedih dengan warna error tema aplikasi.
            Icon(
              Icons.sentiment_very_dissatisfied_rounded,
              size: 80, // Ukuran ikon diperbesar agar menjadi fokus utama (80px).
              color: context.colorScheme!.error.withValues(alpha: 0.5), // Warna ikon disesuaikan dengan transparansi.
            ),
            const SizedBox(height: 16), // Memberikan jarak vertikal antara ikon dan judul.

            /// Branding Al-Quran Premium (Sesuai gaya pada halaman Splash).
            /// Principal Note: Teks judul aplikasi dibuat lebih kontras agar branding tetap terlihat jelas.
            Text(
              'txt_quran_title'.tr, // Menampilkan judul aplikasi dengan translasi.
              textAlign: TextAlign.center, // Teks disejajarkan ke tengah.
              // Styling judul dengan font spesifik dari custom typography.
              style: context.typography.headline3.copyWith(
                color: context.colorScheme!.primary.withValues(alpha: 0.6), // Warna teks primer dengan efek transparan.
                fontWeight: FontWeight.bold, // Menjadikan teks tebal (bold).
                letterSpacing: 4, // Memberikan jarak antar huruf (letter-spacing) sebesar 4px.
              ),
            ),
            const SizedBox(height: 24), // Memberikan jarak vertikal antara branding dan judul pesan error.

            /// Judul Error (Teks sudah terlokalisasi).
            Text(
              'txt_crash_error_title'.tr, // Menampilkan teks terjemahan judul pesan error.
              textAlign: TextAlign.center, // Perataan di tengah.
              // Styling judul pesan error dengan warna merah (error).
              style: context.typography.headline3.copyWith(
                color: context.colorScheme!.error, // Menggunakan warna tema untuk kondisi error.
                fontWeight: FontWeight.bold, // Ditebalkan agar mencolok.
              ),
            ),
            const SizedBox(height: 16), // Memberikan jarak vertikal dari judul error ke kutipan.

            /// Kutipan Ayat Al-Quran untuk Error 500 (QS. Al-Baqarah: 286).
            /// Principal Note: Memberikan konteks Quranic dan spiritual pada aplikasi bertema Quran yang menenangkan.
            const Text(
              '"Allah tidak membebani seseorang melainkan sesuai dengan kesanggupannya."',
              textAlign: TextAlign.center, // Perataan kutipan di tengah.
              style: TextStyle(
                fontStyle: FontStyle.italic, // Kutipan dibuat dengan gaya tulisan miring (italic).
                color: Colors.grey, // Warna teks diubah menjadi abu-abu.
              ),
            ),
            const SizedBox(height: 32), // Memberikan jarak vertikal antara kutipan dan deskripsi error teknis.

            /// Pesan Error tambahan untuk User biasa atau Developer (jika debug).
            Text(
              // Jika aplikasi berjalan di debug mode, tampilkan stack trace error detail.
              // Jika rilis/produksi, tampilkan pesan terjemahan error generik.
              kDebugMode
                  ? errorDetails.exceptionAsString() // Menampilkan pesan error (Exception) yang sesungguhnya.
                  : 'txt_crash_error_message'.tr, // Teks terjemahan untuk end-user.
              textAlign: TextAlign.center, // Teks berada di tengah.
              style: context.typography.body1, // Gaya tulisan standar untuk pesan body.
            ),
            const SizedBox(height: 48), // Jarak yang cukup besar menuju tombol retry.

            /// Tombol Refresh/Kembali untuk memuat ulang status aplikasi.
            ElevatedButton.icon(
              onPressed: Get.back, // Aksi: menutup halaman error atau kembali ke navigasi sebelumnya menggunakan library Get.
              icon: const Icon(Icons.refresh), // Ikon refresh pada sisi kiri tombol.
              label: Text('txt_retry'.tr), // Label tombol memuat ulang/coba lagi yang ditranslasi.
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme!.primary, // Latar belakang tombol mengikuti warna utama tema.
                foregroundColor: Colors.white, // Teks dan ikon tombol berwarna putih.
                padding: const EdgeInsets.symmetric(
                  horizontal: 32, // Padding samping untuk tombol.
                  vertical: 12, // Padding atas bawah tombol.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
