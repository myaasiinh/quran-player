/* Created by
   30/01/2024
   myaasiinh@gmail.com
*/

import '/ui/widgets/base/pagination/pagination_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Widget Pembantu yang menggabungkan [PagedSliverGrid] dan [PaginationDelegate].
///
/// Sangat berguna untuk membangun komponen kisi bertipe sliver dengan
/// cepat menggunakan satu widget secara praktis.
class PaginationSliverGrid<T> extends StatelessWidget {
  /// Konstruktor pembuatan widget [PaginationSliverGrid].
  const PaginationSliverGrid({
    required this.pagingController,
    required this.itemBuilder,
    required this.gridDelegate,
    required this.onRetry,
    super.key,
    this.onRefresh,
    this.padding,
    this.showNewPageErrorIndicatorAsGridChild = false,
    this.showNewPageProgressIndicatorAsGridChild = false,
    this.showNoMoreItemsIndicatorAsGridChild = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.loadingView,
    this.emptyView,
    this.errorView,
    this.errorLoadMoreView,
    this.maxItemView,
    this.emptyImage,
    this.emptyTitle,
    this.emptySubtitle,
    this.errorTitle,
    this.errorSubtitle,
    this.errorImage,
    this.errorImageWidget,
    this.retryText,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.imageHeight,
    this.imageWidth,
    this.errorTitleStyle,
    this.errorSubtitleStyle,
    this.retryWidget,
    this.emptyImageWidget,
    this.emptyTitleStyle,
    this.emptySubtitleStyle,
  });

