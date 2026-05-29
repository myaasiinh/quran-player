import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_view.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/localization/app_translations.dart';
import 'package:quran_player/config/themes/app_theme.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:get_storage/get_storage.dart';
import '../../mocks/test_mocks.dart';

void main() {
  late MockQuranRepository mockRepository;
  late MockGetStorage mockStorage;
  late SurahListController controller;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockQuranRepository();
    mockStorage = MockGetStorage();
    Get.put<GetStorage>(mockStorage);
    Get.put(StorageManager());
    Get.put<QuranRepository>(mockRepository);

    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);

    // Stub before controller initialization to avoid onReady error
    when(() =>
            mockRepository.getSurahList(cancelToken: any(named: 'cancelToken')))
        .thenAnswer((_) async => []);

    controller = SurahListController(repository: mockRepository);
    Get.put(controller);
  });

  tearDown(Get.reset);

  Widget createWidget() {
    return GetMaterialApp(
      theme: AppTheme.light,
      translations: AppTranslation(),
      locale: const Locale('en'),
      home: const SurahListView(),
    );
  }

  testWidgets('SurahListView should show title and list items', (tester) async {
    // Arrange
    final surahList = [
      SurahModel(
          number: 1,
          name: 'Al-Fatiha',
          englishName: 'The Opening',
          numberOfAyahs: 7,
          revelationType: 'Meccan'),
    ];
    when(() =>
            mockRepository.getSurahList(cancelToken: any(named: 'cancelToken')))
        .thenAnswer((_) async => surahList);

    // Act
    await tester.pumpWidget(createWidget());
    await controller.getSurahList(); // Manually trigger to use the new stub
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Al-Quran'), findsOneWidget);
    expect(find.text('The Opening'), findsOneWidget);
  });
}
