import '/ui/widgets/sky_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget yang menampilkan tampilan ketika pengguna menolak atau belum
/// memberikan izin akses (permission) yang diperlukan aplikasi.
class PermissionDeniedView extends StatelessWidget {
  /// Konstruktor untuk membuat widget [PermissionDeniedView].
  const PermissionDeniedView({
    required this.title,
    required this.message,
    required this.onRequest,
    super.key,
    this.buttonTitle,
  });

  /// Judul yang ditampilkan pada tampilan penolakan izin.
  final String title;

  /// Pesan penjelasan mengapa izin tersebut diperlukan oleh aplikasi.
  final String message;

  /// Teks kustom untuk tombol permintaan izin.
  /// Jika tidak disediakan, akan menggunakan teks default dari terjemahan 'txt_request_permission'.
  final String? buttonTitle;

  /// Callback yang dipanggil saat pengguna menekan tombol untuk meminta izin kembali.
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan judul peringatan
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            // Menampilkan pesan atau deskripsi peringatan
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            // Tombol untuk meminta ulang izin
            SkyButton(
              text: buttonTitle ?? 'txt_request_permission'.tr,
              onPressed: onRequest,
            ),
          ],
        ),
      ),
    );
  }
}
