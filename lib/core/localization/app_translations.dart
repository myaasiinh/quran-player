import '/core/localization/languages/english.dart';
import '/core/localization/languages/indonesian.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'id': id};
}
