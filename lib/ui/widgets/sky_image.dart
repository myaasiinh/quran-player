import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'dart:async';
import 'dart:io';

import 'package:quran_player/core/helper/app_logger.dart';

import '/core/extension/string_extension.dart';
import '/core/helper/media_helper.dart';
import '/ui/widgets/media/preview/media_preview_page.dart';
import '/ui/widgets/platform_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum untuk menentukan bentuk dari gambar yang akan ditampilkan.
enum ShapeImage { 
  /// Bentuk oval (elips)
  oval, 
  /// Bentuk persegi panjang dengan sudut (rounded rectangle)
  react, 
  /// Bentuk lingkaran sempurna
  circle 
}

/* author
   myaasiinh@gmail.com
*/

/// Komponen `SkyImage` merupakan widget kustom yang membungkus logika rendering gambar
/// dari berbagai sumber (network, asset, file, SVG) secara dinamis.
/// Mendukung fitur placeholder, error handling, retry mekanisme, dan preview gambar.
class SkyImage extends StatelessWidget {
  /// Konstruktor utama untuk `SkyImage`.
  const SkyImage({
    super.key,
    this.src,
    this.width,
    this.height,
    this.onTap,
    this.border,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.enablePreview = false,
    this.placeholderFit,
    this.placeholderWidget,
    this.placeholderSrc,
    this.isAsset = false,
    this.color,
    this.previewTitle,
    this.previewTitleStyle,
    this.errorWidget,
    this.loadingWidget,
    this.shapeImage = ShapeImage.react,
    this.alignment = Alignment.center,
    this.size,
    this.generateByName,
    this.onRetrySrc,
    this.maxRetryCount = 1,
    this.retryTimeout,
    this.forceFileSrc = false,
    this.forceRemoteSrc = false,
    this.forceAssetSrc = false,
    this.forceSvgSrc = false,
  });

  /// Sumber gambar (URL, path asset, atau path file).
  final String? src;
  
  /// Lebar widget gambar.
  final double? width;
  
  /// Tinggi widget gambar.
  final double? height;
  
  /// Ukuran untuk gambar lingkaran (digunakan sebagai radius).
  final double? size;
  
  /// Fungsi callback yang dijalankan saat gambar ditekan.
  final VoidCallback? onTap;
  
  /// Gaya border di sekitar gambar.
  final Border? border;
  
  /// Gaya radius lengkungan sudut untuk bentuk `react`.
  final BorderRadiusGeometry? borderRadius;
  
  /// Menentukan bagaimana gambar disesuaikan di dalam kotaknya.
  final BoxFit fit;
  
  /// Memberikan filter warna pada gambar (berguna untuk SVG atau ikon).
  final Color? color;
  
  /// Widget yang ditampilkan jika gambar gagal dimuat.
  final Widget? errorWidget;
  
  /// Widget yang ditampilkan selama proses pemuatan gambar.
  final Widget? loadingWidget;
  
  /// Penyelarasan gambar di dalam bingkainya.
  final Alignment alignment;
  
  /// Bentuk dari gambar (oval, lingkaran, atau persegi panjang).
  final ShapeImage shapeImage;

  /// Sumber gambar placeholder yang dipanggil saat [src] bernilai null atau kosong.
  /// Jika Anda mengisi [generateByName], placeholderSrc ini akan diabaikan/tidak bekerja.
  final String? placeholderSrc;

  /// BoxFit khusus untuk gambar placeholder.
  final BoxFit? placeholderFit;

  /// Widget kustom yang dipanggil saat [src] bernilai null atau kosong.
  final Widget? placeholderWidget;

  /// Jika bernilai `true` -> mengaktifkan fitur ketukan untuk membuka halaman `MediaPreviewPage`.
  final bool enablePreview;
  
  /// Judul yang ditampilkan pada halaman pratinjau gambar.
  final String? previewTitle;
  
  /// Gaya teks untuk judul pratinjau gambar.
  final TextStyle? previewTitleStyle;

  /// Jika sumber gambar Anda berasal dari aset tetapi tidak berada di direktori **assets/images/..**
  /// Anda perlu mengatur ini ke `true` secara manual.
  final bool isAsset;

  /// Isi bidang ini untuk menghasilkan sumber gambar jaringan berdasarkan Nama yang diberikan
  /// (misal avatar dari inisial nama). Jika ini dan [placeholderSrc] diisi, 
  /// maka placeholderSrc tidak akan berfungsi.
  final String? generateByName;

  /// Fungsi untuk mencoba kembali memuat sumber gambar jaringan ketika mendapatkan respon 401 atau 403.
  final Future<String?> Function()? onRetrySrc;

  /// Jumlah maksimal percobaan ulang untuk [onRetrySrc].
  final int maxRetryCount;

  /// Durasi batas waktu (timeout) untuk percobaan ulang gambar jaringan.
  final Duration? retryTimeout;

  /// Memaksa sistem untuk memuat gambar dari sumber jarak jauh (remote/network).
  final bool forceRemoteSrc;

  /// Memaksa sistem untuk memuat gambar dari sistem file lokal (berkas).
  final bool forceFileSrc;

