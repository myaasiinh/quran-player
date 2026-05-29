import 'package:collection/collection.dart' as c;
import 'package:flutter/material.dart';

/* author
   05/11/2022
   myaasiinh@gmail.com
*/

enum SortBy {
  asc,
  desc,
}

class GroupedListView<T, G> extends StatelessWidget {
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

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final List<T> data;
  final Widget Function(G element) groupHeaderBuilder;
  final Widget Function(BuildContext context, int index, T element) itemBuilder;
  final Widget Function(G element)? groupFooterBuilder;
  final ScrollController? controller;
  final SortBy sortGroupBy;
  final G Function(T element) groupBy;
  final EdgeInsetsGeometry? padding;
  final Widget? separator;
  final Widget? separatorGroup;
  final bool reverse;
  final int Function(T, T)? sortGroupItems;

  @override
  Widget build(BuildContext context) {
    switch (sortGroupBy) {
      case SortBy.asc:
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));
      case SortBy.desc:
        data.sort((b, a) => (groupBy(a) as Comparable).compareTo(groupBy(b)));
    }

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
        if (sortGroupItems != null) {
          groupItems.sort(sortGroupItems);
        }

        return Column(
          children: [
            groupHeaderBuilder(group),
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

class SliverGroupedListView<T, G> extends StatelessWidget {
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

  final List<T> data;
  final Widget Function(G element) groupHeaderBuilder;
  final Widget Function(BuildContext context, int index, T element) itemBuilder;
  final Widget Function(G element)? groupFooterBuilder;
  final SortBy sortGroupBy;
  final G Function(T element) groupBy;
  final Widget? separator;
  final Widget? separatorHeader;
  final NullableIndexedWidgetBuilder? separatorGroupBuilder;
  final int Function(T, T)? sortGroupItems;

  @override
  Widget build(BuildContext context) {
    switch (sortGroupBy) {
      case SortBy.asc:
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));
      case SortBy.desc:
        data.sort((b, a) => (groupBy(a) as Comparable).compareTo(groupBy(b)));
    }

    final groupedData = c.groupBy<T, G>(data.where((_) => true), groupBy);

    final groupList = groupedData.keys.toList();

    return SliverList.separated(
      itemCount: groupList.length,
      separatorBuilder:
          separatorGroupBuilder ?? (context, index) => const SizedBox.shrink(),
      itemBuilder: (context, indexGroup) {
        final group = groupList[indexGroup];
        final groupItems = groupedData.values.toList()[indexGroup];
        if (sortGroupItems != null) {
          groupItems.sort(sortGroupItems);
        }

        return Column(
          children: [
            groupHeaderBuilder(group),
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
            if (groupFooterBuilder != null) groupFooterBuilder!(group),
          ],
        );
      },
    );
  }
}
