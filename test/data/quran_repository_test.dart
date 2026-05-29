import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import '../mocks/test_mocks.dart';

void main() {
  late MockQuranSources mockSources;
  late QuranRepositoryImpl repository;
  late MockGetStorage mockStorage;

  setUp(() {
    Get.testMode = true;
    mockSources = MockQuranSources();
    mockStorage = MockGetStorage();
    Get.put<GetStorage>(mockStorage);
    Get.put(StorageManager());

    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.write(any(), any())).thenAnswer((_) async => {});
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);

    repository = QuranRepositoryImpl(remote: mockSources);
  });

  tearDown(Get.reset);

  group('QuranRepositoryImpl Unit Test', () {
    test('getSurahList returns list of surahs from remote when cache is empty',
        () async {
      // Arrange
      final surahList = [
        SurahModel(number: 1, name: 'Al-Fatiha', englishName: 'The Opening'),
      ];
      when(() =>
              mockSources.getSurahList(cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => surahList);

      // Act
      final result = await repository.getSurahList();

      // Assert
      expect(result, surahList);
      verify(() =>
              mockSources.getSurahList(cancelToken: any(named: 'cancelToken')))
          .called(1);
    });
  });
}
