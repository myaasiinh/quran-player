import 'dart:io';

import '/ui/widgets/base/empty_view.dart';
import '/ui/widgets/base/error_view.dart';
import '/ui/widgets/base/pagination/pagination_sliver_grid.dart';
import '/ui/widgets/base/pagination/pagination_sliver_list.dart';
import '/ui/widgets/platform_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/* penulis
   myaasiinh@gmail.com
*/

/// Kelas [StateView] adalah widget pembungkus yang mengelola berbagai status tampilan.
/// 
/// Widget ini berguna untuk menampilkan tampilan pramuat (loading), tampilan kosong (empty),
/// tampilan kesalahan (error), atau konten utama (body) secara dinamis sesuai dengan
/// state yang diberikan.
class StateView extends StatelessWidget {
  /// Konstruktor untuk penggunaan tingkat halaman (page level).
  /// 
  /// Dirancang untuk membungkus keseluruhan halaman, di mana bisa mendukung fitur 'tarik untuk memuat ulang' (pull-to-refresh)
  /// jika [onRefresh] disediakan.
  const StateView.page({
    required this.loadingEnabled,
    required this.errorEnabled,
    required this.emptyEnabled,
    required this.onRetry,
    required this.child,
    super.key,
    this.emptyRetryEnabled = false,
    this.emptyImage,
    this.emptyTitle,
    this.emptySubtitle,
    this.loadingView,
    this.visibleOnEmpty = true,
    this.visibleOnError = true,
    this.errorImageWidget,
    this.errorSubtitle,
    this.errorTitle,
    this.errorView,
    this.isComponent = false,
    this.emptyView,
    this.retryText,
    this.onRefresh,
    this.imageHeight,
    this.imageWidth,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.titleStyle,
    this.subtitleStyle,
    this.errorImage,
    this.retryWidget,
    this.emptyImageWidget,
    this.footerSliver,
    this.headerSliver,
    this.shrinkWrap = false,
    this.physics,
    this.separator,
    this.padding,
    this.scrollDirection = Axis.vertical,
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
    this.scrollBehavior,
    this.semanticChildCount,
    this.anchor,
    this.center,
  });

  /// Konstruktor untuk penggunaan tingkat komponen (component level).
  /// 
  /// Digunakan untuk membungkus bagian kecil dari antarmuka pengguna (UI)
  /// alih-alih seluruh halaman. Menonaktifkan dukungan pull-to-refresh.
  const StateView.component({
    required this.loadingEnabled,
    required this.errorEnabled,
    required this.emptyEnabled,
    required this.onRetry,
    required this.child,
    super.key,
    this.emptyRetryEnabled = false,
    this.emptyTitle,
    this.emptyImage,
    this.emptySubtitle,
    this.loadingView,
    this.visibleOnEmpty = true,
    this.visibleOnError = true,
    this.errorImageWidget,
    this.errorSubtitle,
    this.errorTitle,
    this.errorView,
    this.isComponent = true,
    this.emptyView,
    this.retryText,
    this.imageHeight,
    this.imageWidth,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.titleStyle,
    this.subtitleStyle,
    this.errorImage,
    this.retryWidget,
    this.emptyImageWidget,
    this.footerSliver,
    this.headerSliver,
    this.shrinkWrap = false,
    this.physics,
    this.separator,
    this.padding,
    this.scrollDirection = Axis.vertical,
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
    this.scrollBehavior,
    this.semanticChildCount,
    this.anchor,
    this.center,
  }) : onRefresh = null;

  /// Dapat menimpa pengaturan visibilitas tampilan kosong meskipun [emptyEnabled] bernilai true.
  final bool visibleOnEmpty;

  /// Dapat menimpa pengaturan visibilitas tampilan kesalahan meskipun [errorEnabled] bernilai true.
  final bool visibleOnError;

  /// Tampilkan [loadingView] ketika bernilai *true*.
  final bool loadingEnabled;

  /// Tampilkan [emptyView] ketika bernilai *true*.
  final bool emptyEnabled;

  /// Tampilkan [errorView] ketika bernilai *true*.
  final bool errorEnabled;

  /// Tampilan indikator pemuatan khusus yang akan muncul jika [loadingEnabled] bernilai true.
  final Widget? loadingView;

  /// Widget gambar kustom yang akan muncul di tampilan kosong jika [emptyEnabled] bernilai true.
  final Widget? emptyImageWidget;

  /// Jalur aset gambar (string) yang akan muncul di tampilan kosong.
  final String? emptyImage;

  /// Judul teks yang akan muncul di tampilan kosong jika [emptyEnabled] bernilai true.
  final String? emptyTitle;

