import 'package:get/get.dart';

/// Ekstensi pada [GetInterface] (biasanya diakses via objek global `Get`)
/// untuk menyediakan metode penemuan atau injeksi dependensi alternatif.
extension GetXExtensions on GetInterface {
  /// Mengambil instance [T] dari GetX jika sudah diregistrasi.
  /// Jika belum, instance tersebut akan diregistrasi secara lazy (malas) menggunakan [Get.lazyPut].
  /// 
  /// Parameter [builder] adalah fungsi untuk membuat instance dari [T].
  /// Parameter opsional [fenix] (bawaan [false]) menentukan apakah instance harus
  /// dibuat ulang setelah dihapus.
  T findOrLazyPut<T>(T Function() builder, {bool fenix = false}) {
    if (Get.isRegistered<T>()) {
      return Get.find<T>();
    } else {
      Get.lazyPut<T>(builder, fenix: fenix);
      return Get.find<T>();
    }
  }

  /// Mengambil instance [T] dari GetX jika sudah diregistrasi.
  /// Jika belum, instance tersebut akan langsung diregistrasi dan dibuat menggunakan [Get.put].
  /// 
  /// Parameter [builder] adalah objek instance [T] yang ingin diregistrasi.
  /// Parameter [fenix] untuk kompatibilitas, meskipun [Get.put] tidak menggunakan fenix.
  T findOrPut<T>(T builder, {bool fenix = false}) {
    if (Get.isRegistered<T>()) {
      return Get.find<T>();
    } else {
      Get.put<T>(builder);
      return Get.find<T>();
    }
  }
}
