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

/// Widget [MediaItems] digunakan untuk menampilkan daftar item media (seperti gambar, video, dll)
/// dalam bentuk baris berkelompok atau grid mini (maksimal sejumlah [maxItem]).
/// Jika jumlah item media melebihi batas [maxItem], item terakhir akan menampilkan sebuah teks penanda untuk sisa media.
class MediaItems extends StatelessWidget {
  /// Konstruktor untuk inisialisasi [MediaItems].
  /// Wajib menyertakan [mediaUrls] sebagai daftar sumber media. Parameter lain dapat disesuaikan opsional.
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
  
  /// Callback yang akan dipanggil saat pengguna menekan tombol/item penanda sisa media (misalnya "+x").
  final VoidCallback? onTapMore;
  
  /// Callback fungsi yang dipanggil saat suatu item media ditekan.
  /// Mengirimkan indeks `int` dari media yang sedang ditekan di daftar tersebut.
  final void Function(int)? onTap;
  
  /// Daftar kumpulan string URL/path dari media-media yang akan ditampilkan.
  final List<String> mediaUrls;
  
  /// Penempatan susunan untuk baris utama (main axis alignment) dari deretan media.
  final MainAxisAlignment mainAxisAlignment;
  
  /// Ukuran alokasi ruang dari sumbu utama (main axis size) pada row media.
  final MainAxisSize mainAxisSize;
  
  /// Menentukan jumlah maksimal item media yang akan dirender dalam widget awal ini.
  final int maxItem;
  
  /// Boolean flag. Jika bernilai `true`, kumpulan item media akan dibungkus dalam wadah bergaya grid 
  /// yang diklip (dipotong) menggunakan border radius tertentu.
  final bool isGrid;
  
  /// Dimensi ukuran dasar (lebar maupun tinggi) dari masing-masing item media tunggal.
  final double size;
  
  /// Jarak spasi (gap) antara masing-masing kotak/item media.
  final double itemsSpacing;
  
  /// Teks opsional (custom) untuk ditampilkan pada overlay item "lebih banyak" ("+x").
  final String? moreText;
  
  /// Lengkungan sudut (border radius) pada item atau wadah container grid utama.
  final double borderRadius;