  /// Subjudul teks yang akan muncul di tampilan kosong jika [emptyEnabled] bernilai true.
  final String? emptySubtitle;

  /// Widget gambar kustom yang akan muncul di tampilan kesalahan jika [errorEnabled] bernilai true.
  final Widget? errorImageWidget;

  /// Jalur aset gambar (string) yang akan muncul di tampilan kesalahan.
  final String? errorImage;

  /// Judul teks yang akan muncul di tampilan kesalahan jika [errorEnabled] bernilai true.
  final String? errorTitle;

  /// Subjudul teks yang akan muncul di tampilan kesalahan jika [errorEnabled] bernilai true.
  final String? errorSubtitle;

  /// Atur menjadi true jika widget ini bertindak sebagai komponen kecil (bukan halaman penuh).
  final bool isComponent;

  /// Teks kustom untuk tombol coba lagi (retry).
  final String? retryText;

  /// Widget kustom untuk tombol coba lagi.
  final Widget? retryWidget;

  /// Fungsi pengendali aksi tekan (onPress) untuk tindakan 'coba lagi' (retry) ketika terjadi error.
  final void Function()? onRetry;

  /// Widget tampilan khusus (kustom) secara utuh ketika status kosong.
  final Widget? emptyView;

  /// Konten utama dari widget ini. Akan dimuat bila tidak ada status error, kosong, atau loading.
  final Widget child;

  /// Fungsi pemanggilan ulang yang memicu fitur muat ulang (pull-to-refresh).
  final VoidCallback? onRefresh;

  /// Ketinggian khusus yang akan diterapkan pada gambar pesan error/kosong.
  final double? imageHeight;

  /// Lebar khusus yang akan diterapkan pada gambar pesan error/kosong.
  final double? imageWidth;

  /// Spasi vertikal untuk memisahkan elemen dalam tampilan pesan error/kosong.
  final double? verticalSpacing;

  /// Spasi horizontal untuk memisahkan elemen dalam tampilan pesan error/kosong.
  final double? horizontalSpacing;

  /// Gaya teks khusus yang akan diterapkan untuk bagian judul pesan error/kosong.
  final TextStyle? titleStyle;

  /// Gaya teks khusus yang akan diterapkan untuk bagian subjudul pesan error/kosong.
  final TextStyle? subtitleStyle;

  /// Widget tampilan khusus (kustom) secara utuh ketika status kesalahan terjadi.
  final Widget? errorView;

  /// Tentukan apakah tombol coba lagi (retry) juga dimunculkan pada status kosong.
  final bool emptyRetryEnabled;

  /// --- Properti untuk tata letak gulir (Scroll) ---
  
  /// Mengontrol apakah tampilan menggulung membungkus kontennya.
  final bool shrinkWrap;
  
  /// Perilaku fisik elemen gulir (misal memantul atau kaku).
  final ScrollPhysics? physics;
  
  /// Widget pemisah tambahan di antara konten (jika berlaku).
  final Widget? separator;
  
  /// Jarak (padding) tambahan yang digunakan dalam tampilan menggulung.
  final EdgeInsetsGeometry? padding;
  
  /// Arah penggulungan (horizontal atau vertikal).
  final Axis scrollDirection;
  
  /// Menjaga status (state) agar tidak dibuang otomatis ketika menggulung keluar dari pandangan.
  final bool? addAutomaticKeepAlives;
  
  /// Mengatur ulang pengecatan lapisan visual dengan batasan tertentu untuk optimasi.
  final bool? addRepaintBoundaries;
  
  /// Menyertakan indeks semantik pada masing-masing anak.
  final bool? addSemanticIndexes;
  
  /// Luas ekstensi cache.
  final double? cacheExtent;
  
  /// Tipe pemotongan (clipping) konten saat keluar batas.
  final Clip? clipBehavior;
  
  /// Mengatur perilaku memulai gerak seret (drag) pada gulir.
  final DragStartBehavior? dragStartBehavior;
  
  /// Besar item secara seragam.
  final double? itemExtent;
  
  /// Perilaku penyingkiran keyboard saat mulai penggulungan.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  
  /// Menjadikan pandangan gulir sebagai pandangan utama dalam PrimaryScrollController.
  final bool? primary;
  
  /// Membalikkan arah gulir.
  final bool? reverse;
  
  /// Kontroler kustom yang bisa membaca atau mengatur offset scroll.
  final ScrollController? scrollController;
  
  /// ID pelestarian (restoration) dalam memulihkan state gulir.
  final String? restorationId;
  
