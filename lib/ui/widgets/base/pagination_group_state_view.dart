/* Created by
   30/01/2024
   myaasiinh@gmail.com
*/

import 'dart:io';

import '/ui/widgets/base/pagination/custom_paged/paged_grouped_list.dart';
import '/ui/widgets/base/pagination/pagination_delegate.dart';
import '/ui/widgets/grouped_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Enum penentu tipe pagination pengelompokkan list.
enum PaginationGroupType { list, grid }

/// Widget View State untuk pagination dengan data yang terkelompokkan.
///
/// Menyediakan pemisahan per kategori (Group), dukungan sliver, iOS refresh control, dll.
class PaginationGroupStateView<T, G> extends StatelessWidget {
  /// Konstruktor pembangunan view list grup secara vertikal/horizontal.
  const PaginationGroupStateView.list({
    required this.pagingController,
    required this.itemBuilder,
    required this.groupHeaderBuilder,
    required this.groupBy,
    required this.onRetry,
    super.key,
    this.groupFooterBuilder,
    this.separatorHeader,
    this.separatorGroup,
    this.sortGroupBy = SortBy.asc,
    this.loadingView,
    this.emptyView,
    this.maxItemView,
    this.errorView,
    this.errorLoadMoreView,
    this.shrinkWrap = false,
    this.shrinkWrapFirstPageIndicators = false,
    this.physics,
    this.separator,
    this.onRefresh,
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
    this.cacheExtent,
    this.clipBehavior,
    this.dragStartBehavior,
    this.keyboardDismissBehavior,
    this.primary,
    this.reverse,
    this.scrollController,
    this.restorationId,
    this.scrollBehavior,
    this.semanticChildCount,
    this.anchor,
    this.center,
    this.sortGroupItems,
  })  : assert(
          (scrollDirection == Axis.horizontal && onRefresh == null) ||
              scrollDirection == Axis.vertical,
          'onRefresh is not supported for horizontal scrolling',
        ),
        type = PaginationGroupType.list;

  /// Tipe jenis layout untuk list pengelompokkan.
  final PaginationGroupType type;
  /// Kontrol state muatan berhalaman data bertipe [T].
  final PagingController<int, T> pagingController;
  /// Callback desain item per baris.
  final ItemWidgetBuilder<T> itemBuilder;

  /// Pembangun antarmuka tajuk di setiap awalan kategori (Grup).
  final Widget Function(G element) groupHeaderBuilder;
  /// Pembangun antarmuka dasar/footer di akhir setiap kategori.
  final Widget Function(G element)? groupFooterBuilder;
  /// Menentukan properti grup [G] dari item data [T].
  final G Function(T element) groupBy;
  /// Komponen batas untuk bawah tajuk/header.
  final Widget? separatorHeader;
  /// Pemisah khusus untuk antar grup.
  final NullableIndexedWidgetBuilder? separatorGroup;
  /// Urutan pemfilteran/pengurutan grup (contoh: Ascending / Descending).
  final SortBy sortGroupBy;
  /// Panggilan balik penyusunan item kustom di dalam satu grup.
  final int Function(T, T)? sortGroupItems;

  /// Membungkus dimensi list hingga muat ke konten saja.
  final bool shrinkWrap;
  /// Sifat fisika gulir kustom (misal BouncingScrollPhysics).
  final ScrollPhysics? physics;
  /// Pemisah setiap item biasa (bukan header grup).
  final Widget? separator;
  /// Jarak dalam padding untuk container list.
  final EdgeInsetsGeometry? padding;
  /// Sumbu gulir vertikal atau horizontal.
  final Axis scrollDirection;
  /// Panjang maksimal cache viewport offscreen.
  final double? cacheExtent;
  /// Teknik penanganan batas gambar.
  final Clip? clipBehavior;
  /// Penentuan deteksi drag.
  final DragStartBehavior? dragStartBehavior;
  /// Cara menutup keyboard lunak bila list digulirkan.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  /// Status primary controller khusus perutean scroll.
  final bool? primary;
  /// Urutan isi konten terbalik.
  final bool? reverse;
  /// Pihak luar bisa menyambungkan ScrollController.
  final ScrollController? scrollController;
  /// Menyimpan ID unik stat scroll antar perutean ulang.
  final String? restorationId;

  /// Aturan gaya gulir untuk CustomScrollView slivers.
  final ScrollBehavior? scrollBehavior;
  /// Aksesibilitas hitungan anakan konten semantik.
  final int? semanticChildCount;
  /// Nilai proporsi sumbu awal pandangan scroll slivers.
  final double? anchor;
  /// Titik pusat awal list konten silvers.
  final Key? center;

