/* Created by
   30/01/2024
   myaasiinh@gmail.com
*/

import 'dart:io';

import '/ui/widgets/base/pagination/pagination_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Enum untuk mendefinisikan tipe tata letak pagination:
/// [list] untuk daftar vertikal/horizontal biasa.
/// [grid] untuk tata letak kisi (grid).
enum PaginationType { list, grid }

/// Widget pintar untuk merender daftar data berpaginasi (infinite scroll)
/// beserta manajemen statusnya (memuat, kosong, ralat, data maksimal).
///
/// Menyediakan dukungan terpisah antara Android (RefreshIndicator)
/// dan iOS (CupertinoSliverRefreshControl) secara bawaan.
class PaginationStateView<T> extends StatelessWidget {
  /// Konstruktor khusus untuk membuat pagination dalam bentuk [ListView].
  const PaginationStateView.list({
    required this.pagingController,
    required this.itemBuilder,
    required this.onRetry,
    super.key,
    this.onRefresh,
    this.loadingView,
    this.emptyView,
    this.maxItemView,
    this.errorView,
    this.errorLoadMoreView,
    this.shrinkWrap = false,
    this.shrinkWrapFirstPageIndicators = false,
    this.physics,
    this.separator,
    this.emptyImageWidget,
    this.emptyImage,
    this.errorTitle,
    this.errorSubtitle,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyTitleStyle,
    this.emptySubtitleStyle,
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
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.emptyRetryEnabled = false,
    this.addAutomaticKeepAlives,
    this.addRepaintBoundaries,
    this.addSemanticIndexes,
    this.cacheExtent,
    this.clipBehavior,
    this.dragStartBehavior,
    this.itemExtent,
    this.keyboardDismissBehavior,
    this.primary,
    this.reverse,
    this.scrollController,
    this.restorationId,
    this.prototypeItem,
    this.semanticIndexCallback,
    this.scrollBehavior,
    this.semanticChildCount,
    this.anchor,
    this.center,
  })  : assert(
          // Fitur tarik-untuk-menyegarkan (pull-to-refresh) tidak didukung pada sumbu horizontal
          (scrollDirection == Axis.horizontal && onRefresh == null) ||
              scrollDirection == Axis.vertical,
          'onRefresh is not supported for horizontal scrolling',
        ),
        type = PaginationType.list,
        gridDelegate = null,
        showNewPageErrorIndicatorAsGridChild = null,
        showNewPageProgressIndicatorAsGridChild = null,
        showNoMoreItemsIndicatorAsGridChild = null;

  /// Konstruktor khusus untuk membuat pagination dalam bentuk [GridView].
  const PaginationStateView.grid({
    required this.pagingController,
    required this.itemBuilder,
    required this.gridDelegate,
    required this.onRetry,
    super.key,
    this.onRefresh,
    this.showNewPageErrorIndicatorAsGridChild,
    this.showNewPageProgressIndicatorAsGridChild,
    this.showNoMoreItemsIndicatorAsGridChild,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.emptyRetryEnabled = false,
    this.addAutomaticKeepAlives,
    this.addRepaintBoundaries,
    this.addSemanticIndexes,
    this.cacheExtent,
    this.clipBehavior,
    this.dragStartBehavior,
    this.itemExtent,
    this.keyboardDismissBehavior,
    this.primary,
    this.reverse,
    this.scrollController,
    this.restorationId,
    this.loadingView,
    this.emptyView,
    this.maxItemView,
    this.errorView,
    this.errorLoadMoreView,
    this.shrinkWrap = false,
    this.shrinkWrapFirstPageIndicators = false,
    this.physics,
    this.emptyImageWidget,
    this.emptyImage,
    this.errorTitle,
    this.errorSubtitle,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyTitleStyle,
    this.emptySubtitleStyle,
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
  })  : type = PaginationType.grid,
        separator = null,
        prototypeItem = null,
        semanticIndexCallback = null,
        scrollBehavior = null,
        semanticChildCount = null,
        anchor = null,
        center = null;

  /// Tipe layout pagination (List atau Grid).
  final PaginationType type;
  /// Mengatur arus data, memuat, dan status UI.
  final PagingController<int, T> pagingController;
  /// Callback pembangun widget setiap item list.
  final ItemWidgetBuilder<T> itemBuilder;

