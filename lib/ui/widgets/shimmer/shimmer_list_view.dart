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
  /// mirip dengan penggunaan pada [ListView.separated].
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
  /// mirip dengan penggunaan pada [ListView.builder].
  const ShimmerListView.builder({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.physics,
    this.padding,
    this.scrollDirection,
  })  : separatorBuilder = null,
        children = null;

  /// Jumlah keseluruhan item yang akan ditampilkan di dalam list 
  /// (hanya relevan untuk konstruktor [separated] dan [builder]).
  final int? itemCount;
  
  /// Fungsi pembangun widget (builder) untuk tiap item data di dalam daftar 
  /// (hanya relevan untuk [separated] dan [builder]).
  final IndexedWidgetBuilder? itemBuilder;
  
  /// Fungsi pembangun widget pemisah (separator) yang muncul di antara item 
  /// (hanya relevan untuk [separated]).
  final IndexedWidgetBuilder? separatorBuilder;
  
  /// Daftar widget item secara statis, ditentukan secara manual
  /// (hanya relevan untuk konstruktor standar bawaan).
  final List<Widget>? children;
  
  /// Perilaku guliran (scroll physics) dari daftar ketika ditarik oleh pengguna.
  final ScrollPhysics? physics;
  
  /// Jarak dalam (padding) di sekeliling area scroll view.
  final EdgeInsetsGeometry? padding;
  
  /// Arah guliran dari daftar (secara bawaan adalah sumbu vertikal).
  final Axis? scrollDirection;

  /// Membangun dan mengembalikan struktur antarmuka pengguna (UI).
  @override
  Widget build(BuildContext context) {
    // Mengecek apakah terdapat daftar children yang didefinisikan secara statis
    if (children != null) {
      // Jika children tersedia, tampilkan sebagai Column di dalam SingleChildScrollView
      return SingleChildScrollView(
        // Menetapkan jarak padding sesuai parameter
        padding: padding,
        // Menetapkan gaya gesekan/fisika gulir sesuai parameter
        physics: physics,
        // Menetapkan arah guliran, jika null gunakan guliran vertikal
        scrollDirection: scrollDirection ?? Axis.vertical,
        // Wadah utama yang menampung anak-anak ke bawah
        child: Column(
          // Memasukkan array children ke dalam column
          children: children!,
        ),
      );
    } 
    // Jika daftar anak tidak ada, namun terdapat fungsi pembuat pemisah (separator)
    else if (separatorBuilder != null) {
      // Tampilkan list dinamis di dalam SingleChildScrollView
      return SingleChildScrollView(
        // Menetapkan jarak padding sesuai parameter
        padding: padding,
        // Menetapkan gaya fisika gulir
        physics: physics,
        // Menetapkan arah guliran, secara bawaan vertikal
        scrollDirection: scrollDirection ?? Axis.vertical,
        // Membungkus list yang dibuat secara dinamis dengan struktur kolom
        child: Column(
          // Menghasilkan daftar elemen secara terprogram dengan jumlah item + pemisah
          children: List.generate(
            // Jumlah indeks dikalikan 2 karena adanya pemisah di sela-sela item
            itemCount! * 2,
            // Fungsi penentu widget mana yang dimuat berdasarkan posisi ganjil/genap
            (index) => index.isOdd
                // Jika posisi ganjil, kembalikan widget pemisah
                ? separatorBuilder!(context, (index - 1) ~/ 2)
                // Jika genap, kembalikan widget item utamanya
                : itemBuilder!(context, index ~/ 2),
          ),
        ),
      );
    } 
    // Apabila hanya ada pembuat item biasa (builder) tanpa pemisah
    else {
      // Tampilkan SingleChildScrollView standar
      return SingleChildScrollView(
        // Mengaplikasikan margin internal/padding
        padding: padding,
        // Mengaplikasikan sifat guliran
        physics: physics,
        // Mengaplikasikan orientasi arah guliran
        scrollDirection: scrollDirection ?? Axis.vertical,
        // Membungkus list dalam satu alur kolom memanjang
        child: Column(
          // Membuat susunan widget sebanyak `itemCount`
          children: List.generate(
            // Menentukan total perulangan
            itemCount!,
            // Menghasilkan satu widget item pada setiap urutan loop
            (index) => itemBuilder!(context, index),
          ),
        ),
      );
    }
  }
}
