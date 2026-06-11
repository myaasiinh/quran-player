/* Dibuat oleh
   30/01/2024
   myaasiinh@gmail.com
*/

import '/ui/widgets/grouped_listview.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// Widget [PagedGroupedListView] bertugas menampilkan daftar item yang dikelompokkan (grouped)
/// dan mendukung fitur pagination (memuat data per halaman) menggunakan pustaka infinite_scroll_pagination.
/// Principal Note: Widget ini dibentuk menggunakan arsitektur bawaan BoxScrollView sehingga bertindak
/// seperti ListView biasa pada umumnya (bisa men-scroll secara vertikal maupun horizontal).
class PagedGroupedListView<PageKeyType, T, G> extends BoxScrollView {
  /// Konstruktor widget [PagedGroupedListView].
  /// Mensyaratkan beberapa parameter inti seperti [pagingController], [groupHeaderBuilder],
  /// [builderDelegate], dan [groupBy] agar data dapat dibentuk secara dinamis.
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

  /// Controller logika yang difungsikan untuk mengelola state dari proses pemuatan data berpaginasi.
  final PagingController<PageKeyType, T> pagingController;
  
  /// Delegasi perenderan yang bertanggung jawab membuat widget visual untuk setiap baris item dari list (di dalam kelompok).
  final PagedChildBuilderDelegate<T> builderDelegate;
  
  /// Menentukan preferensi apakah indikator loading pada muatan halaman pertama harus dibungkus (shrinkWrap) secukupnya atau memenuhi parent.
  final bool shrinkWrapFirstPageIndicators;
  
  /// Fungsi builder callback yang merender rancangan UI widget header penanda/label dari setiap kelompok (grup) utama.
  final Widget Function(G element) groupHeaderBuilder;
  
  /// Fungsi builder callback opsional untuk menampilkan rancangan UI widget footer dari setiap kelompok yang ada.
  final Widget Function(G element)? groupFooterBuilder;
  
  /// Fungsi referensi logika penentu dasar dari parameter nilai variabel pengelompokan sebuah entitas item.
  final G Function(T element) groupBy;
  
  /// Widget penyekat atau pemisah jarak visual (separator) antar tiap komponen item di dalam rentang suatu grup.
  final Widget? separator;
  
  /// Widget pemisah antara header (judul) suatu grup dengan susunan item pertama di bawahnya.
  final Widget? separatorHeader;
  
  /// Preferensi pengurutan (penyortiran) letak urutan dari grup. Default adalah urut menaik/ascending (SortBy.asc).
  final SortBy sortGroupBy;
  
  /// Fungsi utilitas komparator opsional yang jika di-supply, bakal menyortir urutan letak item-item persis di dalam setiap area grup.
  final int Function(T, T)? sortGroupItems;
  
  /// Builder opsional untuk membentuk UI widget pemisah jarak antara sebuah area grup yang utuh dengan grup lainnya.
  final NullableIndexedWidgetBuilder? separatorGroup;

  /// Override metode base framework yang tugas utamanya menterjemahkan pengaturan konstruktor ini ke dalam hierarki sliver sebenarnya.
  @override
  Widget buildChildLayout(BuildContext context) {
    // Membangun sliver layout dari list grup yang dikelola di bawah naungan arsitektur pagination Sliver terpisah
    return PagedSliverGroupedListView(
      pagingController: pagingController, // Melemparkan kontroler pagination ke versi sliver
      builderDelegate: builderDelegate, // Melemparkan delegasi builder tiap daftar elemen item
      shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
      groupBy: groupBy, // Metode partisi grup
      groupHeaderBuilder: groupHeaderBuilder,
      groupFooterBuilder: groupFooterBuilder,
      separator: separator,
      separatorHeader: separatorHeader,
      sortGroupBy: sortGroupBy, // Metode pengurutan kelompok
      sortGroupItems: sortGroupItems, // Metode penyortiran isi masing-masing grup
      separatorGroup: separatorGroup,
    );
  }
}

/// Widget abstrak [PagedSliverGroupedListView] ini merupakan versi kompatibilitas Sliver asli dari [PagedGroupedListView]
/// yang secara mandiri harus dipakai bilamana pengguna ingin menempatkan daftar elemen berpaginasi ke tengah bagian dalam sebuah komponen CustomScrollView atau NestedScrollView.
class PagedSliverGroupedListView<PageKeyType, T, G> extends StatelessWidget {
  /// Konstruktor widget fungsional [PagedSliverGroupedListView].
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

  /// Logika kontrol status pemuatan data antar halaman.
  final PagingController<PageKeyType, T> pagingController;
  
  /// Utilitas perender item berulang (looper).
  final PagedChildBuilderDelegate<T> builderDelegate;
  
  /// Keputusan konfigurasi shrink view khusus loading halaman pertama.
  final bool shrinkWrapFirstPageIndicators;
  
  /// Builder pembuat kepala titel dari setiap klaster elemen.
  final Widget Function(G element) groupHeaderBuilder;
  
  /// Builder opsional ekor footer di tiap grup klaster.
  final Widget Function(G element)? groupFooterBuilder;
  
