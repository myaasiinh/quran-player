/* Dibuat oleh
   30/01/2024
   myaasiinh@gmail.com
*/

import '/ui/widgets/grouped_listview.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// Widget [PagedGroupedListView] menampilkan daftar item yang dikelompokkan (grouped)
/// dan mendukung fitur pagination (memuat data per halaman) menggunakan infinite_scroll_pagination.
/// Widget ini menggunakan arsitektur BoxScrollView sehingga bertindak seperti ListView biasa.
class PagedGroupedListView<PageKeyType, T, G> extends BoxScrollView {
  const PagedGroupedListView({
    required this.pagingController,
    required this.groupHeaderBuilder,
    required this.builderDelegate,
    required this.groupBy,
    super.key,
    this.groupFooterBuilder,
    this.shrinkWrapFirstPageIndicators = false,
    this.separator,
    this.separatorHeader,
    this.sortGroupBy = SortBy.asc,
    this.sortGroupItems,
    this.separatorGroup,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.cacheExtent,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  });

  /// Controller yang mengelola state dari pagination.
  final PagingController<PageKeyType, T> pagingController;
  
  /// Delegate untuk membuat widget setiap item dari list.
  final PagedChildBuilderDelegate<T> builderDelegate;
  
  /// Menentukan apakah indikator halaman pertama harus di-shrinkWrap atau tidak.
  final bool shrinkWrapFirstPageIndicators;
  
  /// Fungsi builder untuk membuat widget header dari setiap kelompok (grup).
  final Widget Function(G element) groupHeaderBuilder;
  
  /// Fungsi builder opsional untuk membuat widget footer dari setiap kelompok (grup).
  final Widget Function(G element)? groupFooterBuilder;
  
  /// Fungsi untuk menentukan dasar pengelompokan dari sebuah elemen item.
  final G Function(T element) groupBy;
  
  /// Widget pemisah (separator) antar item dalam satu grup.
  final Widget? separator;
  
  /// Widget pemisah (separator) antara header grup dan item pertamanya.
  final Widget? separatorHeader;
  
  /// Urutan penyortiran grup (asc/desc).
  final SortBy sortGroupBy;
  
  /// Fungsi komparator opsional untuk menyortir item-item di dalam setiap grup.
  final int Function(T, T)? sortGroupItems;
  
  /// Builder opsional untuk membuat widget pemisah antar grup.
  final NullableIndexedWidgetBuilder? separatorGroup;

  @override
  Widget buildChildLayout(BuildContext context) {
    // Membangun sliver layout dari list grup yang dipaginasi
    return PagedSliverGroupedListView(
      pagingController: pagingController,
      builderDelegate: builderDelegate,
      shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      groupFooterBuilder: groupFooterBuilder,
      separator: separator,
      separatorHeader: separatorHeader,
      sortGroupBy: sortGroupBy,
      sortGroupItems: sortGroupItems,
      separatorGroup: separatorGroup,
    );
  }
}

/// Widget [PagedSliverGroupedListView] adalah versi Sliver dari [PagedGroupedListView]
/// yang digunakan untuk menempatkan daftar kelompok berpaginasi di dalam CustomScrollView.
class PagedSliverGroupedListView<PageKeyType, T, G> extends StatelessWidget {
  const PagedSliverGroupedListView({
    required this.pagingController,
    required this.builderDelegate,
    required this.groupBy,
    required this.groupHeaderBuilder,
    super.key,
    this.shrinkWrapFirstPageIndicators = false,
    this.separator = const SizedBox.shrink(),
    this.groupFooterBuilder,
    this.separatorHeader,
    this.sortGroupBy = SortBy.asc,
    this.sortGroupItems,
    this.separatorGroup,
  });

  /// Controller yang mengelola state dari pagination.
  final PagingController<PageKeyType, T> pagingController;
  
  /// Delegate untuk membuat widget setiap item dari list.
  final PagedChildBuilderDelegate<T> builderDelegate;
  
  /// Menentukan apakah indikator halaman pertama harus di-shrinkWrap atau tidak.
  final bool shrinkWrapFirstPageIndicators;
  
  /// Fungsi builder untuk membuat widget header dari setiap kelompok (grup).
  final Widget Function(G element) groupHeaderBuilder;
  
  /// Fungsi builder opsional untuk membuat widget footer dari setiap kelompok (grup).
  final Widget Function(G element)? groupFooterBuilder;
  
  /// Fungsi untuk menentukan dasar pengelompokan dari sebuah elemen item.
  final G Function(T element) groupBy;
  
  /// Widget pemisah (separator) antar item dalam satu grup.
  final Widget? separator;
  
  /// Widget pemisah (separator) antara header grup dan item pertamanya.
  final Widget? separatorHeader;
  
  /// Builder opsional untuk membuat widget pemisah antar grup.
  final NullableIndexedWidgetBuilder? separatorGroup;
  
  /// Urutan penyortiran grup (asc/desc).
  final SortBy sortGroupBy;
  
  /// Fungsi komparator opsional untuk menyortir item-item di dalam setiap grup.
  final int Function(T, T)? sortGroupItems;

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        
        // Fungsi helper untuk membangun layout MultiSliver yang berisi daftar grup dan indikator status
        Widget buildLayout(
          IndexedWidgetBuilder itemBuilder,
          int itemCount, {
          WidgetBuilder? statusIndicatorBuilder,
        }) =>
            MultiSliver(
              children: [
                SliverGroupedListView<T, G>(
                  data: state.items ?? [],
                  groupBy: groupBy,
                  itemBuilder: (context, index, item) =>
                      itemBuilder(context, index),
                  groupHeaderBuilder: groupHeaderBuilder,
                  separatorGroupBuilder: separatorGroup,
                  groupFooterBuilder: groupFooterBuilder,
                  separatorHeader: separatorHeader,
                  separator: separator,
                  sortGroupBy: sortGroupBy,
                  sortGroupItems: sortGroupItems,
                ),
                if (statusIndicatorBuilder != null)
                  SliverToBoxAdapter(child: statusIndicatorBuilder(context)),
              ],
            );

        return PagedLayoutBuilder<PageKeyType, T>(
          layoutProtocol: PagedLayoutProtocol.sliver,
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: builderDelegate,
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          
          // Layout ketika daftar telah selesai dimuat seluruhnya
          completedListingBuilder: (
            context,
            itemBuilder,
            itemCount,
            noMoreItemsIndicatorBuilder,
          ) =>
              buildLayout(
            itemBuilder,
            itemCount,
            statusIndicatorBuilder: noMoreItemsIndicatorBuilder,
          ),
          
          // Layout ketika sedang memuat daftar baru
          loadingListingBuilder:
              (context, itemBuilder, itemCount, progressIndicatorBuilder) =>
                  buildLayout(
            itemBuilder,
            itemCount,
            statusIndicatorBuilder: progressIndicatorBuilder,
          ),
          
          // Layout ketika terjadi error saat memuat daftar
          errorListingBuilder:
              (context, itemBuilder, itemCount, errorIndicatorBuilder) =>
                  buildLayout(
            itemBuilder,
            itemCount,
            statusIndicatorBuilder: errorIndicatorBuilder,
          ),
        );
      },
    );
  }
}
