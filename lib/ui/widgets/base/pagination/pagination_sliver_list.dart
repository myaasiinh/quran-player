/* Created by
   30/01/2024
   myaasiinh@gmail.com
*/

import '/ui/widgets/base/pagination/pagination_delegate.dart';
import '/ui/widgets/grouped_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Widget Pembantu yang menggabungkan [PagedSliverList] dan [PaginationDelegate].
///
/// Sangat berguna untuk membangun komponen daftar bertipe sliver dengan
/// cepat menggunakan satu widget secara praktis.
class PaginationSliverList<T> extends StatelessWidget {
  /// Konstruktor pembuatan widget [PaginationSliverList].
  const PaginationSliverList({
    required this.pagingController,
    required this.itemBuilder,
    required this.onRetry,
    super.key,
    this.loadingView,
    this.emptyView,
    this.errorView,
    this.errorLoadMoreView,
    this.maxItemView,
    this.emptyImage,
    this.emptyTitle,
    this.emptySubtitle,
    this.enableIOSStyle = true,
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
    this.shrinkWrapFirstPageIndicators = false,
    this.separator,
    this.padding,
    this.emptyRetryEnabled = false,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback,
  });

  /// Kontroler yang mengatur data yang dimuat ke dalam daftar (pagination).
  final PagingController<int, T> pagingController;
  /// Callback pembuat widget untuk setiap butir data dengan tipe [T].
  final ItemWidgetBuilder<T> itemBuilder;
  /// Fungsi panggilan balik ketika proses mengulang / coba lagi dijalankan.
  final VoidCallback onRetry;
  /// Jika [true], maka tombol "coba lagi" muncul meski data kosong.
  final bool emptyRetryEnabled;
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
  /// Apakah harus mengecilkan indikator halaman pertama jika tidak diperlukan.
  final bool shrinkWrapFirstPageIndicators;
  /// Widget pemisah antara satu baris item dan baris berikutnya.
  final Widget? separator;
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
  final bool enableIOSStyle;
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
  /// Nilai padding atau batas di luar daftar Sliver.
  final EdgeInsetsGeometry? padding;
  /// Ukuran tinggi tetap yang ditetapkan untuk setiap item (bisa mempercepat rendering).
  final double? itemExtent;
  /// Mengaktifkan kemampuan keep alive secara otomatis.
  final bool addAutomaticKeepAlives;
  /// Memisahkan rendering dari objek daftar dengan objek lain.
  final bool addRepaintBoundaries;
  /// Menyediakan nomor index secara semantik (aksesibilitas).
  final bool addSemanticIndexes;
  /// Panggilan callback khusus semantik ketika index dihitung.
  final int? Function(Widget, int)? semanticIndexCallback;

