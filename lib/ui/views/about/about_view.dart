import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/about/about_controller.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';

/// [AboutView] menampilkan informasi profil pengembang dan lisensi aplikasi.
/// Principal Note: Menggunakan layout single child scroll view untuk menjamin
/// konten tetap dapat diakses di layar perangkat kecil.
class AboutView extends GetView<AboutController> {
  const AboutView({super.key});
  static const String route = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyAppBar.secondary(
        title: 'txt_about_me'.tr,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Representasi Visual Pengembang.
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  'MYH',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Nama Lengkap Pengembang.
            Text(
              controller.authorName,
              style: context.typography.headline3
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Email Kontak.
            Text(
              controller.authorEmail,
              style: context.typography.body1.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            // Deskripsi Proyek (Terlokalisasi).
            Text(
              'txt_about_description'.tr,
              style: context.typography.body1,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 32),
            // Seksi Informasi Legal dan Teknis.
            _buildInfoTile(
              context,
              icon: Icons.verified_user,
              title: 'txt_license'.tr,
              subtitle: 'MIT License',
            ),
            _buildInfoTile(
              context,
              icon: Icons.info_outline,
              title: 'txt_app_version'.tr,
              subtitle: controller.appVersion,
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildInfoTile] adalah komponen helper internal untuk merender baris informasi.
  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme!.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
