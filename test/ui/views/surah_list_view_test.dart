import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/config/themes/app_theme.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:quran_player/core/localization/app_translations.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';

import '../../mocks/test_mocks.dart';

/// [SurahListViewTest] memverifikasi integrasi UI dan reaktivitas terhadap state controller.
void main() {
  late MockQuranRepository mockRepository;
  late MockGetStorage mockStorage;
  late SurahListController controller;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockQuranRepository();
    mockStorage = MockGetStorage();

    /// Setup dependensi singleton untuk widget testing.
    Get
      ..put<GetStorage>(mockStorage)
      ..put(StorageManager())
      ..put<QuranRepository>(mockRepository);

    /// Stubbing awal untuk mencegah error saat onReady controller dipanggil.
    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);
    when(
      () => mockRepository.getSurahList(
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => []);

    controller = SurahListController(repository: mockRepository);
    Get.put(controller);
  });

  tearDown(Get.reset);

  /// Helper untuk membangun MaterialApp dengan konfigurasi testing.
  Widget createWidget() {
    return GetMaterialApp(
      theme: AppTheme.light,
      translations: AppTranslation(),
      locale: const Locale('en'),
      home: const SurahListView(),
    );
  }

  testWidgets('SurahListView should show title and list items after loading',
      (tester) async {
    /// Arrange: Siapkan data mock.
    final surahList = [
      SurahModel(
        number: 1,
        name: 'الفاتحة',
        englishName: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      ),
    ];
    when(
      () => mockRepository.getSurahList(
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => surahList);

    /// Act: Render widget.
    await tester.pumpWidget(createWidget());

    /// Trigger manual pemuatan data.
    await controller.getSurahList();
    await tester.pump();

    /// Tunggu state update selesai.
    await tester.pump(const Duration(seconds: 1));

    /// Assert: Verifikasi elemen UI muncul dengan benar.
    expect(find.text('Al-Quran'), findsOneWidget);
    expect(find.text('The Opening'), findsOneWidget);
  });
}
