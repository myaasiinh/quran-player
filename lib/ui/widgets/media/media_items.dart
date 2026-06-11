import 'dart:math';

import '/core/helper/media_helper.dart';
import '/ui/widgets/media/determine_media_widget.dart';
import '/ui/widgets/media/preview/media_list_preview_page.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* penulis
   myaasiinh@gmail.com
*/

/// Widget [MediaItems] digunakan untuk menampilkan daftar item media (gambar, video, dll)
/// dalam bentuk baris berkelompok atau grid mini (maksimal sejumlah [maxItem]).
/// Jika jumlah media melebihi [maxItem], item terakhir akan menampilkan teks penanda sisa media.
class MediaItems extends StatelessWidget {
  const MediaItems({
    required this.mediaUrls,
    super.key,
    this.onTapMore,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.onTap,
    this.isGrid = false,
    this.size = 56.0,
    this.maxItem = 4,
    this.itemsSpacing = 5,
    this.moreText,
    this.borderRadius = 8,
  });
  
  /// Callback yang dipanggil saat tombol/item penanda sisa media ("+x") ditekan.
  final VoidCallback? onTapMore;
  
  /// Callback yang dipanggil saat suatu item media ditekan, mengirimkan indeks dari media tersebut.
  final void Function(int)? onTap;
  
  /// Daftar URL media yang akan ditampilkan.
  final List<String> mediaUrls;
  
  /// Penempatan susunan baris utama (main axis alignment) untuk media.
  final MainAxisAlignment mainAxisAlignment;
  
  /// Ukuran sumbu utama (main axis size).
  final MainAxisSize mainAxisSize;
  
  /// Jumlah maksimal item media yang akan ditampilkan dalam widget ini.
  final int maxItem;
  
  /// Jika `true`, item-item akan dibungkus dalam container bergaya grid (diklip dengan border radius).
  final bool isGrid;
  
  /// Ukuran dimensi dasar (lebar dan tinggi) dari setiap item media.
  final double size;
  
  /// Jarak antara masing-masing item media.
  final double itemsSpacing;
  
  /// Teks custom untuk ditampilkan di atas item "lebih banyak" ("+x").
  final String? moreText;
  
  /// Lengkungan sudut (border radius) pada item atau container grid.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    var itemSize = size;
    // Memperbesar ukuran item jika hanya ada satu media
    if (mediaUrls.length == 1) {
      itemSize = size * 2 + itemsSpacing;
    }

    var containerSize = size + itemsSpacing + size; // Ukuran untuk 2 baris (grid)
    if (mediaUrls.length == 1) {
      containerSize = itemSize;
    }

    final items = <Widget>[];
    // Membangun daftar item berdasarkan url media, dengan batas maksimal maxItem
    for (var i = 0; i < min(maxItem, mediaUrls.length); i++) {
      if (mediaUrls.length > maxItem && i >= maxItem - 1) {
        // Jika media melebihi batas, jadikan item terakhir sebagai indikator "lebih banyak"
        items.add(
          GestureDetector(
            onTap: onTapMore ??
                () async {
                  // Secara default, akan membuka halaman pratinjau daftar media
                  await Get.to(
                    () => MediaListPreviewPage(mediaUrls: mediaUrls),
                  );
                },
            child: SizedBox(
              width: itemSize,
              height: itemSize,
              child: _MoreItem(
                text: moreText ?? '+ ${mediaUrls.length - maxItem}',
                isGrid: isGrid,
                child: _determineMedia(mediaUrls[i], i),
              ),
            ),
          ),
        );
      } else {
        // Tambahkan item media standar
        items.add(
          SizedBox(
            width: itemSize,
            height: itemSize,
            child: _determineMedia(mediaUrls[i], i),
          ),
        );
      }
    }

    // Mengembalikan widget Wrap atau Row yang membungkus Wrap (untuk grid)
    return isGrid
        ? Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Container(
                width: containerSize,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: itemsSpacing,
                  runSpacing: itemsSpacing,
                  children: items,
                ),
              ),
            ],
          )
        : Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: itemsSpacing,
            runSpacing: itemsSpacing,
            children: items,
          );
  }

  /// Fungsi bantuan untuk menentukan widget media (gambar/video) dari path.
  Widget _determineMedia(String path, int index) {
    final media = MediaHelper.getMediaType(path);
    return DetermineMediaWidget(
      path: path,
      image: SkyImage(
        src: media.path,
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.circular(isGrid ? 0 : borderRadius),
        onTap: (onTap != null) ? () => onTap!(index) : null,
        enablePreview: onTap == null,
      ),
    );
  }
}

/// Widget private [_MoreItem] digunakan untuk menampilkan overlay teks
/// (misal "+3") di atas media terakhir.
class _MoreItem extends StatelessWidget {
  const _MoreItem({
    required this.child,
    required this.text,
    required this.isGrid,
  });
  
  /// Teks overlay yang akan ditampilkan (contoh: "+3").
  final String text;
  
  /// Widget anak (umumnya gambar media) di belakang overlay.
  final Widget child;
  
  /// Menentukan apakah widget ini ditampilkan dalam mode grid.
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(isGrid ? 0 : 8),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
