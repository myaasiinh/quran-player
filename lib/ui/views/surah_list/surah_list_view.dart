import 'dart:async';

import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:quran_player/ui/widgets/base/state_view.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'package:quran_player/ui/widgets/sky_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurahListView extends GetView<SurahListController> {
  const SurahListView({super.key});
  static const String route = '/surah-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyAppBar.primary(
        title: 'txt_quran_title'.tr,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SkyFormField(
              hint: 'txt_search_surah_hint'.tr,
              onChanged: controller.onSearch,
              prefixWidget: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: Obx(
              () => StateView.component(
                loadingEnabled: controller.isLoading,
                errorEnabled: controller.isError,
                emptyEnabled: controller.isEmpty,
                onRetry: () => unawaited(controller.getSurahList()),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.dataList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final surah = controller.dataList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(surah.number.toString()),
                      ),
                      title: Text(
                        surah.englishName ?? '',
                        style: context.typography.body1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${surah.revelationType == 'Meccan' ? 'txt_meccan'.tr : 'txt_medinan'.tr} - ${surah.numberOfAyahs} ${'txt_ayahs'.tr}',
                        style: context.typography.body2,
                      ),
                      trailing: Text(
                        surah.name ?? '',
                        style: context.typography.headline3,
                      ),
                      onTap: () {
                        unawaited(Get.toNamed(SurahDetailView.route,
                            arguments: surah));
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
