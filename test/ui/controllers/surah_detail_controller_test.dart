import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';

import '../../mocks/test_mocks.dart';

/// Class Mock untuk AudioSource.
class MockAudioSource extends Fake implements AudioSource {}

/// [SurahDetailControllerTest] menguji logika pemutaran audio dan integrasi playlist.
void main() {
  setUpAll(() {
    registerFallbackValue(MockAudioSource());
  });

  late MockQuranRepository mockRepository;
  late SurahDetailController controller;
  late MockGetStorage mockStorage;
  late MockAudioPlayer mockPlayer;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockQuranRepository();
    mockStorage = MockGetStorage();
    mockPlayer = MockAudioPlayer();
    
    Get.put<GetStorage>(mockStorage);
    Get.put(StorageManager());

    // Stubbing interaksi storage.
    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);

    // Mocking stream AudioPlayer untuk mengontrol reaktivitas controller.
    when(() => mockPlayer.playerStateStream).thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.currentIndexStream).thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.setAudioSource(any())).thenAnswer((_) async => null);

    controller = SurahDetailController(
      repository: mockRepository,
      player: mockPlayer,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('SurahDetailController Unit Test', () {
    test('getSurahDetail success sets dataList and setup player playlist',
        () async {
      // Arrange
      final surah = SurahModel(number: 1, englishName: 'Al-Fatiha');
      controller.surah.value = surah;

      final ayahList = [
        AyahModel(
            number: 1, text: 'Bismillah', audio: 'https://example.com/1.mp3'),
      ];

      when(() => mockRepository.getSurahDetail(
            surahNumber: 1,
            edition: any(named: 'edition'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => ayahList);

      // Act
      await controller.getSurahDetail();

      // Assert: Pastikan data list terisi dan playlist diset ke player.
      expect(controller.dataList.length, 1);
      expect(controller.dataList.first.text, 'Bismillah');
      expect(controller.isSuccess, true);
      verify(() => mockPlayer.setAudioSource(any())).called(1);
    });
  });
}