  @override
  Widget build(BuildContext context) {
    // Membungkus Sliver dengan padding yang ditentukan, jika null di set 0.
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      // PagingListener akan memonitor kondisi paging (loading, success, error)
      sliver: PagingListener(
        controller: pagingController,
        // Builder ini melempar state pagination saat ini
        builder: (context, state, fetchNextPage) => PagedSliverList.separated(
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          // Mengatur status terkini (menampilkan list atau indikator state)
          state: state,
          // Fungsi untuk mengambil halaman berikutnya (triggering)
          fetchNextPage: fetchNextPage,
          // Memberikan index bagi fungsi semantik dan aksesibilitas
          semanticIndexCallback: semanticIndexCallback,
          // Kinerja akan meningkat jika kita menentukan itemExtent secara spesifik
          itemExtent: itemExtent,
          // Keep-alive agar state dari item yang diluar layar tetap tersimpan
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          // Menambah index pembaca layar (screen reader)
          addSemanticIndexes: addSemanticIndexes,
          // Mengoptimalkan perlakuan rendering masing-masing item
          addRepaintBoundaries: addRepaintBoundaries,
          // builderDelegate adalah pengaturan tampilan saat empty, error, memuat, dan list
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
          // Pengaturan separator/pemisah antarkolom
          separatorBuilder: (context, index) {
            // Mengembalikan separator yang ditentukan, atau SizedBox kosong jika null
            return separator ?? const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// Widget sliver untuk membangun daftar item yang dikelompokkan (Grouped ListView).
/// 
/// Data [T] akan diurutkan dan dikelompokkan berdasar atribut kunci [G].
class SliverGroupedListView<T, G> extends StatelessWidget {
  /// Konstruktor widget daftar berlompok dengan sliver.
  const SliverGroupedListView({
    required this.data,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    required this.separatorBuilder,
    super.key,
    this.sortBy = SortBy.asc,
    this.separator,
    this.separatorHeader,
    this.groupFooterBuilder,
    this.separatorGroup,
  });

  /// Daftar sekumpulan data tipe [T].
  final List<T> data;
  /// Callback pengubah data utama [T] untuk dikelompokkan menjadi [G].
  final G Function(T element) groupBy;
  /// Builder tampilan yang membentuk tajuk header dari sebuah grup.
  final Widget Function(G element) groupHeaderBuilder;
  /// Builder tampilan setiap item pada anggota grup tersebut.
  final Widget Function(BuildContext context, int index, T element) itemBuilder;
  /// Builder opsional untuk tampilan kaki (footer) pada grup tersebut.
  final Widget Function(G element)? groupFooterBuilder;
  /// Arah pengurutan kelompok (Menaik / Menurun).
  final SortBy sortBy;
  /// Widget spasi opsional antar item di dalam grup.
  final Widget? separator;
  /// Widget batas antara elemen header dan isi item.
  final Widget? separatorHeader;
  /// Widget batas antarkelompok/grup yang bersebelahan.
  final Widget? separatorGroup;

  /// Callback untuk membangun pemisah dinamis diantara seluruh perulangan widget.
  final Widget? Function(BuildContext, int) separatorBuilder;

  @override
  Widget build(BuildContext context) {
    // Membuat sliver list dengan penyekat dinamis
    return SliverList.separated(
      itemCount: data.length,
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, index) {
        // Melakukan tracking urutan indeks untuk iterasi
        final isFirstIndex = index == 0;
        final isLastIndex = index + 1 == data.length;

        // Mengurutkan item secara langsung dalam list
        data.sort((b, a) => (groupBy(b) as Comparable).compareTo(groupBy(a)));

        var isSame = true;
        // Identifikasi jenis tipe grup data saat ini
        final item = groupBy(data[index]);

        G prevItem;
        // Pengecekan grup item dengan item sebelumnya
        if (!isFirstIndex) {
          prevItem = groupBy(data[index - 1]);
          isSame = item == prevItem;
        } else {
          prevItem = item;
          isSame = item == prevItem;
        }

        G nextItem;
        // Pengecekan grup item terhadap data di index selanjutnya
        if (isLastIndex) {
          nextItem = item;
        } else {
          nextItem = groupBy(data[index + 1]);
        }

        // Pengelompokkan dengan pola Ascending (Naik)
        if (sortBy == SortBy.asc) {
          return Column(
            children: [
              // Tambahkan grup header di iterasi pertama, atau saat grup baru
              if (isFirstIndex || !isSame) _buildHeaderWidget(item),
              // Tambahkan separator antar item jika masih dalam grup yang sama
              if (!isFirstIndex && item == prevItem)
                _buildSeparatorWidget(separator),
              // Memanggil fungsi penampil baris widget
              _buildItemWidget(context, index),
              // Tambahkan grup footer pada iterasi akhir grup atau list terakhir
              if (groupFooterBuilder != null &&
                  (item != nextItem || isLastIndex))
                groupFooterBuilder!(item),
              // Tambahkan jarak spasi jika masih ada iterasi grup lain setelahnya
              if (separatorGroup != null &&
                  (item != nextItem || isLastIndex) &&
                  !isLastIndex)
                separatorGroup!,
            ],
          );
        } else {
          // Pengelompokkan dengan pola Descending (Turun) / Reverse
          return Column(
            children: [
              // Grup header ditambahkan dari akhir (item paling bawah dibalik posisinya)
              if (isLastIndex) _buildHeaderWidget(item),
              _buildItemWidget(context, index),
              // Pemisah item di dalam grup
              if (!isFirstIndex && item == prevItem)
                _buildSeparatorWidget(separator),
              // Pembangunan footer untuk pengurutan desc
              if (groupFooterBuilder != null &&
                  (item != prevItem || isFirstIndex))
                groupFooterBuilder!(item),
              // Pembatas awal grup
              if (!isSame) _buildHeaderWidget(prevItem),
            ],
          );
        }
      },
    );
  }

  /// Membangun blok antar muka sebuah header grup termasuk spasi pembatasnya.
  Widget _buildHeaderWidget(G item) {
    return Column(
      children: [
        SizedBox(width: double.infinity, child: groupHeaderBuilder(item)),
        _buildSeparatorWidget(separatorHeader),
      ],
    );
  }

  /// Membangun satu blok tampilan per item data menggunakan ruang lebar maksimal.
  Widget _buildItemWidget(BuildContext context, int index) {
    return SizedBox(
      width: double.infinity,
      child: itemBuilder(context, index, data[index]),
    );
  }

  /// Membangun blok pembatas ruang menggunakan Widget `item` atau elemen kosong.
  Widget _buildSeparatorWidget(Widget? item) {
    return SizedBox(
      width: double.infinity,
      child: item ?? const SizedBox.shrink(),
    );
  }
}
