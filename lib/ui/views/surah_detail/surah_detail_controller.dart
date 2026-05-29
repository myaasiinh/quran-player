import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/config/base/base_controller.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';

/// [SurahDetailController] mengelola logika pemutaran audio per ayat (Ayah-by-Ayah).
class SurahDetailController extends BaseController<AyahModel> {
  /// Mendukung Dependency Injection untuk mock player selama testing.
  SurahDetailController({
    required this.repository,
    AudioPlayer? player,
  }) : player = player ?? AudioPlayer();

  final QuranRepository repository;
  final AudioPlayer player;

  // Controller untuk menangani scroll list ayat secara otomatis.
  final ScrollController scrollController = ScrollController();

  // Data surah yang diterima dari argument navigasi.
  final Rxn<SurahModel> surah = Rxn<SurahModel>();

  // State reaktif untuk status pemutaran audio.
  final RxBool isPlaying = false.obs;

  // State reaktif untuk melacak ayat mana yang sedang diputar.
  final RxInt currentAyahIndex = 0.obs;

  @override
  void onInit() {
    // Mengambil data surah dari argumen navigasi.
    surah.value = Get.arguments as SurahModel?;
    
    // Principal Note: Listener 'ever' memantau perubahan index ayat yang diputar.
    // Jika index berubah, trigger fungsi _scrollToCurrentAyah.
    ever(currentAyahIndex, (_) => _scrollToCurrentAyah());
    
    super.onInit();
  }

  @override
  void onReady() {
    // Memuat daftar ayat saat view ditampilkan.
    unawaited(getSurahDetail());
    super.onReady();
  }

  /// [getSurahDetail] mengambil daftar ayat beserta audio URL dari repository.
  Future<void> getSurahDetail() async {
    if (surah.value == null) return;
    await loadData(() async {
      final res = await repository.getSurahDetail(
        surahNumber: surah.value!.number!,
        edition: 'ar.alafasy', // Default menggunakan reciter Mishary Alafasy.
      );
      loadFinish(list: res);
      // Setelah data siap, siapkan playlist audio.
      unawaited(_setupPlaylist());
    });
  }

  /// Mengatur playlist audio berdasarkan daftar ayat yang tersedia.
  Future<void> _setupPlaylist() async {
    if (dataList.isEmpty) return;

    final playlist = ConcatenatingAudioSource(
      children: dataList
          .map((ayah) => AudioSource.uri(Uri.parse(ayah.audio!)))
          .toList(),
    );

    // Muat playlist ke player secara asinkron.
    await player.setAudioSource(playlist);

    // Pantau status pemutaran (playing/paused) untuk update UI tombol.
    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    // Pantau indeks ayat yang sedang aktif untuk highlight di list.
    player.currentIndexStream.listen((index) {
      if (index != null) {
        currentAyahIndex.value = index;
      }
    });
  }

  /// Memindahkan scroll ke ayat yang sedang diputar.
  /// Principal Note: Menggunakan perhitungan offset (estimasi tinggi item 100px)
  /// untuk memusatkan tampilan pada ayat yang aktif.
  void _scrollToCurrentAyah() {
    if (scrollController.hasClients) {
      // Estimasi offset: Index * Rata-rata tinggi item.
      final offset = currentAyahIndex.value * 100.0;
      unawaited(
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  /// Fungsi untuk memulai atau menghentikan pemutaran audio.
  void playPause() {
    if (player.playing) {
      unawaited(player.pause());
    } else {
      unawaited(player.play());
    }
  }

  /// Lompat ke durasi waktu tertentu pada audio yang sedang diputar.
  void seek(Duration position) {
    unawaited(player.seek(position));
  }

  /// Pindah ke ayat berikutnya jika tersedia.
  void next() {
    if (player.hasNext) {
      unawaited(player.seekToNext());
    }
  }

  /// Kembali ke ayat sebelumnya jika tersedia.
  void previous() {
    if (player.hasPrevious) {
      unawaited(player.seekToPrevious());
    }
  }

  @override
  Future<void> onClose() async {
    // Melepaskan resource player dan controller scroll.
    await player.dispose();
    scrollController.dispose();
    await super.onClose();
  }
}
