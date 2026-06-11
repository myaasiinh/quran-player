import 'package:get/get.dart';

/// Ekstensi untuk tipe data [int] guna menghitung ukuran relatif 
/// berdasarkan lebar atau tinggi layar menggunakan package Get.
extension SizeIntExtension on int {
  /// Mengembalikan nilai proporsional terhadap lebar layar (Get.width).
  /// Jika nilai lebih dari atau sama dengan 100, mengembalikan lebar layar penuh.
  double get w {
    if (this >= 100) return Get.width;
    return this / 100 * Get.width;
  }

  /// Mengembalikan nilai proporsional terhadap tinggi layar (Get.height).
  /// Jika nilai lebih dari atau sama dengan 100, mengembalikan tinggi layar penuh.
  double get h {
    if (this >= 100) return Get.height;
    return this / 100 * Get.height;
  }
}

/// Ekstensi untuk tipe data [double] guna menghitung ukuran relatif 
/// berdasarkan lebar atau tinggi layar menggunakan package Get.
extension DoubleIntExtension on double {
  /// Mengembalikan nilai proporsional terhadap lebar layar (Get.width).
  /// Jika nilai lebih dari atau sama dengan 100, mengembalikan lebar layar penuh.
  double get w {
    if (this >= 100) return Get.width;
    return this / 100 * Get.width;
  }

  /// Mengembalikan nilai proporsional terhadap tinggi layar (Get.height).
  /// Jika nilai lebih dari atau sama dengan 100, mengembalikan tinggi layar penuh.
  double get h {
    if (this >= 100) return Get.height;
    return this / 100 * Get.height;
  }
}