  /// Ekstraktor logika string partisi group berdasarkan kriteria referensi item objectnya.
  final G Function(T element) groupBy;
  
  /// Elemen widget celah partisi pembatas antar elemen individu per blok.
  final Widget? separator;
  
  /// Elemen pembatas spasi setelah merender header.
  final Widget? separatorHeader;
  
  /// Pembentuk celah partisi dinamis terindex diantara dua kelompok grup blok berbeda.
  final NullableIndexedWidgetBuilder? separatorGroup;
  
  /// Sifat metode penyortiran (menaik/menurun).
  final SortBy sortGroupBy;
  
  /// Variabel pendelegasian komparasi angka referensi tata urut (sorting inner items)
  final int Function(T, T)? sortGroupItems;

  /// Override yang berfungsi mengecat serta menerjemahkan state di pagination controller menjadi list sliver seutuhnya.
  @override
  Widget build(BuildContext context) {
    // Memakai listener pengintai status koneksi per load next page dari Infinite Pagination
    return PagingListener(
      controller: pagingController, // Target pantau adalah kontroler pagination dari kelas constructor.
      // Merakit pembaruan state re-render berkala setiap kali aksi pagination dipicu atau mengubah parameter halamannya
      builder: (context, state, fetchNextPage) {
        
        // Fungsi helper terisolasi (private lokal) guna menyusun tata letak baris antrian MultiSliver. 
        // Menggabungkan sliver kumpulan grup list beserta komponen indikator status loading / error nya.
        Widget buildLayout(
          IndexedWidgetBuilder itemBuilder,
          int itemCount, {
          WidgetBuilder? statusIndicatorBuilder, // Builder status loader atau placeholder not found error.
        }) =>
            // Komponen package pembantu sliver (MultiSliver) mengelompokkan beberapa sliver berdampingan
            MultiSliver(
              children: [
                // Komponen utamanya adalah daftar elemen terkelompok (SliverGroupedListView) yang mengadopsi fungsional non-paged biasa
                SliverGroupedListView<T, G>(
                  data: state.items ?? [], // Menyuntikkan array memori elemen item pagination ke engine list grup
                  groupBy: groupBy, // Teknik pemisahan berdasarkan grup (kategori)
                  itemBuilder: (context, index, item) =>
                      itemBuilder(context, index), // Menyusun sel anakan (cells) yang diteruskan dari builder pagination
                  groupHeaderBuilder: groupHeaderBuilder,
                  separatorGroupBuilder: separatorGroup,
                  groupFooterBuilder: groupFooterBuilder,
                  separatorHeader: separatorHeader,
                  separator: separator, // Set nilai spasi per sel anakan
                  sortGroupBy: sortGroupBy, // Memerintah mekanisme penyortiran (ASC / DESC)
                  sortGroupItems: sortGroupItems, // Opsi tambahan komparasi angka
                ),
                // Jika builder UI loader nya memiliki nilai instansiasi (not null), konversi menjadi kotak sliver dan lekatkan pas di akhir (posisi bawah layar saat scroll)
                if (statusIndicatorBuilder != null)
                  SliverToBoxAdapter(child: statusIndicatorBuilder(context)),
              ],
            );

        // Core engine utama yang akan menengahi semua aksi transisi per-halaman secara sliver-based (smooth scrolling).
        return PagedLayoutBuilder<PageKeyType, T>(
          layoutProtocol: PagedLayoutProtocol.sliver, // Protokol ini memaksa implementasi framework sliver
          state: state, // Kondisi aktual memori internal
          fetchNextPage: fetchNextPage, // Melanjutkan prosedur scroll-to-bottom event
          builderDelegate: builderDelegate, // Merender UI template baris kustom yang sudah kita sediakan sebelumnya
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          
          // Layout skenario saat aplikasi telah sukses memuat semua halaman yang tersedia hingga akhir riwayat DB (no items left)
          completedListingBuilder: (
            context,
            itemBuilder,
            itemCount,
            noMoreItemsIndicatorBuilder, // Indikator teks atau UI khusus penanda habis (mentok)
          ) =>
              buildLayout(
            itemBuilder,
            itemCount,
            statusIndicatorBuilder: noMoreItemsIndicatorBuilder, // Meneruskan sinyal ke helper method di atas
          ),
          
          // Layout skenario saat aplikasi sibuk mengunduh payload payload batch json berikutnya (spinner loading tampil bawah)
          loadingListingBuilder:
              (context, itemBuilder, itemCount, progressIndicatorBuilder) =>
                  buildLayout(
            itemBuilder,
            itemCount,
            statusIndicatorBuilder: progressIndicatorBuilder, // Spinner / Shimmer progress loader dilampirkan
          ),
          
          // Layout skenario pengecualian error apabila payload API nya gagal dipanggil atau gagal di-parse di tengah jalan
          errorListingBuilder:
              (context, itemBuilder, itemCount, errorIndicatorBuilder) =>
                  buildLayout(
            itemBuilder,
            itemCount,
            statusIndicatorBuilder: errorIndicatorBuilder, // UI tombol muat ulang darurat (retry fallback) dilampirkan
          ),
        );
      },
    );
  }
}
