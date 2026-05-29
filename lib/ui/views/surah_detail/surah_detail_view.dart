import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';
import 'package:quran_player/ui/views/surah_detail/widgets/ayah_item_tile.dart';
import 'package:quran_player/ui/views/surah_detail/widgets/player_control_panel.dart';
import 'package:quran_player/ui/widgets/base/state_view.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';

/// [SurahDetailView] menangani tampilan ayat dan pemutar audio (Audio Player).
/// Principal Engineer Note: Menggunakan stack UI dengan gradient transparan
/// untuk memberikan efek "Glassmorphism" yang elegan.
class SurahDetailView extends GetView<SurahDetailController> {
  const SurahDetailView({super.key});
  static const String route = '/surah-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Memungkinkan body meluas ke bawah AppBar.
      extendBodyBehindAppBar: true,
      appBar: SkyAppBar.secondary(
        title:
            controller.surah.value?.englishName ?? 'txt_surah_detail_title'.tr,
        backgroundColor: Colors.transparent,
        iconColor: Colors.white,
      ),
      body: Container(
        // Desain background berlapis gradient (OP Design).
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colorScheme!.primary,
              context.colorScheme!.secondary.withValues(alpha: 0.8),
              context.colorScheme!.surface,
            ],
          ),
        ),
        child: Obx(
          () => StateView.component(
            loadingEnabled: controller.isLoading,
            errorEnabled: controller.isError,
            emptyEnabled: controller.isEmpty,
            onRetry: () => unawaited(controller.getSurahDetail()),
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Area daftar ayat yang scrollable.
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.dataList.length,
                    itemBuilder: (context, index) {
                      final ayah = controller.dataList[index];
                      // Komponen reusable AyahItemTile untuk memisahkan concern.
                      return AyahItemTile(
                        onTap: () {
                          // Seek ke posisi ayat tertentu dan mulai putar.
                          unawaited(
                            controller.player.seek(Duration.zero, index: index),
                          );
                          unawaited(controller.player.play());
                        },
                        ayah: ayah,
                        isCurrent: controller.currentAyahIndex.value == index,
                      );
                    },
                  ),
                ),
                // Panel kontrol audio yang "sticky" di bagian bawah.
                PlayerControlPanel(
                  onSeek: controller.seek,
                  onPrevious: controller.previous,
                  onNext: controller.next,
                  onPlayPause: controller.playPause,
                  player: controller.player,
                  isPlaying: controller.isPlaying.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
