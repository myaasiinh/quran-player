import 'package:get/get.dart';

/// [AboutController] mengelola state sederhana untuk halaman About.
/// Principal Note: Controller ini menyediakan data profil pengembang
/// dan metadata aplikasi untuk ditampilkan di UI.
class AboutController extends GetxController {
  // Informasi Penulis (Muhammad Yaasiin Hidayatulloh).
  final String authorName = 'Muhammad Yaasiin Hidayatulloh';
  final String authorEmail = 'myaasiinh@gmail.com';
  final String githubUrl = 'https://github.com/myaasiinh';

  // Deskripsi singkat tentang tujuan proyek.
  final String authorTitle = 'Mobile App Developer';

  // Versi aplikasi yang diambil dari build configuration.
  final String appVersion = '1.0.0+1';
}