  /// Membangun render widget visual.
  @override
  Widget build(BuildContext context) {
    // Menyalin ukuran size ke variabel mutabel itemSize untuk keperluan kalkulasi.
    var itemSize = size;
    // Memperbesar ukuran item menjadi sekitar 2x lipat ditambah spasi jika daftar media hanya berisi satu item (1).
    if (mediaUrls.length == 1) {
      itemSize = size * 2 + itemsSpacing;
    }

    // Menghitung estimasi ukuran container untuk 2 baris x 2 kolom dalam mode grid.
    var containerSize = size + itemsSpacing + size;
    // Jika hanya terdapat 1 buah item, sesuaikan ukuran container agar sama dengan satu ukuran item saja.
    if (mediaUrls.length == 1) {
      containerSize = itemSize;
    }

    // List lokal penampung kumpulan widget item.
    final items = <Widget>[];
    
    // Iterasi untuk membangun daftar widget media berdasarkan url, dibatasi dengan [maxItem].
    for (var i = 0; i < min(maxItem, mediaUrls.length); i++) {
      // Mengecek apakah kita berada pada iterasi pembuatan item terakhir sebelum batas maxItem,
      // dan memang jumlah list media lebih besar dari maxItem.
      if (mediaUrls.length > maxItem && i >= maxItem - 1) {
        // Jika media melebihi batas, jadikan item pada posisi ke (maxItem - 1) sebagai indikator "lebih banyak".
        items.add(
          GestureDetector(
            // Eksekusi onTapMore jika didefinisikan, jika null gunakan fungsi anonim fallback.
            onTap: onTapMore ??
                () async {
                  // Secara default, fungsi akan melakukan navigasi untuk membuka layar penuh (preview) daftar seluruh media.
                  await Get.to(
                    () => MediaListPreviewPage(mediaUrls: mediaUrls),
                  );
                },
            // Kontainer kotak dengan ukuran yang disesuaikan untuk membungkus overlay indikator sisa media.
            child: SizedBox(
              width: itemSize, // Lebar item.
              height: itemSize, // Tinggi item (persegi).
              child: _MoreItem(
                // Menampilkan jumlah sisa sisa media yang tidak termuat dengan format "+sisa".
                text: moreText ?? '+ ${mediaUrls.length - maxItem}',
                // Status grid.
                isGrid: isGrid,
                // Meng-generate widget media sebagai background layer indikator angka.
                child: _determineMedia(mediaUrls[i], i),
              ),
            ),
          ),
        );
      } else {
        // Tambahkan item media standar tanpa indikator overlay apapun.
        items.add(
          SizedBox(
            width: itemSize, // Lebar item.
            height: itemSize, // Tinggi item.
            // Memanggil fungsi penentuan tampilan media (contoh: load gambar/thumbnail).
            child: _determineMedia(mediaUrls[i], i),
          ),
        );
      }
    }

    // Mengembalikan hierarki layout akhir.
    // Jika isGrid true, bungkus list di dalam Row -> Container ber-radius -> Wrap.
    return isGrid
        ? Row(
            mainAxisSize: mainAxisSize, // Mengatur ukuran baris sesuai parameter opsi.
            mainAxisAlignment: mainAxisAlignment, // Mengatur kesejajaran widget.
            children: [
              // Menggunakan container pembungkus utama yang melakukan pemotongan area (Clip) grid secara keseluruhan.
              Container(
                width: containerSize, // Mengunci lebar agar pas seperti grid kotak utuh.
                clipBehavior: Clip.hardEdge, // Efek clip yang memotong anak widget yang melewati batas radius.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius), // Menetapkan radius kliping.
                ),
                // Menggunakan widget Wrap agar kumpulan item otomatis pindah baris saat memenuhi container.
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center, // Memusatkan silang.
                  spacing: itemsSpacing, // Spasi kolom.
                  runSpacing: itemsSpacing, // Spasi baris (saat wrapping).
                  children: items, // Daftar child media yang telah dikalkulasi.
                ),
              ),
            ],
          )
        // Sebaliknya, hanya kembalikan Wrap polosan untuk deretan list biasa (tanpa kliping container).
        : Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: itemsSpacing, // Spasi kolom.
            runSpacing: itemsSpacing, // Spasi antar baris pembungkus.
            children: items,
          );
  }

  /// Fungsi private (bantuan) untuk menentukan jenis dan widget penampil media (gambar/video) berdasarkan ekstensinya.
  Widget _determineMedia(String path, int index) {
    // Mengecek helper internal untuk mendeteksi tipe media dari path URL yang dikirimkan.
    final media = MediaHelper.getMediaType(path);
    // Mengembalikan Widget penyelesai media dengan parameter spesifik.
    return DetermineMediaWidget(
      path: path,
      image: SkyImage(
        src: media.path, // Sumber gambar yang akan diload.
        width: double.infinity, // Menyebar memenuhi parent yang ukurannya sudah diset melalui SizedBox.
        height: double.infinity, 
        // Mengatur corner radius. Jika sedang dalam mode isGrid maka diset ke 0 (mengikuti pembungkus luar grid).
        borderRadius: BorderRadius.circular(isGrid ? 0 : borderRadius),
        // Memicu callback jika widget ini disentuh secara individual.
        onTap: (onTap != null) ? () => onTap!(index) : null,
        // Aktifkan preview otomatis pada image viewer ini jika tidak ada fungsi onTap global yang dimasukkan.
        enablePreview: onTap == null,
      ),
    );
  }
}

/// Widget statik private [_MoreItem] bertugas untuk menampilkan antarmuka lapisan overlay teks transparan gelap
/// (misal tulisan "+3") di atas media terakhir.
class _MoreItem extends StatelessWidget {
  /// Konstruktor widget [_MoreItem] ini.
  const _MoreItem({
    required this.child,
    required this.text,
    required this.isGrid,
  });
  
  /// Variabel string teks overlay angka (contoh: "+3").
  final String text;
  
  /// Widget anak (umumnya gambar utama media) yang berfungsi sebagai latar belakang di bawah overlay teks.
  final Widget child;
  
  /// Parameter status untuk mengetahui konteks penampilan widget mode grid atau tidak.
  final bool isGrid;

  /// Render method lapisan tumpukan.
  @override
  Widget build(BuildContext context) {
    // Menggunakan Stack untuk melapisi container hitam transparan di atas widget child media asal.
    return Stack(
      children: [
        child, // Merender lapis paling bawah (gambar medianya).
        // Positioned.fill membuat widget child (container overlay) mengisi 100% ukuran parent stacknya.
        Positioned.fill(
          child: Container(
            // Mendekorasi latar lapisan hitam transparan.
            decoration: BoxDecoration(
              color: Colors.black38, // Hitam transparan dengan kepekatan 38%.
              // Radius dibikin kotak saja jika parent utamanya isGrid yang sudah memangkas tepiannya.
              borderRadius: BorderRadius.circular(isGrid ? 0 : 8),
            ),
            // Menggunakan fungsi pemosisi di Center area untuk teks angka indikator.
            child: Center(
              child: Text(
                text, // Memuat teks "jumlah lebih".
                style: const TextStyle(
                  fontSize: 16, // Ukuran teks indikator yang cukup jelas.
                  fontWeight: FontWeight.w400, // Ketebalan reguler teks indikator angka.
                  color: Colors.white, // Teks yang berwarna putih kontras.
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