  /// Membungkus daftar agar sesuai dengan ukuran isinya.
  final bool shrinkWrap;
  /// Pengaturan sifat gulir (bouncing, clamping, dll).
  final ScrollPhysics? physics;
  /// Widget pemisah antar item khusus tipe List.
  final Widget? separator;
  /// Pengaturan jarak bagian luar list.
  final EdgeInsetsGeometry? padding;
  /// Arah gulir (vertikal atau horizontal).
  final Axis scrollDirection;
  /// Tetap menyimpan state item yang keluar dari viewport.
  final bool? addAutomaticKeepAlives;
  /// Menghindari penggambaran ulang item tak perlu.
  final bool? addRepaintBoundaries;
  /// Dukungan nomor aksesibilitas pembaca layar.
  final bool? addSemanticIndexes;
  /// Batas rendering di luar layar (buffer).
  final double? cacheExtent;
  /// Bagaimana anak elemen dipotong jika melebihi batas.
  final Clip? clipBehavior;
  /// Menentukan cara menangani gestur menyeret dari awal.
  final DragStartBehavior? dragStartBehavior;
  /// Lebar/tinggi spesifik untuk semua item (membantu performa).
  final double? itemExtent;
  /// Cara papan tik ditutup saat pengguna menggulir.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  /// Apakah ini pandangan utama di PrimaryScrollController.
  final bool? primary;
  /// Menggulir dan menyusun list secara terbalik.
  final bool? reverse;
  /// Kontrol gulir kustom dari luar widget.
  final ScrollController? scrollController;
  /// Menyimpan status posisi scroll.
  final String? restorationId;

  /// Penentu kisi khusus tipe Grid.
  final SliverGridDelegate? gridDelegate;
  /// Status error untuk grid berada di dalam grid child.
  final bool? showNewPageErrorIndicatorAsGridChild;
  /// Indikator kemajuan loading pada grid berada di dalam grid child.
  final bool? showNewPageProgressIndicatorAsGridChild;
  /// Indikator batas maksimum grid di dalam grid child.
  final bool? showNoMoreItemsIndicatorAsGridChild;

  /// Widget acuan khusus tipe SliverList.
  final Widget? prototypeItem;
  /// Hitungan index khusus semantik.
  final int? Function(Widget, int)? semanticIndexCallback;
  /// Gaya gulir (ScrollBehavior) kustom.
  final ScrollBehavior? scrollBehavior;
  /// Jumlah maksimal child untuk semantic.
  final int? semanticChildCount;
  /// Jangkar titik awal gulir.
  final double? anchor;
  /// Titik pusat gulir.
  final Key? center;

  /// Mengaktifkan fitur coba lagi walau list dalam keadaan kosong.
  final bool emptyRetryEnabled;
  /// Widget khusus status sedang memuat awal.
  final Widget? loadingView;
  /// Widget khusus daftar kosong.
  final Widget? emptyView;
  /// Widget khusus status batas maksimal.
  final Widget? maxItemView;
  /// Widget khusus ketika error awal.
  final Widget? errorView;
  /// Widget khusus ketika error memuat data ke-n.
  final Widget? errorLoadMoreView;
  /// Mengecilkan loading awal.
  final bool shrinkWrapFirstPageIndicators;
  /// Aksi fungsi tarik untuk menyegarkan daftar (pull-to-refresh).
  final VoidCallback? onRefresh;
  /// Aksi panggilan ulang pengambilan data.
  final VoidCallback onRetry;
  /// Widget kustom untuk gambar keadaan kosong.
  final Widget? emptyImageWidget;
  /// Gambar teks path kosong.
  final String? emptyImage;
  /// Judul pesan kesalahan.
  final String? errorTitle;
  /// Subjudul pesan kesalahan.
  final String? errorSubtitle;
  /// Judul data kosong.
  final String? emptyTitle;
  /// Subjudul data kosong.
  final String? emptySubtitle;
  /// Gaya teks judul data kosong.
  final TextStyle? emptyTitleStyle;
  /// Gaya teks subjudul data kosong.
  final TextStyle? emptySubtitleStyle;
  /// Path gambar ketika kesalahan.
  final String? errorImage;
  /// Widget kustom gambar ketika kesalahan.
  final Widget? errorImageWidget;
  /// Teks tombol ulang.
  final String? retryText;
  /// Jarak spasi diantara teks dan ikon vertikal.
  final double? verticalSpacing;
  /// Jarak spasi diantara teks horizontal.
  final double? horizontalSpacing;
  /// Tinggi aset/ikon.
  final double? imageHeight;
  /// Lebar aset/ikon.
  final double? imageWidth;
  /// Gaya judul error.
  final TextStyle? errorTitleStyle;
  /// Gaya subjudul error.
  final TextStyle? errorSubtitleStyle;
  /// Widget tombol kustom mengulang.
  final Widget? retryWidget;

  @override
  Widget build(BuildContext context) {
    // Memilih tipe gaya rendering berdasarkan platform OS.
    if (Platform.isIOS) {
      return _iosPaginationView();
    } else {
      return _androidPaginationView();
    }
  }

  /// Membangun widget komponen berdasarkan [PaginationType] dan [isSliver].
  Widget _buildChildByType({bool isSliver = false}) {
    // Jika komponen diminta bentuk Sliver (untuk CustomScrollView iOS misalnya)
    if (isSliver) {
      return switch (type) {
        PaginationType.list => _buildPagedSliverList(),
        PaginationType.grid => _buildPagedSliverGrid(),
      };
    } else {
      // Bentuk biasa (Normal ListView / GridView)
      return switch (type) {
        PaginationType.list => _buildPagedList(),
        PaginationType.grid => _buildPagedGrid(),
      };
    }
  }

