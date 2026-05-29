import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import '../../mocks/test_mocks.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  late MockQuranRepository mockRepository;
  late SurahListController controller;
  late MockGetStorage mockStorage;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockQuranRepository();
    mockStorage = MockGetStorage();
    Get.put<GetStorage>(mockStorage);
    Get.put(StorageManager());

    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);

    controller = SurahListController(repository: mockRepository);
  });

  tearDown(Get.reset);

  group('SurahListController Unit Test', () {
    test('getSurahList success sets dataList', () async {
      // Arrange
      final surahList = [
        SurahModel(number: 1, englishName: 'Al-Fatiha'),
      ];
      when(() => mockRepository.getSurahList(
              cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => surahList);

      // Act
      await controller.getSurahList();

      // Assert
      expect(controller.dataList.length, 1);
      expect(controller.dataList.first.englishName, 'Al-Fatiha');
      expect(controller.isSuccess, true);
    });

    test('onSearch filters dataList', () async {
      // Arrange
      final surahList = [
        SurahModel(number: 1, englishName: 'Al-Fatiha'),
        SurahModel(number: 2, englishName: 'Al-Baqara'),
      ];
      when(() => mockRepository.getSurahList(
              cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => surahList);
      await controller.getSurahList();

      // Act
      controller.onSearch('Baqara');

      // Assert
      expect(controller.dataList.length, 1);
      expect(controller.dataList.first.englishName, 'Al-Baqara');
    });
  });
}
