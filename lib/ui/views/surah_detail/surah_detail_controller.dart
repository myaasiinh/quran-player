import 'dart:async';

import 'package:quran_player/config/base/base_controller.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class SurahDetailController extends BaseController<AyahModel> {
  SurahDetailController({
    required this.repository,
    AudioPlayer? player,
  }) : player = player ?? AudioPlayer();

  final QuranRepository repository;
  final AudioPlayer player;

  final Rxn<SurahModel> surah = Rxn<SurahModel>();
  final RxBool isPlaying = false.obs;
  final RxInt currentAyahIndex = 0.obs;

  @override
  void onInit() {
    surah.value = Get.arguments as SurahModel?;
    super.onInit();
  }

  @override
  void onReady() {
    unawaited(getSurahDetail());
    super.onReady();
  }

  Future<void> getSurahDetail() async {
    if (surah.value == null) return;
    await loadData(() async {
      final res = await repository.getSurahDetail(
        surahNumber: surah.value!.number!,
        edition: 'ar.alafasy', // Default to Alafasy
      );
      loadFinish(list: res);
      unawaited(_setupPlaylist());
    });
  }

  Future<void> _setupPlaylist() async {
    if (dataList.isEmpty) return;

    final playlist = ConcatenatingAudioSource(
      children: dataList
          .map((ayah) => AudioSource.uri(Uri.parse(ayah.audio!)))
          .toList(),
    );

    await player.setAudioSource(playlist);

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    player.currentIndexStream.listen((index) {
      if (index != null) {
        currentAyahIndex.value = index;
      }
    });
  }

  void playPause() {
    if (player.playing) {
      unawaited(player.pause());
    } else {
      unawaited(player.play());
    }
  }

  void seek(Duration position) {
    unawaited(player.seek(position));
  }

  void next() {
    unawaited(player.seekToNext());
  }

  void previous() {
    unawaited(player.seekToPrevious());
  }

  @override
  Future<void> onClose() async {
    await player.dispose();
    await super.onClose();
  }
}