  /// Perilaku khusus untuk scroll sistem keseluruhan di area ini.
  final ScrollBehavior? scrollBehavior;
  
  /// Total anak semantik yang teridentifikasi.
  final int? semanticChildCount;
  
  /// Titik patokan permulaan komponen gulir.
  final double? anchor;
  
  /// Kunci (Key) pusat (center) spesifik tempat widget bertumpu pada gulir.
  final Key? center;

  /// **Peringatan:**
  /// Hanya menerima widget jenis sliver dan
  /// hanya akan terlihat saat [onRefresh] tidak diatur menjadi null.
  ///
  /// Berguna saat Anda perlu menambahkan widget paginasi ke dalam SingleChildScrollView
  /// namun pemantik (trigger) dari paginasi (memuat data berikutnya) adalah SingleChildScrollView bukan dari List.
  /// - Letakkan widget paginasi di [headerSliver] atau [footerSliver] dengan menggunakan
  /// [PaginationSliverList] atau [PaginationSliverGrid].
  final List<Widget>? footerSliver;

  /// **Peringatan:**
  /// Hanya menerima widget jenis sliver dan
  /// hanya akan terlihat saat [onRefresh] tidak diatur menjadi null.
  ///
  /// Berguna saat Anda perlu menambahkan widget paginasi ke dalam SingleChildScrollView
  /// namun pemantik (trigger) dari paginasi (memuat data berikutnya) adalah SingleChildScrollView bukan dari List.
  /// - Letakkan widget paginasi di [headerSliver] atau [footerSliver] dengan menggunakan
  /// [PaginationSliverList] atau [PaginationSliverGrid].
  final List<Widget>? headerSliver;

  @override
  Widget build(BuildContext context) {
    // Menyimpan sementara tampilan yang akan dirender berdasarkan logika state
    Widget body;
    
    // Periksa status terlebih dahulu dari tingkat yang paling kritis (error -> empty -> loading)
    if (visibleOnError && errorEnabled) {
      // Jika terjadi kesalahan dan disetel untuk divisualisasikan, muat tampilan Error
      body = getErrorView(context);
    } else if (visibleOnEmpty && emptyEnabled && !loadingEnabled) {
      // Jika kosong (dan tidak sedang memuat ulang) dan disetel untuk divisualisasikan, muat tampilan Kosong
      body = getEmptyView(context);
    } else if (loadingEnabled || (!emptyEnabled && !errorEnabled)) {
      // Jika aplikasi masih memuat atau tidak berada pada state khusus, muat Tampilan Utama/Pemuat
      body = getLoadingAndBodyView(context);
    } else {
      // Fallback jika tidak ada state yang memenuhi kriteria, kembalikan antarmuka kosong yang ringan (SizedBox.shrink)
      body = const SizedBox.shrink();
    }

    // Mengembalikan widget tubuh utama
    return body;
  }

  /// Menghasilkan kombinasi tampilan pemuat (loading) atau tampilan utama (body).
  Widget getLoadingAndBodyView(BuildContext context) {
    // Jika bentuknya adalah komponen statis kecil atau onRefresh bernilai null, 
    // kita tidak butuh dukungan ScrollView bersyarat dengan fitur refresh (tarik muat ulang)
    if (isComponent || onRefresh == null) {
      return loadingEnabled
          // Tampilkan loading view jika tersedia, jika tidak maka PlatformLoadingIndicator sebagai default
          ? loadingView ?? const PlatformLoadingIndicator()
          // Tampilkan body utama jika pemuatan selesai
          : child;
    } else {
      // Jika memiliki properti pemanggilan onRefresh, render dalam ScrollView interaktif
      // Tampilan berbeda antara OS iOS dan OS Android untuk menyesuaikan pedoman platform
      return Platform.isIOS
          ? _iosObjectView(onRefresh: onRefresh!)
          : _androidObjectView(onRefresh: onRefresh!);
    }
  }