  /// Memaksa sistem untuk memuat gambar dari aset lokal.
  final bool forceAssetSrc;

  /// Memaksa sistem untuk merender gambar sebagai format SVG.
  final bool forceSvgSrc;

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah sumber gambar utama tersedia dan tidak kosong
    if (src.isNotNullAndNotEmpty) {
      // Jika ya, render widget BaseImage dengan sumber utama
      return BaseImage(
        src: src.toString(),
        width: width,
        height: height,
        fit: fit,
        border: border,
        borderRadius: borderRadius,
        enablePreview: enablePreview,
        onTapImage: onTap,
        isAsset: isAsset,
        color: color,
        previewTitle: previewTitle,
        previewTitleStyle: previewTitleStyle,
        errorWidget: errorWidget,
        loadingWidget: loadingWidget,
        shapeImage: shapeImage,
        alignment: alignment,
        size: size,
        onRetrySrc: onRetrySrc,
        maxRetryCount: maxRetryCount,
        timeoutRetry: retryTimeout,
        forceAssetSrc: forceAssetSrc,
        forceFileSrc: forceFileSrc,
        forceRemoteSrc: forceRemoteSrc,
        forceSvgSrc: forceSvgSrc,
      );
    } else {
      // Jika sumber utama kosong, tampilkan placeholder
      return placeholderWidget ??
          BaseImage(
            // Tentukan sumber placeholder: generate avatar atau gunakan default placeholder
            src: generateByName.isNotNullAndNotEmpty
                ? MediaHelper.generateAvatarByName(generateByName ?? 'user')
                : placeholderSrc ?? AppImages.imgNotFound,
            width: width,
            height: height,
            fit: placeholderFit ?? BoxFit.contain,
            border: border,
            borderRadius: borderRadius,
            enablePreview: enablePreview,
            onTapImage: onTap,
            isAsset: isAsset,
            color: color,
            previewTitle: previewTitle,
            previewTitleStyle: previewTitleStyle,
            shapeImage: shapeImage,
            alignment: alignment,
            size: size,
            onRetrySrc: onRetrySrc,
            maxRetryCount: maxRetryCount,
            timeoutRetry: retryTimeout,
            forceAssetSrc: forceAssetSrc,
            forceFileSrc: forceFileSrc,
            forceRemoteSrc: forceRemoteSrc,
            forceSvgSrc: forceSvgSrc,
          );
    }
  }
}

/// `BaseImage` adalah widget Stateful internal yang bertugas me-render dan
/// mengatur logika state (seperti hitungan retry) dari proses memuat gambar.
class BaseImage extends StatefulWidget {
  /// Konstruktor widget BaseImage.
  const BaseImage({
    required this.src,
    super.key,
    this.width,
    this.height,
    this.onTapImage,
    this.border,
    this.borderRadius,
    this.fit = BoxFit.fill,
    this.enablePreview = false,
    this.isAsset = false,
    this.color,
    this.previewTitle,
    this.previewTitleStyle,
    this.errorWidget,
    this.loadingWidget,
    this.shapeImage = ShapeImage.react,
    this.alignment = Alignment.center,
    this.size,
    this.onRetrySrc,
    this.maxRetryCount = 1,
    this.timeoutRetry,
    this.forceFileSrc = false,
    this.forceRemoteSrc = false,
    this.forceAssetSrc = false,
    this.forceSvgSrc = false,
  });

  /// Sumber gambar (teks wajib)
  final String src;
  final double? width;
  final double? height;
  final double? size;
  final VoidCallback? onTapImage;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final bool enablePreview;
  final bool isAsset;
  final Color? color;
  final String? previewTitle;
  final TextStyle? previewTitleStyle;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final ShapeImage shapeImage;
  final Alignment alignment;
  final Future<String?> Function()? onRetrySrc;
  final int maxRetryCount;
  final Duration? timeoutRetry;
  final bool forceRemoteSrc;
  final bool forceFileSrc;
  final bool forceAssetSrc;
  final bool forceSvgSrc;

  @override
  State<BaseImage> createState() => _BaseImageState();
}

class _BaseImageState extends State<BaseImage> {
  /// Variabel lokal untuk melacak berapa kali sistem telah mencoba memuat ulang gambar
  int retryCount = 0;

