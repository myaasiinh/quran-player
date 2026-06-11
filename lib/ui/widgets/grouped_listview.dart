import 'package:collection/collection.dart' as c;
import 'package:flutter/material.dart';

/* author
   05/11/2022
   myaasiinh@gmail.com
*/

/// Enumerasi [SortBy] menentukan urutan pengelompokan elemen.
enum SortBy {
  /// Mengurutkan elemen dari nilai yang terkecil ke terbesar (Ascending).
  asc,

  /// Mengurutkan elemen dari nilai yang terbesar ke terkecil (Descending).
  desc,
}

/// Widget [GroupedListView] adalah ListView kustom yang mampu menampilkan data
/// yang telah dikelompokkan berdasarkan parameter pengelompokan tertentu.
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

  /// Mengatur perilaku fisika scroll dari daftar list.
  final ScrollPhysics? physics;

  /// Menentukan apakah ekstensi daftar harus menyusut sesuai dengan ukuran kontennya.
  final bool shrinkWrap;

  /// Daftar data sumber (raw data) yang akan diproses dan dikelompokkan.
  final List<T> data;

  /// Fungsi builder untuk merender antarmuka (UI) header dari setiap grup.
  final Widget Function(G element) groupHeaderBuilder;

  /// Fungsi builder untuk merender antarmuka (UI) item tunggal di dalam sebuah grup.
  final Widget Function(BuildContext context, int index, T element) itemBuilder;

  /// Fungsi builder opsional untuk merender antarmuka (UI) footer dari setiap grup.
  final Widget Function(G element)? groupFooterBuilder;

  /// Mengatur controller scroll yang memantau pergerakan daftar list.
  final ScrollController? controller;

  /// Menentukan jenis pengurutan (ascending/descending) untuk daftar grup.
  final SortBy sortGroupBy;

  /// Fungsi callback untuk menentukan parameter atau kriteria pengelompokan dari sebuah elemen.
  final G Function(T element) groupBy;

  /// Nilai jarak (padding) atau ruang kosong di area luar daftar.
  final EdgeInsetsGeometry? padding;

  /// Widget yang bertindak sebagai pemisah antar item-item di dalam sebuah grup yang sama.
  final Widget? separator;

  /// Widget yang bertindak sebagai pemisah antar grup yang satu dengan grup lainnya.
  final Widget? separatorGroup;

  /// Menentukan apakah urutan daftar harus dibalik (ditampilkan dari bawah ke atas).
  final bool reverse;

  /// Fungsi komparator opsional untuk mengurutkan item-item spesifik di dalam setiap grup.
  final int Function(T, T)? sortGroupItems;

  /// Metode [build] untuk membentuk struktur antarmuka widget [GroupedListView].
  @override
  Widget build(BuildContext context) {
    // Memeriksa jenis pengurutan grup yang diminta dan menerapkannya pada data dasar.
    switch (sortGroupBy) {
      // Jika mode Ascending
      case SortBy.asc:
        // Mengurutkan data menggunakan Comparable dari kecil ke besar berdasarkan hasil fungsi groupBy
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));
      // Jika mode Descending
      case SortBy.desc:
        // Mengurutkan data menggunakan Comparable dari besar ke kecil berdasarkan hasil fungsi groupBy
        data.sort((b, a) => (groupBy(a) as Comparable).compareTo(groupBy(b)));
    }

    // Mengelompokkan data berdasarkan hasil fungsi [groupBy].
    // Fungsi groupBy dari package collection digunakan untuk membentuk Map<G, List<T>>.
    final groupedData = c.groupBy<T, G>(data.where((_) => true), groupBy);
    
    // Mengambil daftar semua kunci/nama grup.
    final groupList = groupedData.keys.toList();

    // Mengembalikan widget ListView yang telah mendukung pemisah elemen (separated)
    return ListView.separated(
      // Mengatur ukuran ListView menyesuaikan konten
      shrinkWrap: shrinkWrap,
      // Mengatur efek animasi scroll
      physics: physics,
      // Memberikan jarak bantalan (padding)
      padding: padding ?? EdgeInsets.zero,
      // Menentukan total jumlah grup yang ada
      itemCount: groupList.length,
      // Memasang scroll controller
      controller: controller,
      // Menentukan urutan rendering (dibalik atau tidak)
      reverse: reverse,
      // Fungsi pembangun isi list untuk setiap grup
      itemBuilder: (_, indexGroup) {
        // Mengambil kunci identitas grup untuk indeks ini
        final group = groupList[indexGroup];
        // Mengambil seluruh item/elemen yang tergabung dalam grup ini
        final groupItems = groupedData.values.toList()[indexGroup];
        
        // Memeriksa apakah ada fungsi komparator pengurutan item tingkat grup.
        if (sortGroupItems != null) {
          // Melakukan pengurutan internal item-item dalam grup.
          groupItems.sort(sortGroupItems);
        }

        // Menyusun isi dari suatu grup secara vertikal
        return Column(
          children: [
            // Memanggil fungsi perender header grup
            groupHeaderBuilder(group),
            // Membuat ListView di dalam grup untuk merender item-item grup
            ListView.separated(
              // Menentukan jumlah item di dalam grup
              itemCount: groupItems.length,
              // Menghilangkan jarak bantalan agar tidak ada spasi ekstra
              padding: EdgeInsets.zero,
              // Memaksa daftar menyusut sesuai isinya
              shrinkWrap: true,
              // Mematikan scroll internal karena sudah di-scroll oleh list parent
              physics: const NeverScrollableScrollPhysics(),
              // Fungsi pembangun item individual dalam grup
              itemBuilder: (context, index) {
                // Mencari indeks aktual dari item ini di daftar asli
                final originalIndex = data.indexOf(groupItems[index]);
                // Memanggil perender antarmuka item spesifik
                return itemBuilder(context, originalIndex, groupItems[index]);
              },
              // Fungsi pembangun garis pemisah antar item di grup
              separatorBuilder: (context, index) {
                // Menampilkan widget pemisah atau kotak kosong tak terlihat
                return separator ?? const SizedBox.shrink();
              },
            ),
            // Memeriksa apakah terdapat perender footer grup
            // Jika ada, render footer grup setelah semua item grup dimuat
            if (groupFooterBuilder != null) groupFooterBuilder!(group),
          ],
        );
      },
      // Fungsi pembangun pemisah antar grup utama
      separatorBuilder: (context, index) {
        // Menampilkan widget pemisah grup atau kotak kosong tak terlihat
        return separatorGroup ?? const SizedBox.shrink();
      },
    );
  }
}

