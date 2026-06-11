import 'package:flutter/material.dart';

/// Widget [ShimmerListView] digunakan untuk merender daftar item (list) yang menampilkan
/// efek loading (shimmer). Ini berguna untuk membuat rangka loading (skeleton) yang bentuknya berupa list.
class ShimmerListView extends StatelessWidget {
  /// Konstruktor standar untuk membuat list statis menggunakan daftar [children].
  const ShimmerListView({
    required this.children,
    super.key,
    this.physics,
    this.padding,
    this.scrollDirection,
  })  : itemBuilder = null,
        itemCount = null,
        separatorBuilder = null;

  /// Konstruktor untuk membuat list dengan item dan separator (pemisah) secara dinamis,
  /// mirip dengan [ListView.separated].
  const ShimmerListView.separated({
    required this.itemCount,
    required this.separatorBuilder,
    required this.itemBuilder,
    super.key,
    this.physics,
    this.padding,
    this.scrollDirection,
  }) : children = null;

  /// Konstruktor untuk membuat list dengan item yang digenerate secara dinamis tanpa pemisah,
  /// mirip dengan [ListView.builder].
  const ShimmerListView.builder({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.physics,
    this.padding,
    this.scrollDirection,
  })  : separatorBuilder = null,
        children = null;

  /// Jumlah item yang akan ditampilkan (hanya untuk [separated] dan [builder]).
  final int? itemCount;
  
  /// Fungsi pembangun widget untuk tiap item (hanya untuk [separated] dan [builder]).
  final IndexedWidgetBuilder? itemBuilder;
  
  /// Fungsi pembangun widget pemisah (separator) antar item (hanya untuk [separated]).
  final IndexedWidgetBuilder? separatorBuilder;
  
  /// Daftar widget item secara statis (hanya untuk konstruktor bawaan).
  final List<Widget>? children;
  
  /// Perilaku scroll (scroll physics) dari daftar.
  final ScrollPhysics? physics;
  
  /// Jarak dalam (padding) dari scroll view.
  final EdgeInsetsGeometry? padding;
  
  /// Arah scroll dari daftar (default adalah vertikal).
  final Axis? scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (children != null) {
      // Jika children tersedia, tampilkan sebagai Column yang dapat di-scroll
      return SingleChildScrollView(
        padding: padding,
        physics: physics,
        scrollDirection: scrollDirection ?? Axis.vertical,
        child: Column(
          children: children!,
        ),
      );
    } else if (separatorBuilder != null) {
      // Jika separatorBuilder tersedia, padukan itemBuilder dan separatorBuilder
      return SingleChildScrollView(
        padding: padding,
        physics: physics,
        scrollDirection: scrollDirection ?? Axis.vertical,
        child: Column(
          children: List.generate(
            itemCount! * 2,
            (index) => index.isOdd
                ? separatorBuilder!(context, (index - 1) ~/ 2)
                : itemBuilder!(context, index ~/ 2),
          ),
        ),
      );
    } else {
      // Jika hanya builder saja
      return SingleChildScrollView(
        padding: padding,
        physics: physics,
        scrollDirection: scrollDirection ?? Axis.vertical,
        child: Column(
          children: List.generate(
            itemCount!,
            (index) => itemBuilder!(context, index),
          ),
        ),
      );
    }
  }
}
