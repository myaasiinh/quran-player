import 'dart:async';

import 'package:get/get.dart';
import 'package:quran_player/config/auth_manager/auth_manager.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    unawaited(_startInit());
  }

  Future<void> _startInit() async {
    // Delay for aesthetic splash animation
    await Future.delayed(const Duration(seconds: 3));
    await AuthManager.find.setup();
  }
}