  /// Membangun view ala Android dengan [RefreshIndicator].
  Widget _androidPaginationView() {
    if (onRefresh != null) {
      // Jika refresh tidak null, bungkus dengan RefreshIndicator bawaan material.
      return RefreshIndicator(
        onRefresh: () => Future.sync(onRefresh!),
        child: _buildChildByType(),
      );
    } else {
      // Tanpa kemampuan pull-to-refresh.
      return _buildChildByType();
    }
  }

  /// Membangun view ala iOS dengan [CupertinoSliverRefreshControl] dan [CustomScrollView].
  Widget _iosPaginationView() {
    // Refresh control pada iOS harus disatukan dengan sliver.
    if (onRefresh != null && scrollDirection == Axis.vertical) {
      return Padding(
        key: key,
        padding: padding ?? EdgeInsets.zero,
        child: CustomScrollView(
          shrinkWrap: shrinkWrap,
          physics: physics,
          scrollDirection: scrollDirection,
          scrollBehavior: scrollBehavior,
          controller: scrollController,
          keyboardDismissBehavior: keyboardDismissBehavior ??
              ScrollViewKeyboardDismissBehavior.manual,
          cacheExtent: cacheExtent,
          clipBehavior: clipBehavior ?? Clip.hardEdge,
          dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
          primary: primary,
          restorationId: restorationId,
          reverse: reverse ?? false,
          semanticChildCount: semanticChildCount,
          anchor: anchor ?? 0.0,
          center: center,
          slivers: [
            // Kontrol tarik-untuk-menyegarkan gaya Cupertino
            CupertinoSliverRefreshControl(
              onRefresh: () => Future.sync(onRefresh!),
            ),
            // Isian data dalam wujud Sliver
            _buildChildByType(isSliver: true),
          ],
        ),
      );
    } else {
      // Tanpa sliver refresh
      return _buildChildByType();
    }
  }

  /// Pembangun normal list
  Widget _buildPagedList() {
    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) => PagedListView.separated(
        key: key,
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: _builderDelete(isSliver: false),
        addAutomaticKeepAlives: addAutomaticKeepAlives ?? true,
        addRepaintBoundaries: addRepaintBoundaries ?? true,
        addSemanticIndexes: addSemanticIndexes ?? true,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        itemExtent: itemExtent,
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        primary: primary,
        restorationId: restorationId,
        reverse: reverse ?? false,
        scrollController: scrollController,
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: scrollDirection,
        padding: padding,
        separatorBuilder: (context, index) {
          return separator ?? const SizedBox.shrink();
        },
      ),
    );
  }

  /// Pembangun sliver list
  Widget _buildPagedSliverList() {
    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) => PagedSliverList(
        key: key,
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: _builderDelete(isSliver: true),
        addAutomaticKeepAlives: addAutomaticKeepAlives ?? true,
        addRepaintBoundaries: addRepaintBoundaries ?? true,
        addSemanticIndexes: addSemanticIndexes ?? true,
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
        semanticIndexCallback: semanticIndexCallback,
        shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      ),
    );
  }

  /// Pembangun normal grid
  Widget _buildPagedGrid() {
    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) => PagedGridView(
        key: key,
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: _builderDelete(isSliver: false),
        gridDelegate: gridDelegate!,
        addAutomaticKeepAlives: addAutomaticKeepAlives ?? true,
        addRepaintBoundaries: addRepaintBoundaries ?? true,
        addSemanticIndexes: addSemanticIndexes ?? true,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        primary: primary,
        restorationId: restorationId,
        reverse: reverse ?? false,
        scrollController: scrollController,
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: scrollDirection,
        padding: padding,
        showNewPageErrorIndicatorAsGridChild:
            showNewPageErrorIndicatorAsGridChild ?? false,
        showNewPageProgressIndicatorAsGridChild:
            showNewPageProgressIndicatorAsGridChild ?? false,
        showNoMoreItemsIndicatorAsGridChild:
            showNoMoreItemsIndicatorAsGridChild ?? false,
      ),
    );
  }

  /// Pembangun sliver grid
  Widget _buildPagedSliverGrid() {
    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) => PagedSliverGrid(
        key: key,
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: _builderDelete(isSliver: true),
        gridDelegate: gridDelegate!,
        addAutomaticKeepAlives: addAutomaticKeepAlives ?? true,
        addRepaintBoundaries: addRepaintBoundaries ?? true,
        addSemanticIndexes: addSemanticIndexes ?? true,
        showNewPageErrorIndicatorAsGridChild:
            showNewPageErrorIndicatorAsGridChild ?? false,
        showNewPageProgressIndicatorAsGridChild:
            showNewPageProgressIndicatorAsGridChild ?? false,
        showNoMoreItemsIndicatorAsGridChild:
            showNoMoreItemsIndicatorAsGridChild ?? false,
        shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      ),
    );
  }

  /// Mengembalikan delegate pembangunan tampilan status (loading, success, dll).
  PagedChildBuilderDelegate<T> _builderDelete({required bool isSliver}) {
    return PaginationDelegate<T>(
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
      separator: isSliver ? separator : null,
    );
  }
}
