import 'dart:ui';

import '/core/localization/locale_manager.dart';

/// Kelas pembantu untuk menangani logika yang berhubungan dengan lokalisasi secara langsung.
class LocaleHelper {
  /// Mengembalikan nilai bertipe [T] berdasarkan bahasa aplikasi saat ini.
  /// Berguna untuk menampilkan data atau aset berbeda sesuai bahasa yang sedang aktif.
  /// 
  /// [en] nilai yang dikembalikan jika bahasa saat ini adalah Inggris.
  /// [id] nilai yang dikembalikan jika bahasa saat ini adalah Indonesia (atau selain Inggris).
  static T builder<T>({required T en, required T id}) {
    if (LocaleManager.find.getCurrentLocale == const Locale('en')) {
      return en;
    } else {
      return id;
    }
  }
}
