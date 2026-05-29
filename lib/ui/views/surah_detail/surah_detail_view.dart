import 'dart:async';

import 'package:quran_player/ui/views/surah_detail/surah_detail_controller.dart';
import 'package:quran_player/ui/views/surah_detail/widgets/ayah_item_tile.dart';
import 'package:quran_player/ui/views/surah_detail/widgets/player_control_panel.dart';
import 'package:quran_player/ui/widgets/base/state_view.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurahDetailView extends GetView<SurahDetailController> {
  const SurahDetailView({super.key});
  static const String route = '/surah-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyAppBar.secondary(
        title:
            controller.surah.value?.englishName ?? 'txt_surah_detail_title'.tr,
      ),
      body: Obx(
        () => StateView.component(
          loadingEnabled: controller.isLoading,
          errorEnabled: controller.isError,
          emptyEnabled: controller.isEmpty,
          onRetry: () => unawaited(controller.getSurahDetail()),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.dataList.length,
                  itemBuilder: (context, index) {
                    final ayah = controller.dataList[index];
                    return AyahItemTile(
                      onTap: () {
                        unawaited(controller.player
                            .seek(Duration.zero, index: index));
                        unawaited(controller.player.play());
                      },
                      ayah: ayah,
                      isCurrent: controller.currentAyahIndex.value == index,
                    );
                  },
                ),
              ),
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
    );
  }
}
