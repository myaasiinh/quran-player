import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/localization/app_translations.dart';
import 'package:quran_player/config/themes/app_theme.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../../mocks/test_mocks.dart';

class MockAudioSource extends Fake implements AudioSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAudioSource());
  });

  late MockQuranRepository mockRepository;
  late MockGetStorage mockStorage;
  late MockAudioPlayer mockPlayer;
  late SurahDetailController controller;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockQuranRepository();
    mockStorage = MockGetStorage();
    mockPlayer = MockAudioPlayer();

    Get.put<GetStorage>(mockStorage);
    Get.put(StorageManager());
    Get.put<QuranRepository>(mockRepository);

    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);

    when(() => mockPlayer.playerStateStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.currentIndexStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.positionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.durationStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.bufferedPositionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.setAudioSource(any())).thenAnswer((_) async => null);

    // Initial stub
    when(
      () => mockRepository.getSurahDetail(
        surahNumber: any(named: 'surahNumber'),
        edition: any(named: 'edition'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => []);

    controller =
        SurahDetailController(repository: mockRepository, player: mockPlayer);
    Get.put(controller);
  });

  tearDown(Get.reset);

  Widget createWidget(SurahModel surah) {
    controller.surah.value = surah;
    return GetMaterialApp(
      theme: AppTheme.light,
      translations: AppTranslation(),
      locale: const Locale('en'),
      home: const SurahDetailView(),
    );
  }

  testWidgets('SurahDetailView should show ayah list and player controls',
      (tester) async {
    // Arrange
    final surah = SurahModel(number: 1, englishName: 'Al-Fatiha');
    final ayahList = [
      AyahModel(
          number: 1,
          text: 'Bismillah',
          numberInSurah: 1,
          audio: 'https://example.com/1.mp3'),
    ];

    when(
      () => mockRepository.getSurahDetail(
        surahNumber: 1,
        edition: any(named: 'edition'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => ayahList);

    // Act
    await tester.pumpWidget(createWidget(surah));
    await controller.getSurahDetail();
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Al-Fatiha'), findsOneWidget);
    expect(find.text('Bismillah'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle), findsOneWidget);
  });
}