  /// Tampilan penggulungan dengan dukungan RefreshIndicator spesifik untuk perangkat Android (Material).
  Widget _androidObjectView({required VoidCallback onRefresh}) {
    // Komponen pembungkus tarik-untuk-muat-ulang gaya Material (Android)
    return RefreshIndicator(
      // Sinkronisasi proses refresh untuk menangani pengulangan asinkron
      onRefresh: () => Future.sync(onRefresh),
      // Membuat list penggulungan yang bisa memuat elemen kompleks via Sliver
      child: CustomScrollView(
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: scrollDirection,
        scrollBehavior: scrollBehavior,
        controller: scrollController,
        // Menyembunyikan papan ketik jika layarnya ditarik
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        primary: primary,
        restorationId: restorationId,
        reverse: reverse ?? false,
        semanticChildCount: semanticChildCount,
        anchor: anchor ?? 0.0,
        center: center,
        // Kumpulan bagian elemen berformat Sliver
        slivers: [
          // Muat elemen pada bagian atas (headerSliver) jika disediakan
          if (headerSliver != null) ...headerSliver!,
          
          // Render widget utama (anak/child) jika tidak sedang memuat
          if (!loadingEnabled)
            // Mengonversi Widget standar (box) agar dapat dimasukkan di dalam format CustomScrollView
            SliverToBoxAdapter(child: child)
          else
            // Bila sedang memuat, manfaatkan layar penuh sisa (SliverFillRemaining)
            SliverFillRemaining(
              hasScrollBody: false,
              // Indikator ditaruh di posisi paling tengah layar
              child: Center(
                child: loadingView ?? const CircularProgressIndicator(),
              ),
            ),
            
          // Muat elemen pada bagian bawah (footerSliver) jika disediakan
          if (footerSliver != null) ...footerSliver!,
        ],
      ),
    );
  }

  /// Tampilan penggulungan dengan dukungan RefreshIndicator spesifik untuk perangkat iOS (Cupertino).
  Widget _iosObjectView({required VoidCallback onRefresh}) {
    // Membuat list penggulungan yang bisa memuat elemen kompleks via Sliver
    return CustomScrollView(
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      scrollBehavior: scrollBehavior,
      controller: scrollController,
      // Perilaku keyboard ditarik (sama seperti Material)
      keyboardDismissBehavior:
          keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
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
        // Muat elemen Sliver atas (Header)
        if (headerSliver != null) ...headerSliver!,
        
        // Komponen kontrol tarik untuk memuat ulang bergaya asli iOS (Cupertino)
        CupertinoSliverRefreshControl(onRefresh: () => Future.sync(onRefresh)),
        
        // Render widget utama (anak/child) jika pemuatan selesai
        if (!loadingEnabled)
          SliverToBoxAdapter(
            // Di iOS kita perlu membungkus dengan scroll view tambahan yang dilarang bergulir,
            // untuk mengisolasi layout yang diharapkan bertingkah selaras dengan sliver.
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: child,
            ),
          )
        else
          // Jika loading, isi luasan sisa ruang dan posisikan loading indicator
          SliverFillRemaining(
            child: loadingView ?? const PlatformLoadingIndicator(),
          ),
          
        // Muat elemen Sliver bawah (Footer)
        if (footerSliver != null) ...footerSliver!,
      ],
    );
  }

  /// Membungkus loading widget menjadi tampil memudar halus via animasi opacity.
  Widget getLoadingView(Widget loadingWidget) {
    return Center(
      // Transisi kemunculan pemuat
      child: AnimatedOpacity(
        // Opasitas berubah berdasarkan penanda loadingEnabled
        opacity: loadingEnabled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: loadingWidget,
      ),
    );
  }

  /// Mengembalikan tampilan kekosongan informasi.
  Widget getEmptyView(BuildContext context) {
    // Memilih untuk merender widget kosong yang disediakan pengguna secara manual,
    // atau gunakan EmptyView bawaan dengan konfigurasi yang ada.
    return emptyView ??
        EmptyView(
          emptyImage: emptyImage,
          emptyImageWidget: emptyImageWidget,
          emptyTitle: emptyTitle,
          emptySubtitle: emptySubtitle,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          horizontalSpacing: horizontalSpacing ?? 24,
          verticalSpacing: verticalSpacing ?? 24,
          titleStyle: titleStyle,
          subtitleStyle: subtitleStyle,
          retryWidget: retryWidget,
          onRetry: onRetry,
          retryText: retryText,
          emptyRetryEnabled: emptyRetryEnabled,
        );
  }

  /// Mengembalikan tampilan layar ketika mendapat kesalahan/error.
  Widget getErrorView(BuildContext context) {
    // Memilih merender widget error kustom pengguna,
    // atau jika belum ditentukan gunakan ErrorView standar bawaan sistem.
    return errorView ??
        ErrorView(
          errorImage: errorImage,
          errorImageWidget: errorImageWidget,
          errorTitle: errorTitle,
          errorSubtitle: errorSubtitle,
          onRetry: onRetry,
          retryText: retryText,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          horizontalSpacing: horizontalSpacing ?? 24,
          verticalSpacing: verticalSpacing ?? 24,
          titleStyle: titleStyle,
          subtitleStyle: subtitleStyle,
          retryWidget: retryWidget,
        );
  }
}
