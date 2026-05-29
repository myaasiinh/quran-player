import 'dart:async';

import 'package:get/get.dart';
import 'package:quran_player/config/auth_manager/auth_manager.dart';

/// [SplashController] mengelola alur inisialisasi aplikasi saat pertama kali dibuka.
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Memulai proses inisialisasi setelah UI splash tampil.
    unawaited(_startInit());
  }

  /// [_startInit] menjalankan delay dekoratif dan memicu setup infrastruktur.
  Future<void> _startInit() async {
    // Delay selama 3 detik untuk memberikan waktu bagi animasi Mandala di SplashView.
    await Future.delayed(const Duration(seconds: 3));
    
    // Menjalankan setup core sistem (Theme, Cache, Auth) melalui AuthManager.
    await AuthManager.find.setup();
  }
}
