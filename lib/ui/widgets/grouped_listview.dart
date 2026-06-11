import 'package:collection/collection.dart' as c;
import 'package:flutter/material.dart';

/* author
   05/11/2022
   myaasiinh@gmail.com
*/

/// Enumerasi yang menentukan urutan pengelompokan.
enum SortBy {
  /// Mengurutkan dari yang terkecil ke terbesar.
  asc,

  /// Mengurutkan dari yang terbesar ke terkecil.
  desc,
}

/// Widget [ListView] kustom yang menampilkan data yang telah dikelompokkan
/// berdasarkan parameter pengelompokan tertentu.
class GroupedListView<T, G> extends StatelessWidget {
  /// Konstruktor untuk membuat widget [GroupedListView].
  const GroupedListView({
    required this.data,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    super.key,
    this.controller,
    this.sortGroupBy = SortBy.asc,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.separator,
    this.groupFooterBuilder,
    this.separatorGroup,
    this.reverse = false,
    this.sortGroupItems,
  });

  /// Mengatur fisika scroll dari daftar.
  final ScrollPhysics? physics;

  /// Menentukan apakah ekstensi daftar harus diatur sesuai kontennya.
  final bool shrinkWrap;

  /// Daftar data sumber yang akan dikelompokkan.
  final List<T> data;

  /// Builder untuk merender header dari setiap grup.
  final Widget Function(G element) groupHeaderBuilder;

  /// Builder untuk merender item di dalam sebuah grup.
  final Widget Function(BuildContext context, int index, T element) itemBuilder;

  /// Builder opsional untuk merender footer dari setiap grup.
  final Widget Function(G element)? groupFooterBuilder;

  /// Mengatur scroll controller untuk daftar.
  final ScrollController? controller;

  /// Menentukan jenis pengurutan untuk grup.
  final SortBy sortGroupBy;

  /// Fungsi untuk menentukan parameter pengelompokan.
  final G Function(T element) groupBy;

  /// Jarak / ruang kosong di dalam daftar.
  final EdgeInsetsGeometry? padding;

  /// Widget pemisah antar item di dalam sebuah grup.
  final Widget? separator;

  /// Widget pemisah antar grup.
  final Widget? separatorGroup;

  /// Menentukan apakah daftar harus digulirkan secara terbalik.
  final bool reverse;

  /// Fungsi opsional untuk mengurutkan item-item yang ada di dalam setiap grup.
  final int Function(T, T)? sortGroupItems;

  @override
  Widget build(BuildContext context) {
    // Melakukan pengurutan grup berdasarkan parameter yang dipilih.
    switch (sortGroupBy) {
      case SortBy.asc:
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));
      case SortBy.desc:
        data.sort((b, a) => (groupBy(a) as Comparable).compareTo(groupBy(b)));
    }

    // Mengelompokkan data.
    final groupedData = c.groupBy<T, G>(data.where((_) => true), groupBy);
    final groupList = groupedData.keys.toList();

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? EdgeInsets.zero,
      itemCount: groupList.length,
      controller: controller,
      reverse: reverse,
      itemBuilder: (_, indexGroup) {
        final group = groupList[indexGroup];
        final groupItems = groupedData.values.toList()[indexGroup];
        
        // Mengurutkan item di dalam grup jika fungsi pengurutan diberikan.
        if (sortGroupItems != null) {
          groupItems.sort(sortGroupItems);
        }

        return Column(
          children: [
            // Merender header grup.
            groupHeaderBuilder(group),
            // Merender item-item di dalam grup.
            ListView.separated(
              itemCount: groupItems.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final originalIndex = data.indexOf(groupItems[index]);
                return itemBuilder(context, originalIndex, groupItems[index]);
              },
              separatorBuilder: (context, index) {
                return separator ?? const SizedBox.shrink();
              },
            ),
            // Merender footer grup.
            if (groupFooterBuilder != null) groupFooterBuilder!(group),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return separatorGroup ?? const SizedBox.shrink();
      },
    );
  }
}

/// Widget [SliverList] kustom yang menampilkan data yang telah dikelompokkan
/// untuk digunakan di dalam [CustomScrollView].
class SliverGroupedListView<T, G> extends StatelessWidget {
  /// Konstruktor untuk membuat widget [SliverGroupedListView].
  const SliverGroupedListView({
    required this.data,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    required this.separatorGroupBuilder,
    super.key,
    this.sortGroupBy = SortBy.asc,
    this.separator,
    this.separatorHeader,
    this.groupFooterBuilder,
    this.sortGroupItems,
  });

  /// Daftar data sumber yang akan dikelompokkan.
  final List<T> data;

  /// Builder untuk merender header dari setiap grup.
  final Widget Function(G element) groupHeaderBuilder;

  /// Builder untuk merender item di dalam sebuah grup.
  final Widget Function(BuildContext context, int index, T element) itemBuilder;

  /// Builder opsional untuk merender footer dari setiap grup.
  final Widget Function(G element)? groupFooterBuilder;

  /// Menentukan jenis pengurutan untuk grup.
  final SortBy sortGroupBy;

  /// Fungsi untuk menentukan parameter pengelompokan.
  final G Function(T element) groupBy;

  /// Widget pemisah antar item di dalam sebuah grup.
  final Widget? separator;

  /// Widget pemisah antara header dan item pertama di dalam grup (saat ini belum digunakan pada build).
  final Widget? separatorHeader;

  /// Builder untuk widget pemisah antar grup.
  final NullableIndexedWidgetBuilder? separatorGroupBuilder;

  /// Fungsi opsional untuk mengurutkan item-item yang ada di dalam setiap grup.
  final int Function(T, T)? sortGroupItems;

  @override
  Widget build(BuildContext context) {
    // Melakukan pengurutan grup berdasarkan parameter yang dipilih.
    switch (sortGroupBy) {
      case SortBy.asc:
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));
      case SortBy.desc:
        data.sort((b, a) => (groupBy(a) as Comparable).compareTo(groupBy(b)));
    }

    // Mengelompokkan data.
    final groupedData = c.groupBy<T, G>(data.where((_) => true), groupBy);
    final groupList = groupedData.keys.toList();

    return SliverList.separated(
      itemCount: groupList.length,
      separatorBuilder:
          separatorGroupBuilder ?? (context, index) => const SizedBox.shrink(),
      itemBuilder: (context, indexGroup) {
        final group = groupList[indexGroup];
        final groupItems = groupedData.values.toList()[indexGroup];
        
        // Mengurutkan item di dalam grup jika fungsi pengurutan diberikan.
        if (sortGroupItems != null) {
          groupItems.sort(sortGroupItems);
        }

        return Column(
          children: [
            // Merender header grup.
            groupHeaderBuilder(group),
            // Merender item-item di dalam grup.
            ListView.separated(
              itemCount: groupItems.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final originalIndex = data.indexOf(groupItems[index]);
                return itemBuilder(context, originalIndex, groupItems[index]);
              },
              separatorBuilder: (context, index) {
                return separator ?? const SizedBox.shrink();
              },
            ),
            // Merender footer grup.
            if (groupFooterBuilder != null) groupFooterBuilder!(group),
          ],
        );
      },
    );
  }
}