/// Widget [SliverGroupedListView] adalah SliverList kustom yang menampilkan data 
/// yang telah dikelompokkan, dioptimalkan untuk digunakan di dalam [CustomScrollView].
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

  /// Fungsi builder untuk merender header dari setiap grup.
  final Widget Function(G element) groupHeaderBuilder;

  /// Fungsi builder untuk merender item individual di dalam sebuah grup.
  final Widget Function(BuildContext context, int index, T element) itemBuilder;

  /// Fungsi builder opsional untuk merender footer dari setiap grup.
  final Widget Function(G element)? groupFooterBuilder;

  /// Menentukan jenis pengurutan grup.
  final SortBy sortGroupBy;

  /// Fungsi callback untuk menentukan parameter atau kriteria pengelompokan.
  final G Function(T element) groupBy;

  /// Widget yang bertindak sebagai pemisah antar item di dalam sebuah grup.
  final Widget? separator;

  /// Widget pemisah antara header dan item pertama di dalam grup (saat ini belum diimplementasikan di build).
  final Widget? separatorHeader;

  /// Fungsi builder untuk merender widget pemisah antar grup.
  final NullableIndexedWidgetBuilder? separatorGroupBuilder;

  /// Fungsi komparator opsional untuk mengurutkan item-item spesifik di dalam setiap grup.
  final int Function(T, T)? sortGroupItems;

  /// Metode [build] untuk membentuk struktur Sliver dari widget [SliverGroupedListView].
  @override
  Widget build(BuildContext context) {
    // Memeriksa jenis pengurutan grup yang diminta dan menerapkannya pada data dasar.
    switch (sortGroupBy) {
      // Jika mode Ascending
      case SortBy.asc:
        // Mengurutkan data menggunakan Comparable dari kecil ke besar
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));
      // Jika mode Descending
      case SortBy.desc:
        // Mengurutkan data menggunakan Comparable dari besar ke kecil
        data.sort((b, a) => (groupBy(a) as Comparable).compareTo(groupBy(b)));
    }

    // Mengelompokkan data ke dalam struktur Map<G, List<T>>
    final groupedData = c.groupBy<T, G>(data.where((_) => true), groupBy);
    
    // Mengambil daftar urutan kunci identitas grup
    final groupList = groupedData.keys.toList();

    // Mengembalikan SliverList yang mendukung rendering terpisah (separated)
    return SliverList.separated(
      // Menentukan jumlah grup yang tersedia
      itemCount: groupList.length,
      // Fungsi pemisah antar grup di tingkat sliver
      separatorBuilder:
          // Menjalankan pembangun jika ada, jika tidak, render kotak kosong
          separatorGroupBuilder ?? (context, index) => const SizedBox.shrink(),
      // Fungsi pembangun struktur setiap grup
      itemBuilder: (context, indexGroup) {
        // Mengambil referensi dari grup spesifik berdasarkan indeks
        final group = groupList[indexGroup];
        // Mengambil anggota-anggota elemen untuk grup ini
        final groupItems = groupedData.values.toList()[indexGroup];
        
        // Memeriksa apakah ada konfigurasi pengurutan item tingkat grup
        if (sortGroupItems != null) {
          // Menerapkan pengurutan pada item dalam grup
          groupItems.sort(sortGroupItems);
        }

        // Menyusun elemen grup secara vertikal
        return Column(
          children: [
            // Memanggil builder untuk header grup
            groupHeaderBuilder(group),
            // Menggambar elemen-elemen di dalam grup
            ListView.separated(
              // Menentukan banyaknya item di dalam grup
              itemCount: groupItems.length,
              // Menghapus bantalan ekstra
              padding: EdgeInsets.zero,
              // Mengecilkan daftar agar tidak mengambil semua area
              shrinkWrap: true,
              // Meniadakan fungsi scroll individual agar ditarik oleh CustomScrollView
              physics: const NeverScrollableScrollPhysics(),
              // Fungsi pembangun item spesifik
              itemBuilder: (context, index) {
                // Mencari letak indeks dari elemen yang sebenarnya di daftar keseluruhan
                final originalIndex = data.indexOf(groupItems[index]);
                // Merender elemen individu
                return itemBuilder(context, originalIndex, groupItems[index]);
              },
              // Fungsi pemisah item internal di suatu grup
              separatorBuilder: (context, index) {
                // Menampilkan pemisah spesifik atau merender kotak kosong
                return separator ?? const SizedBox.shrink();
              },
            ),
            // Merender footer grup bila konfigurasinya diberikan
            if (groupFooterBuilder != null) groupFooterBuilder!(group),
          ],
        );
      },
    );
  }
}
