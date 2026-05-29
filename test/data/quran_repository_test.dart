import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository_impl.dart';

import '../mocks/test_mocks.dart';

/// [QuranRepositoryTest] memvalidasi logika pengambilan data dan caching.
/// Principal Note: Unit test repository sangat krusial untuk memastikan integritas data.
void main() {
  late MockQuranSources mockSources;
  late QuranRepositoryImpl repository;
  late MockGetStorage mockStorage;

  setUp(() {
    /// Mode test GetX untuk menonaktifkan navigasi asli.
    Get.testMode = true;
    mockSources = MockQuranSources();
    mockStorage = MockGetStorage();

    /// Injeksi dependensi storage mock.
    Get
      ..put<GetStorage>(mockStorage)
      ..put(StorageManager());

    /// Stubbing interaksi storage untuk mensimulasikan cache kosong.
    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.write(any(), any())).thenAnswer((_) async => {});
    when(() => mockStorage.hasData(any<String>())).thenReturn(false);

    repository = QuranRepositoryImpl(remote: mockSources);
  });

  tearDown(() {
    /// Reset seluruh state GetX setelah setiap test.
    Get.reset();
  });

  group('QuranRepositoryImpl Unit Test', () {
    test('getSurahList returns list of surahs from remote when cache is empty',
        () async {
      /// Arrange: Data surah palsu yang diharapkan dari remote.
      final surahList = [
        SurahModel(
          number: 1,
          name: 'Al-Fatiha',
          englishName: 'The Opening',
        ),
      ];

      /// Stubbing: Jika memanggil remote, berikan data palsu tersebut.
      when(
        () => mockSources.getSurahList(
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => surahList);

      /// Act: Jalankan fungsi yang diuji.
      final result = await repository.getSurahList();

      /// Assert: Pastikan hasil sesuai ekspektasi dan remote dipanggil 1 kali.
      expect(result, surahList);
      verify(
        () => mockSources.getSurahList(
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });
  });
}