  /// Indikator tombol diizinkan saat data tak berpenghuni.
  final bool emptyRetryEnabled;
  /// Layout loading kustom per page.
  final Widget? loadingView;
  /// Layout keadaan nihil kustom.
  final Widget? emptyView;
  /// Tampilan ketika sampai dasar list muatan penuh.
  final Widget? maxItemView;
  /// Antarmuka ketika pertama memuat namun error.
  final Widget? errorView;
  /// Antarmuka ketika muatan memanggil data ke-n lalu putus.
  final Widget? errorLoadMoreView;
  /// Sembunyikan indikator muat utama hingga perlu.
  final bool shrinkWrapFirstPageIndicators;
  /// Panggilan fungsi pulihkan ulang data dari awal.
  final VoidCallback? onRefresh;
  /// Panggilan pemicu ambil data lagi bila error/ulang.
  final VoidCallback onRetry;
  /// Atribut layout error image yang lengkap kustom widget.
  final Widget? emptyImageWidget;
  /// Nama/path lokasi gambar kosong.
  final String? emptyImage;
  /// Tajuk judul error.
  final String? errorTitle;
  /// Penjelasan rinci error.
  final String? errorSubtitle;
  /// Penamaan tajuk empty state list.
  final String? emptyTitle;
  /// Deskripsi list kosong.
  final String? emptySubtitle;
  /// Warna font, ukuruan, gaya dari [emptyTitle].
  final TextStyle? emptyTitleStyle;
  /// Warna font, ukuruan, gaya dari [emptySubtitle].
  final TextStyle? emptySubtitleStyle;
  /// Path gambar error status.
  final String? errorImage;
  /// Widget utuh kustom untuk image error.
  final Widget? errorImageWidget;
  /// Label panggil aksi ulang.
  final String? retryText;
  /// Pemisah sumbu-y antar tulisan deskripsi.
  final double? verticalSpacing;
  /// Pemisah sumbu-x konten (Jika ada icon bersebelahan).
  final double? horizontalSpacing;
  /// Nilai mutlak ukuran t gambar/icon keterangan state.
  final double? imageHeight;
  /// Nilai mutlak dimensi l gambar state.
  final double? imageWidth;
  /// Rupa tulisan title pada message error.
  final TextStyle? errorTitleStyle;
  /// Rupa tulisan sub-title pada message error.
  final TextStyle? errorSubtitleStyle;
  /// Tombol kustom pengulangan list api.
  final Widget? retryWidget;

  @override
  Widget build(BuildContext context) {
    // Membeda render untuk platform OS spesifik
    if (Platform.isIOS) {
      return _iosPaginationView();
    } else {
      return _androidPaginationView();
    }
  }

  /// Menarik pembuat komponen dasar berdasarkan mode Silver/Tidak.
  Widget _buildChildByType({bool isSliver = false}) {
    if (isSliver) {
      return switch (type) {
        PaginationGroupType.list => _buildPagedSliverGroupedList(),
        PaginationGroupType.grid => _buildPagedSliverGroupedGrid(),
      };
    } else {
      return switch (type) {
        PaginationGroupType.list => _buildPagedGroupedList(),
        PaginationGroupType.grid => _buildPagedGroupedGrid(),
      };
    }
  }

  /// Komposisi standar Android dengan Indikator Refresh Material (Spinner atas list).
  Widget _androidPaginationView() {
    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () => Future.sync(onRefresh!),
        child: _buildChildByType(),
      );
    } else {
      return _buildChildByType();
    }
  }

  /// Komposisi List iOS menggulung dari atas pakai efek karet khusus Cupertino (SliverControl).
  Widget _iosPaginationView() {
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
            // Kontrol khas Apple untuk me-refresh
            CupertinoSliverRefreshControl(
              onRefresh: () => Future.sync(onRefresh!),
            ),
            _buildChildByType(isSliver: true),
          ],
        ),
      );
    } else {
      return _buildChildByType();
    }
  }

  /// Membuat list grup dalam view biasa (non-sliver).
  Widget _buildPagedGroupedList() {
    return PagedGroupedListView<int, T, G>(
      key: key,
      pagingController: pagingController,
      builderDelegate: _builderDelete(isSliver: false),
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      groupFooterBuilder: groupFooterBuilder,
      physics: physics,
      scrollDirection: scrollDirection,
      padding: padding,
      shrinkWrap: shrinkWrap,
      reverse: reverse ?? false,
      separator: separator,
      separatorHeader: separatorHeader,
      controller: scrollController,
      shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      primary: primary,
      restorationId: restorationId,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      cacheExtent: cacheExtent,
      sortGroupBy: sortGroupBy,
      sortGroupItems: sortGroupItems,
      keyboardDismissBehavior:
          keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
      separatorGroup: separatorGroup,
    );
  }

  /// Membuat list grup dalam bentuk sliver list (menghemat daya / scrollview ganda).
  Widget _buildPagedSliverGroupedList() {
    return PagedSliverGroupedListView(
      pagingController: pagingController,
      builderDelegate: _builderDelete(isSliver: true),
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      groupFooterBuilder: groupFooterBuilder,
      shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      separator: separator,
      separatorHeader: separatorHeader,
      sortGroupBy: sortGroupBy,
      sortGroupItems: sortGroupItems,
    );
  }

  /// Konstruktor Paged Grid belum diimplementasikan di kerangka ini.
  Widget _buildPagedGroupedGrid() {
    return const SizedBox.shrink();
  }

  /// Konstruktor Sliver Grid belum diimplementasikan di kerangka ini.
  Widget _buildPagedSliverGroupedGrid() {
    return const SizedBox.shrink();
  }

  /// Membangun pengelola antar muka state pemuatan/kesalahan dari state Pagination Delegate
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
