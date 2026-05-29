import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:quran_player/ui/widgets/base/state_view.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'package:quran_player/ui/widgets/sky_form_field.dart';

/// [SurahListView] adalah halaman utama untuk penjelajahan surah.
/// Principal Note: Menggunakan pola GetView untuk memisahkan UI dan State (MVVM).
class SurahListView extends GetView<SurahListController> {
  const SurahListView({super.key});
  static const String route = '/surah-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengizinkan background body mengisi area di belakang AppBar.
      extendBodyBehindAppBar: true,
      appBar: SkyAppBar.primary(
        title: 'txt_quran_title'.tr,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // Latar belakang gradient untuk konsistensi desain dengan Splash.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colorScheme!.primary.withValues(alpha: 0.8),
              context.colorScheme!.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Widget Input pencarian surah (Search Discovery).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SkyFormField(
                hint: 'txt_search_surah_hint'.tr,
                onChanged: controller.onSearch,
                prefixWidget: const Icon(Icons.search, color: Colors.white70),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Obx(
                () => StateView.component(
                  // Mengelola transisi state: Loading -> Success/Error/Empty.
                  loadingEnabled: controller.isLoading,
                  errorEnabled: controller.isError,
                  emptyEnabled: controller.isEmpty,
                  onRetry: controller.getSurahList,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                    itemCount: controller.dataList.length,
                    itemBuilder: (context, index) {
                      final surah = controller.dataList[index];
                      // Setiap item surah dibungkus dalam Card dengan desain modern.
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: SurahNumberAvatar(number: surah.number ?? 0),
                          title: Text(
                            surah.englishName ?? '',
                            style: context.typography.body1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '${surah.revelationType == 'Meccan' ? 'txt_meccan'.tr : 'txt_medinan'.tr} • ${surah.numberOfAyahs} ${'txt_ayahs'.tr}',
                            style: context.typography.body2
                                .copyWith(color: Colors.black54),
                          ),
                          trailing: Text(
                            surah.name ?? '',
                            style: context.typography.headline3.copyWith(
                              color: context.colorScheme!.primary,
                              fontSize: 20,
                            ),
                          ),
                          onTap: () {
                            // Navigasi asinkron ke detail surah.
                            unawaited(
                              Get.toNamed(
                                SurahDetailView.route,
                                arguments: surah,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget kecil untuk menampilkan nomor surah dengan desain sirkular gradient.
class SurahNumberAvatar extends StatelessWidget {
  const SurahNumberAvatar({required this.number, super.key});
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            context.colorScheme!.primary,
            context.colorScheme!.secondary,
          ],
        ),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
