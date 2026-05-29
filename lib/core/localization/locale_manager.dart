import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/extension/context_extension.dart';
import '/ui/widgets/sky_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/
class LocaleManager {
  static LocaleManager get find => Get.find<LocaleManager>();

  StorageManager storage = StorageManager.find;

  final Map<String, Locale> locales = {
    'English': const Locale('en'),
    'Indonesia': const Locale('id'),
  };

  final fallbackLocale = const Locale('en');

  Future<void> showLocaleDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SkyDialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'txt_choose_language'.tr,
                style: context.typography.subtitle2,
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locales.length,
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1.5),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    final locale = locales.entries.toList()[index].value;
                    await updateLocale(locale);
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      locales.entries.toList()[index].key,
                      style: context.typography.body1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateLocale(Locale locale) async {
    await storage.save(StorageKey.CURRENT_LOCALE, locale.languageCode);
    await Get.updateLocale(locale);
  }

  Locale get getCurrentLocale {
    final currentLanguageCode =
        storage.get(StorageKey.CURRENT_LOCALE) as String?;
    if (currentLanguageCode != null) {
      if (currentLanguageCode == 'en') {
        return const Locale('en');
      } else {
        return const Locale('id');
      }
    } else {
      return Get.deviceLocale ?? fallbackLocale;
    }
  }
}
