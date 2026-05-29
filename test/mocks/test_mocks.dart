import 'package:meta/meta.dart';
import 'package:quran_player/config/base/request_param.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';

import 'package:just_audio/just_audio.dart';

class MockDio extends Mock implements Dio {}

class MockQuranSources extends Mock implements QuranSources {}

class MockQuranRepository extends Mock implements QuranRepository {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockGetxController extends Mock implements GetxController {}

class MockRequestParams extends Mock implements RequestParams {}

class MockStorageManager extends Mock implements StorageManager {}

class MockGetStorage extends Mock implements GetStorage {}

/// Base class for unit tests to provide common utilities
abstract class BaseUnitTest {
  @mustCallSuper
  void setup() {
    Get.testMode = true;
  }

  void tearDown() {
    Get.reset();
  }
}
