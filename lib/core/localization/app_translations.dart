import '/core/localization/languages/english.dart';
import '/core/localization/languages/indonesian.dart';
import 'package:get/get.dart';

/// Kelas utama yang mengelola daftar terjemahan (Translations) untuk package Get.
/// Mewarisi [Translations] dan menyediakan kamus untuk berbagai bahasa.
class AppTranslation extends Translations {
  /// Mengembalikan pemetaan (Map) antara kode bahasa dan daftar pasangan key-value teks terjemahannya.
  /// 'en' untuk bahasa Inggris, 'id' untuk bahasa Indonesia.
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'id': id};
}
