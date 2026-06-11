/* Dibuat oleh
   30/01/2024
   myaasiinh@gmail.com
*/

import '/ui/widgets/base/empty_view.dart';
import '/ui/widgets/base/error_view.dart';
import '/ui/widgets/platform_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Fungsi [PaginationDelegate] digunakan untuk membuat [PagedChildBuilderDelegate]
/// yang merupakan delegasi untuk menampilkan daftar yang mendukung pagination (halaman).
/// 
/// Fungsi ini menyediakan pengaturan bawaan untuk tampilan loading, kosong, dan error
/// yang dapat disesuaikan sesuai kebutuhan.
PagedChildBuilderDelegate<T> PaginationDelegate<T>({
  /// Controller untuk mengelola state dari pagination.
  required PagingController<int, T> pagingController,
  
  /// Fungsi builder untuk membuat widget dari setiap item data.
  required ItemWidgetBuilder<T> itemBuilder,
  
  /// Callback yang dipanggil ketika tombol coba lagi (retry) ditekan.
  required VoidCallback onRetry,
  
  /// Widget kustom untuk tampilan loading.
  Widget? loadingView,
  
  /// Widget kustom untuk tampilan ketika data kosong.
  Widget? emptyView,
  
  /// Widget kustom untuk gambar pada tampilan kosong.
  Widget? emptyImageWidget,
  
  /// Path gambar yang akan ditampilkan pada tampilan kosong.
  String? emptyImage,
  
  /// Teks judul pada tampilan kosong.
  String? emptyTitle,
  
  /// Teks subjudul pada tampilan kosong.
  String? emptySubtitle,
  
  /// Widget kustom untuk gambar pada tampilan error.
  Widget? errorImageWidget,
  
  /// Path gambar yang akan ditampilkan pada tampilan error.
  String? errorImage,
  
  /// Teks judul pada tampilan error.
  String? errorTitle,
  
  /// Teks subjudul pada tampilan error.
  String? errorSubtitle,
  
  /// Tinggi gambar untuk tampilan kosong dan error.
  double? imageHeight,
  
  /// Lebar gambar untuk tampilan kosong dan error.
  double? imageWidth,
  
  /// Jarak vertikal antar elemen pada tampilan kosong dan error.
  double? verticalSpacing,
  
  /// Jarak horizontal pada tampilan kosong dan error.
  double? horizontalSpacing,
  
  /// Gaya teks (TextStyle) untuk judul pada tampilan kosong.
  TextStyle? emptyTitleStyle,
  
  /// Gaya teks (TextStyle) untuk subjudul pada tampilan kosong.
  TextStyle? emptySubtitleStyle,
  
  /// Menentukan apakah tombol coba lagi diaktifkan pada tampilan kosong.
  bool emptyRetryEnabled = false,
  
  /// Widget kustom untuk tampilan error.
  Widget? errorView,
  
  /// Widget kustom untuk tampilan error saat memuat lebih banyak data.
  Widget? errorLoadMoreView,
  
  /// Teks untuk tombol coba lagi.
  String? retryText,
  
  /// Widget kustom untuk tombol coba lagi.
  Widget? retryWidget,
  
  /// Gaya teks (TextStyle) untuk judul pada tampilan error.
  TextStyle? errorTitleStyle,
  
  /// Gaya teks (TextStyle) untuk subjudul pada tampilan error.
  TextStyle? errorSubtitleStyle,
  
  /// Widget yang ditampilkan ketika sudah mencapai batas maksimal item.
  Widget? maxItemView,
  
  /// Widget pemisah (separator) antar item.
  Widget? separator,
}) {
  return PagedChildBuilderDelegate<T>(
    animateTransitions: true,
    
    // Tampilan indikator loading untuk halaman baru (memuat lebih banyak)
    newPageProgressIndicatorBuilder: (ctx) => const Padding(
      padding: EdgeInsets.all(24),
      child: PlatformLoadingIndicator(),
    ),
    
    // Tampilan indikator loading untuk halaman pertama
    firstPageProgressIndicatorBuilder: (ctx) =>
        loadingView ??
        const Padding(
          padding: EdgeInsets.all(24),
          child: PlatformLoadingIndicator(),
        ),
        
    // Tampilan ketika tidak ada item yang ditemukan (kosong)
    noItemsFoundIndicatorBuilder: (ctx) =>
        emptyView ??
        EmptyView(
          emptyImage: emptyImage,
          emptyImageWidget: emptyImageWidget,
          emptyTitle: emptyTitle,
          emptySubtitle: emptySubtitle,
          titleStyle: emptyTitleStyle,
          subtitleStyle: emptySubtitleStyle,
          horizontalSpacing: horizontalSpacing ?? 24,
          verticalSpacing: verticalSpacing ?? 24,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          emptyRetryEnabled: emptyRetryEnabled,
          onRetry: () {
            pagingController.refresh();
            onRetry();
          },
          physics: const NeverScrollableScrollPhysics(),
        ),
        
    // Tampilan error untuk memuat halaman pertama
    firstPageErrorIndicatorBuilder: (ctx) =>
        errorView ??
        ErrorView(
          errorImage: errorImage,
          errorImageWidget: errorImageWidget,
          errorTitle:
              '${errorTitle ?? pagingController.value.error ?? 'txt_err_general_formal'.tr}',
          errorSubtitle: errorSubtitle,
          horizontalSpacing: horizontalSpacing ?? 24,
          verticalSpacing: verticalSpacing ?? 24,
          titleStyle: errorTitleStyle,
          subtitleStyle: errorSubtitleStyle,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          retryText: retryText,
          retryWidget: retryWidget,
          physics: const BouncingScrollPhysics(),
          onRetry: () {
            pagingController.refresh();
            onRetry();
          },
        ),
        
    // Tampilan ketika tidak ada lagi item yang bisa dimuat
    noMoreItemsIndicatorBuilder: (ctx) =>
        maxItemView ?? const SizedBox.shrink(),
        
    // Tampilan error saat memuat halaman baru (memuat lebih banyak)
    newPageErrorIndicatorBuilder: (ctx) =>
        errorLoadMoreView ??
        InkWell(
          onTap: onRetry,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: errorLoadMoreView ?? const Icon(CupertinoIcons.refresh),
              ),
              Text('txt_tap_retry'.tr),
            ],
          ),
        ),
        
    // Builder untuk menampilkan setiap item data beserta separatornya (jika ada)
    itemBuilder: separator == null
        ? itemBuilder
        : (context, item, index) {
            return Column(
              children: [
                itemBuilder(context, item, index),
                // Jangan tampilkan separator di item terakhir
                if (index != (pagingController.value.items?.length ?? 0) - 1)
                  separator,
              ],
            );
          },
  );
}