  @override
  Widget build(BuildContext context) {
    // Validasi asersi: jika bentuk lingkaran dipilih, parameter ukuran tidak boleh null
    if (widget.shapeImage == ShapeImage.circle) {
      assert(
        widget.size != null,
        'Ukuran (size) tidak boleh kosong jika shapeImage adalah ShapeImage.circle, ',
      );
    }

    // Mengembalikan widget Gesture Detector untuk menangani ketukan pada gambar
    return GestureDetector(
      // Tentukan logika onTap berdasarkan apakah mode pratinjau diaktifkan
      onTap: widget.enablePreview
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  // Buka halaman pratinjau media dengan gambar yang ditentukan
                  builder: (context) => MediaPreviewPage(
                    src: widget.src,
                    isAsset: widget.isAsset,
                    title: widget.previewTitle,
                    titleStyle: widget.previewTitleStyle,
                    // Paksa render sebagai gambar murni
                    forceImage: true,
                  ),
                ),
              )
          : widget.onTapImage, // Jika pratinjau mati, gunakan callback biasa
      // Wadah untuk menambahkan batas (border) sebelum gambar digambar
      child: Container(
        decoration: BoxDecoration(border: widget.border),
        // Panggil fungsi penentu bentuk pemotongan gambar
        child: _determineShapeImage(),
      ),
    );
  }

  /// Menentukan widget pembungkus gambar (clip) berdasarkan enum ShapeImage.
  Widget _determineShapeImage() {
    return switch (widget.shapeImage) {
      // Potong gambar menjadi oval
      ShapeImage.oval => ClipOval(child: _determineImageWidget()),
      // Bungkus dalam CircleAvatar untuk bentuk bulat sempurna
      ShapeImage.circle => CircleAvatar(
          radius: widget.size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size!),
            child: _determineImageWidget(),
          ),
        ),
      // Potong dengan radius tertentu (kotak dengan sudut melengkung)
      ShapeImage.react => ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
          child: _determineImageWidget(),
        ),
    };
  }

  /// Logika inti untuk mendeteksi tipe sumber gambar dan merender widget yang sesuai.
  Widget _determineImageWidget() {
    // Mengecek apakah sumber gambar berupa URL (remote)
    final isFromRemote = widget.src.startsWith('http');
    // Mengecek apakah sumber adalah file SVG
    final isSvg = widget.src.endsWith('.svg');
    // Mengecek apakah sumber adalah direktori aset lokal aplikasi
    final isAssets = widget.isAsset ||
        widget.src.startsWith('lib/resources/') ||
        widget.src.startsWith('assets/images/');
    // Jika tidak dari remote, bukan aset, dan bukan SVG, maka itu adalah file lokal
    final isFile = !isFromRemote && !isAssets && !isSvg;

    // Jika gambar dari internet atau dipaksa sebagai remote
    if (isFromRemote || widget.forceRemoteSrc) {
      return CachedNetworkImage(
        // Tambahkan "https://" jika tidak ada skema http (sebagai fallback keamanan)
        imageUrl: isFromRemote ? widget.src : 'https://${widget.src}',
        color: widget.color,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment,
        // Tampilkan indikator pemuatan saat mengunduh gambar
        placeholder: (context, url) => SizedBox(
          height: widget.height,
          width: widget.width,
          child: widget.loadingWidget ?? const PlatformLoadingIndicator(),
        ),
        // Tangkap log jika terjadi kesalahan
        errorListener: (error) {
          AppLogger.debug('Error memuat gambar jaringan: $error');
        },
        // Logika penanganan error (termasuk mekanisme retry)
        errorWidget: (context, url, error) {
          AppLogger.debug('Error memuat gambar jaringan: $error');
          // Jika mendapat pesan error unauthorized (401 atau 403)
          if (error.toString().contains('401') ||
              error.toString().contains('403')) {
            // Cek apakah masih dalam batas maksimum percobaan ulang
            if (retryCount < widget.maxRetryCount &&
                widget.onRetrySrc != null) {
              // Panggil fungsi retry secara asinkronus tanpa ditunggu (unawaited)
              unawaited(
                widget.onRetrySrc!().then((value) {
                  // Perbarui UI jika widget masih berada dalam layar (mounted)
                  if (context.mounted) {
                    setState(() {
                      retryCount++;
                    });
                  }
                }),
              );
            }
          }
          // Kembalikan widget error default (ikon error) jika gagal dimuat
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: widget.errorWidget ?? const Icon(Icons.error),
          );
        },
      );
    } 
    // Jika gambar berupa file SVG atau dipaksa sebagai SVG
    else if (isSvg || widget.forceSvgSrc) {
      return SvgPicture.asset(
        widget.src,
        width: widget.width,
        height: widget.height,
        // Aplikasikan pewarnaan menggunakan ColorFilter dengan blend mode srcIn
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    } 
    // Jika gambar dari aset lokal atau dipaksa sebagai aset
    else if (isAssets || widget.forceAssetSrc) {
      return Image.asset(
        widget.src,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        alignment: widget.alignment,
        // Tangani jika aset gagal dimuat
        errorBuilder: (context, error, stackTrace) {
          AppLogger.debug('Error memuat gambar aset $error');
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: widget.errorWidget ?? const Icon(Icons.error),
          );
        },
      );
    } 
    // Jika gambar dari file lokal perangkat atau dipaksa sebagai file
    else if (isFile || widget.forceFileSrc) {
      return Image.file(
        // Buat objek File berdasarkan path string
        File(widget.src),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        alignment: widget.alignment,
        // Tangani jika file tidak ditemukan atau gagal dibaca
        errorBuilder: (context, error, stackTrace) {
          AppLogger.debug('Error memuat gambar file $error');
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: widget.errorWidget ?? const Icon(Icons.error),
          );
        },
      );
    } 
    // Sebagai fallback terakhir, kembalikan widget error
    else {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: widget.errorWidget ?? const Icon(Icons.error),
      );
    }
  }
}
