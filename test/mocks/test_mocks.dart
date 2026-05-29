import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/config/base/request_param.dart';
import 'package:quran_player/core/database/storage/storage_manager.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:quran_player/data/sources/server/quran/quran_sources.dart';

/// [MockDio] mensimulasikan client HTTP Dio.
class MockDio extends Mock implements Dio {}

/// [MockQuranSources] mensimulasikan data source API Al-Quran.
class MockQuranSources extends Mock implements QuranSources {}

/// [MockQuranRepository] mensimulasikan abstraction layer data Al-Quran.
class MockQuranRepository extends Mock implements QuranRepository {}

/// [MockAudioPlayer] mensimulasikan engine pemutar audio just_audio.
class MockAudioPlayer extends Mock implements AudioPlayer {}

/// [MockGetxController] mensimulasikan controller GetX standar.
class MockGetxController extends Mock implements GetxController {}

/// [MockRequestParams] mensimulasikan parameter request.
class MockRequestParams extends Mock implements RequestParams {}

/// [MockStorageManager] mensimulasikan pengelola storage lokal.
class MockStorageManager extends Mock implements StorageManager {}

/// [MockGetStorage] mensimulasikan database key-value GetStorage.
class MockGetStorage extends Mock implements GetStorage {}

/// [BaseUnitTest] menyediakan utilitas dasar untuk setiap pengujian unit.
/// Principal Note: Menjamin state testing GetX selalu bersih di awal dan akhir test.
abstract class BaseUnitTest {
  @mustCallSuper
  void setup() {
    // Aktifkan mode test GetX untuk menghindari efek samping navigasi asli.
    Get.testMode = true;
  }

  void tearDown() {
    // Bersihkan seluruh registrasi DI setelah test selesai.
    Get.reset();
  }
}