  /// Kontroler yang mengatur data yang dimuat ke dalam grid (pagination).
  final PagingController<int, T> pagingController;
  /// Callback pembuat widget untuk setiap butir data kisi dengan tipe [T].
  final ItemWidgetBuilder<T> itemBuilder;
  /// Atribut pengaturan baris/kolom pada layout grid.
  final SliverGridDelegate gridDelegate;
  /// Fungsi panggilan balik ketika proses mengulang / coba lagi dijalankan.
  final VoidCallback onRetry;
  /// Apakah menampilkan indikator kesalahan sebagai anak grid atau disendirikan.
  final bool showNewPageErrorIndicatorAsGridChild;
  /// Apakah menampilkan indikator kemajuan sebagai anak grid atau disendirikan.
  final bool showNewPageProgressIndicatorAsGridChild;
  /// Apakah menampilkan indikator habis data sebagai anak grid atau disendirikan.
  final bool showNoMoreItemsIndicatorAsGridChild;
  /// Mengaktifkan kemampuan keep alive secara otomatis.
  final bool addAutomaticKeepAlives;
  /// Memisahkan rendering dari objek daftar dengan objek lain.
  final bool addRepaintBoundaries;
  /// Menyediakan nomor index secara semantik (aksesibilitas).
  final bool addSemanticIndexes;
  /// Mengecilkan indikator batas halaman awal bila di awal.
  final bool shrinkWrapFirstPageIndicators = false;
  /// Widget tampilan khusus saat sedang proses memuat.
  final Widget? loadingView;
  /// Widget tampilan khusus ketika tidak ada data sama sekali.
  final Widget? emptyView;
  /// Widget tampilan ketika daftar telah mencapai batas data maksimum.
  final Widget? maxItemView;
  /// Widget kustom untuk tampilan saat terjadi ralat (error).
  final Widget? errorView;
  /// Widget khusus error saat proses memuat halaman selanjutnya.
  final Widget? errorLoadMoreView;
  /// Panggilan callback penyegaran ulang halaman.
  final VoidCallback? onRefresh;
  /// Widget kustom untuk gambar saat data kosong.
  final Widget? emptyImageWidget;
  /// Jalur (path) teks gambar yang digunakan saat data kosong.
  final String? emptyImage;
  /// Judul pesan error.
  final String? errorTitle;
  /// Subjudul atau penjelasan detail error.
  final String? errorSubtitle;
  /// Judul ketika status daftar dalam keadaan kosong.
  final String? emptyTitle;
  /// Subjudul pendukung ketika daftar keadaan kosong.
  final String? emptySubtitle;
  /// Gaya teks untuk judul empty state.
  final TextStyle? emptyTitleStyle;
  /// Gaya teks untuk subjudul empty state.
  final TextStyle? emptySubtitleStyle;
  /// Menandakan jika menggunakan tampilan gaya iOS / Cupertino.
  final bool enableIOSStyle = true;
  /// Jalur (path) aset gambar ketika terjadi error.
  final String? errorImage;
  /// Widget kustom untuk gambar error.
  final Widget? errorImageWidget;
  /// Teks tombol "coba lagi".
  final String? retryText;
  /// Jarak vertikal yang membatasi antar konten layout error/empty.
  final double? verticalSpacing;
  /// Jarak horizontal yang membatasi antar konten layout error/empty.
  final double? horizontalSpacing;
  /// Nilai tinggi untuk gambar error/empty.
  final double? imageHeight;
  /// Nilai lebar untuk gambar error/empty.
  final double? imageWidth;
  /// Gaya teks kustom untuk judul pesan error.
  final TextStyle? errorTitleStyle;
  /// Gaya teks kustom untuk subjudul pesan error.
  final TextStyle? errorSubtitleStyle;
  /// Widget kustom tombol "coba lagi".
  final Widget? retryWidget;
  /// Arah penggulungan list, untuk sementara Grid dibuat Vertikal saja.
  final Axis scrollDirection = Axis.vertical;
  /// Tombol muat ulang untuk status kosong diaktifkan.
  final bool emptyRetryEnabled = false;
  /// Nilai padding atau batas luar sliver padding.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    // Membungkus list dengan padding diluar scope list utama.
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      // Mendengarkan perubahan pada controller
      sliver: PagingListener(
        controller: pagingController,
        // Builder perantara untuk melampirkan logic dengan list bawaan flutter
        builder: (context, state, fetchNextPage) => PagedSliverGrid(
          // Delegate grid
          gridDelegate: gridDelegate,
          // Mengambil state terkini
          state: state,
          // Pemicu ambil data halaman berikutnya
          fetchNextPage: fetchNextPage,
          // Pengoptimalan ulang layout per baris
          addRepaintBoundaries: addRepaintBoundaries,
          // Penyisipan indeks semantik
          addSemanticIndexes: addSemanticIndexes,
          // Menjaga widget state tetap hidup meski tak terlihat
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          // Menampilkan indikator memuat dan status limit list di grid child
          showNoMoreItemsIndicatorAsGridChild:
              showNoMoreItemsIndicatorAsGridChild,
          showNewPageErrorIndicatorAsGridChild:
              showNewPageErrorIndicatorAsGridChild,
          showNewPageProgressIndicatorAsGridChild:
              showNewPageProgressIndicatorAsGridChild,
          // Indikator tak perlu makan ruang besar di halaman awal
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          // Menetapkan aturan pengelolaan desain loading state, list kosong dan ralat
          builderDelegate: PaginationDelegate<T>(
            pagingController: pagingController,
            onRetry: onRetry,
            loadingView: loadingView,
            emptyView: emptyView,
            emptyRetryEnabled: emptyRetryEnabled,
            emptyTitle: emptyTitle,
            emptyTitleStyle: emptyTitleStyle,
            errorTitleStyle: errorTitleStyle,
            errorTitle: errorTitle,
            errorSubtitle: errorSubtitle,
            errorSubtitleStyle: errorSubtitleStyle,
            errorImage: errorImage,
            errorImageWidget: errorImageWidget,
            retryText: retryText,
            retryWidget: retryWidget,
            maxItemView: maxItemView,
            emptyImage: emptyImage,
            emptyImageWidget: emptyImageWidget,
            emptySubtitle: emptySubtitle,
            emptySubtitleStyle: emptySubtitleStyle,
            verticalSpacing: verticalSpacing,
            horizontalSpacing: horizontalSpacing,
            imageHeight: imageHeight,
            imageWidth: imageWidth,
            itemBuilder: itemBuilder,
            errorLoadMoreView: errorLoadMoreView,
            errorView: errorView,
          ),
        ),
      ),
    );
  }
}
