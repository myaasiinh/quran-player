import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_player/config/environment/app_env.dart';
import 'package:quran_player/config/themes/app_theme.dart';
import 'package:quran_player/config/themes/theme_manager.dart';
import 'package:quran_player/core/localization/app_translations.dart';
import 'package:quran_player/core/localization/locale_manager.dart';
import 'package:quran_player/service_locator.dart';
import 'package:quran_player/ui/routes/app_routes.dart';
import 'package:quran_player/ui/views/404_500/crash_error_view.dart';
import 'package:quran_player/ui/views/404_500/unknown_page.dart';

/// [main] adalah entry point utama aplikasi.
/// Principal Engineer Note: Menggunakan pola async main untuk memastikan
/// semua dependensi kritikal (Storage, DI, Env) siap sebelum UI dirender.
void main() async {
  // Menjamin framework Flutter telah terinisialisasi.
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Service Locator (Dependency Injection).
  await ServiceLocator.init();

  if (AppEnv.env.isDev) {
    // Mode Development: Menggunakan DevicePreview untuk testing responsivitas.
    runApp(DevicePreview(builder: (context) => const App()));
  } else {
    // Mode Production/Staging: Inisialisasi format tanggal lokal Indonesia.
    await initializeDateFormatting('id');
    runApp(const App());
  }
}

/// [App] adalah root widget yang mengonfigurasi tema, routing, dan lokalisasi.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan GetX<ThemeManager> untuk reaktivitas tema (Light/Dark mode).
    return GetX<ThemeManager>(
      builder: (theme) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran Player',
        // Konfigurasi Tema Global.
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: (theme.isDark.isTrue) ? ThemeMode.dark : ThemeMode.light,
        // Konfigurasi Lokalisasi (Multi-bahasa).
        translations: AppTranslation(),
        locale: LocaleManager.find.getCurrentLocale,
        fallbackLocale: LocaleManager.find.fallbackLocale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocaleManager.find.locales.values,
        // Konfigurasi Routing.
        getPages: AppPages.routes,
        initialRoute: AppPages.initial,
        unknownRoute: unknownPage,
        // Builder global untuk menangani error widget (Crash Error View).
        builder: (context, child) {
          ErrorWidget.builder = (error) {
            return CrashErrorView(errorDetails: error);
          };
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
