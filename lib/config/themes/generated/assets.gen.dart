// dart format width=80

/// KODE HASIL GENERATE - JANGAN DIMODIFIKASI SECARA MANUAL
/// *****************************************************
///  FlutterGen
/// *****************************************************

// Mengabaikan file ini untuk metrik persentase pengujian aplikasi (coverage).
// coverage:ignore-file
// Mengabaikan spesifik aturan penulisan linter (lint rules) di file otomatis ini.
// ignore_for_file: type=lint
// Mengabaikan kumpulan peringatan Dart seperti variabel usang, aturan urutan import, dll.
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

// Import paket esensial untuk manipulasi interaksi aset dari bundle sistem flutter.
import 'package:flutter/services.dart';
// Import toolkit widget dasar yang membantu penyusunan UI visual di layar.
import 'package:flutter/widgets.dart';
// Import perpustakaan SvgPicture sebagai perender standar dari file vektor .svg dengan singkatan `_svg`.
import 'package:flutter_svg/flutter_svg.dart' as _svg;
// Import perpustakaan vektor grafik pendukung (bila dirender dalam format byte) memakai alias `_vg`.
import 'package:vector_graphics/vector_graphics.dart' as _vg;

/// Kelas generik [$AssetsIconsGen] untuk memuat path seluruh koleksi file ikon.
/// Umumnya merupakan ikon berbentuk vektor SVG di dalam repositori `assets/icons/`.
class $AssetsIconsGen {
  /// Konstruktor berlabel konstan agar referensi tidak perlu memakan memori komputasi berulang.
  const $AssetsIconsGen();

  /// Mengacu ke file: assets/icons/ic_failed.svg
  /// 
  /// Mendapatkan instansi rendering SVG untuk menampilkan visual aset ikon yang gagal.
  SvgGenImage get icFailed => const SvgGenImage('assets/icons/ic_failed.svg');

  /// Mengacu ke file: assets/icons/ic_fork.svg
  /// 
  /// Mendapatkan instansi rendering SVG untuk visualisasi ikon cabang/fork.
  SvgGenImage get icFork => const SvgGenImage('assets/icons/ic_fork.svg');

  /// Mengacu ke file: assets/icons/ic_success.svg
  /// 
  /// Mendapatkan instansi rendering SVG untuk pertanda indikasi berhasil (success).
  SvgGenImage get icSuccess => const SvgGenImage('assets/icons/ic_success.svg');

  /// Mengacu ke file: assets/icons/ic_warning.svg
  /// 
  /// Mendapatkan instansi rendering SVG untuk indikator status perhatian / bahaya.
  SvgGenImage get icWarning => const SvgGenImage('assets/icons/ic_warning.svg');

  /// Properti [values] memuat list atau himpunan penuh dari rujukan setiap elemen ikon di direktori ini.
  List<SvgGenImage> get values => [icFailed, icFork, icSuccess, icWarning];
}

/// Kelas generik [$AssetsImagesGen] ini berfokus mengatur dan memusatkan alokasi
/// bagi file-file aset gambar bitmap/raster seperti format (.png, .jpg).
class $AssetsImagesGen {
  /// Konstruktor konstan yang membuat instansiasi objek menjadi singleton dan dioptimalkan di kompilasi rilis.
  const $AssetsImagesGen();

  /// Mengacu ke file: assets/images/img_empty.png
  /// 
  /// Menyediakan fungsi akses instance ke format image saat layout berstatus tidak ada isi konten.
  AssetGenImage get imgEmpty =>
      const AssetGenImage('assets/images/img_empty.png');

  /// Mengacu ke file: assets/images/img_error.png
  /// 
  /// Menyediakan fungsi pengakses gambar apabila menemui insiden gangguan (error) operasional.
  AssetGenImage get imgError =>
      const AssetGenImage('assets/images/img_error.png');

  /// Mengacu ke file: assets/images/img_not_found.png
  /// 
  /// Menyediakan fungsi akses bagi ilustrasi ketiadaan info yang berhasil ditelusuri.
  AssetGenImage get imgNotFound =>
      const AssetGenImage('assets/images/img_not_found.png');

  /// Mengacu ke file: assets/images/img_placeholder_user.png
  /// 
  /// Memberikan potret bayangan anonim yang digunakan bila foto avatar profil seseorang kosong.
  AssetGenImage get imgPlaceholderUser =>
      const AssetGenImage('assets/images/img_placeholder_user.png');

  /// Mengacu ke file: assets/images/img_pv_1.png
  /// 
  /// Menunjukkan gambar demonstrasi urutan ke-1 yang biasa muncul pada intro slide UI.
  AssetGenImage get imgPv1 => const AssetGenImage('assets/images/img_pv_1.png');

  /// Mengacu ke file: assets/images/img_pv_2.png
  /// 
  /// Menunjukkan gambar demonstrasi urutan ke-2 yang biasa muncul pada intro slide UI.
  AssetGenImage get imgPv2 => const AssetGenImage('assets/images/img_pv_2.png');

  /// Mengacu ke file: assets/images/img_pv_3.png
  /// 
  /// Menunjukkan gambar demonstrasi urutan ke-3 yang biasa muncul pada intro slide UI.
  AssetGenImage get imgPv3 => const AssetGenImage('assets/images/img_pv_3.png');

  /// Mengacu ke file: assets/images/splash_branding_logo.png
  /// 
  /// Me-referensikan gambar teks penjelas / entitas brand pengembang logo utamanya.
  AssetGenImage get splashBrandingLogo =>
      const AssetGenImage('assets/images/splash_branding_logo.png');

  /// Mengacu ke file: assets/images/splash_logo.png
  /// 
  /// Gambar lambang besar yang diperuntukkan rilis saat tahap inisialisasi menu masuk (Splash).
  AssetGenImage get splashLogo =>
      const AssetGenImage('assets/images/splash_logo.png');

  /// Mengembalikan list kolektif dari subkategori semua image berbentuk list object `AssetGenImage`.
  List<AssetGenImage> get values => [
        imgEmpty,
        imgError,
        imgNotFound,
        imgPlaceholderUser,
        imgPv1,
        imgPv2,
        imgPv3,
        splashBrandingLogo,
        splashLogo
      ];
}

/// Kelas generik [$AssetsModelsGen] mencatat titik temu semua format dokumen khusus
/// semacam AI Machine Learning Models (TensorFlow) pada lokasi file konfigurasi folder.
class $AssetsModelsGen {
  /// Konstruktor hemat memori kelas $AssetsModelsGen.
  const $AssetsModelsGen();

  /// Mengacu ke file: assets/models/cataract-model.tflite
  /// 
  /// Merupakan akses terhadap string file path model deteksi / pelacakan citra katarak TFLite.
  String get cataractModel => 'assets/models/cataract-model.tflite';

  /// Mengacu ke file: assets/models/labels.txt
  /// 
  /// Merupakan file label metadata berbasis teks sebagai pelengkap klasifikasi kategori hasil model TFLite.
  String get labels => 'assets/models/labels.txt';

  /// List yang merangkum keseluruhan nilai lokasi format (string) model kecerdasan buatan.
  List<String> get values => [cataractModel, labels];
}

/// Ini adalah gerbang kelas Induk Tunggal [Assets] agar developer mudah mencari nama file 
/// tanpa direpotkan pengetikan manual (hardcoded typo) sehingga code bisa aman (type-safe).
class Assets {
  /// Pembatasan instansiasi obyek ini dengan cara mendirikan Private Konstruktor `._()` .
  const Assets._();

  /// Instansiasi folder ikon untuk mengelompokan akses kategori tipe [icons]
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  
  /// Instansiasi folder gambar untuk merepresentasikan gambar png/jpg dalam tag [images]
  static const $AssetsImagesGen images = $AssetsImagesGen();
  
  /// Instansiasi folder model merujuk pemuatan klasifikasi model pada properti [models]
  static const $AssetsModelsGen models = $AssetsModelsGen();
}

/// Objek jembatan [AssetGenImage] memfasilitasi abstraksi dari aset lokal dan
/// mengonversinya menjadi Widget interaktif Flutter [Image] agar gampang disuntikkan parameter styling UI.
class AssetGenImage {
  /// Inisialisasi properti dasar yang terdiri dari nama path aset 
  /// dan argumen kustom modifikator lainnya seperti ukuran resolusi dasar, varian rilis program, maupun efek animasi.
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  /// Parameter nama berkas/folder lokal spesifik.
  final String _assetName;

  /// Variabel menyimpan resolusi yang diatur per meta file asetnya.
  final Size? size;
  
  /// Fitur penyesuaian jika build flavor project dibedakan dalam target market spesifik (opsional).
  final Set<String> flavors;
  
  /// Variabel ini mengandung konfigurasi informasi animasi jikalau gambar merupakan .GIF.
  final AssetGenImageAnimation? animation;

  /// Fungsi pemroses perenderan [Image] pada kerangka sistem UI Widget tree Flutter.
  /// Membawa banyak parameter properti atribut visualisasi yang melimpah 
  /// untuk mengkustom aset tersebut ke dalam tampilan antar muka.
  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    // Membangkitkan instance `Image.asset` standar (Image widget bawaan kerangka Flutter).
    return Image.asset(
      _assetName, // Alamat sumber gambar
      key: key, // Identitas unik komponen widget tree
      bundle: bundle, // Lokasi bundel repositori penampungan aset
      frameBuilder: frameBuilder, // Callback kontrol untuk penampungan animasi masuk gambar secara kustom
      errorBuilder: errorBuilder, // Menampilkan widget substitusi manakala terjadi kegagalan muatan aset
      semanticLabel: semanticLabel, // Label lisan (Text-to-speech accessibility) bagi kebutuhan pengguna tunanetra
      excludeFromSemantics: excludeFromSemantics, // Keputusan mengeluarkan keterangan bagi screenreader
      scale: scale, // Ratio penyekalaan resolusi dimensi aslinya
      width: width, // Konfigurasi paksa batas maksimum/minimum rasio panjang x (lebar)
      height: height, // Konfigurasi batas ketinggian y (tinggi gambar) pada kotak ruang
      color: color, // Hamparan palet warna yang mewarnai di atas gambar asli
      opacity: opacity, // Parameter redup atau terang transparansi yang mengatur pendaran alpha
      colorBlendMode: colorBlendMode, // Teknik pencampuran warna ke piksel gambar (misal `BlendMode.srcIn`)
      fit: fit, // Mode pembentukan ukuran penyesuaian isi ruang batas luarnya 
      alignment: alignment, // Penyelarasan tata letak gambar pada sisi kiri/tengah/atas/bawah bingkainya
      repeat: repeat, // Instruksi bagi frame yang tersisa, digandakan otomatis bagaikan tegel pola background
      centerSlice: centerSlice, // Area batasan spesifik gambar tipe stretchable agar batas siku sisinya bertahan tidak terdistorsi (Nine-patch concept)
      matchTextDirection: matchTextDirection, // Adaptasi orientasi gambar (Right-To-Left) yang akan diflip untuk menyesuaikan budaya bahasa baca lokal
      gaplessPlayback: gaplessPlayback, // Status yang tidak menampilkan ruang kosong sesaat pada re-render ketika src berubah
      isAntiAlias: isAntiAlias, // Pemrosesan algoritma penghalusan pada batas garis ujung piksel warna agar tak bergerigi tajam
      package: package, // Keterangan modul atau rute di luar project internal, yang ditargetkan sumber plugin paket luarnya
      filterQuality: filterQuality, // Pilihan metode kalkulasi render warna pada saat scaling gambar (rendah / medium / superior)
      cacheWidth: cacheWidth, // Parameter pengaturan prapemuatan optimasi ke alokasi memori buffer GPU bagian lebar (memperkecil pemakaian ram aplikasi)
      cacheHeight: cacheHeight, // Parameter pengaturan prapemuatan resolusi height limit kompresi memori RAM / GPU 
    );
  }

  /// Memfasilitasi provider atau basis dasar informasi resource gambar ini tanpa wujud widget (Raw resource).
  /// Sangat relevan dipergunakan jika gambar akan disisipkan dalam bingkai [BoxDecoration] atau latar belakang Image avatar dekorasi semata.
  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    // Fungsi ini mengekstrak [AssetImage] untuk dirender komponen lain yang memerlukan delegasi gambar background.
    return AssetImage(
      _assetName, // Lokasi URL string resource lokal
      bundle: bundle, // Paket instalator bundel
      package: package, // Paket instalator asal muasal dependency folder
    );
  }

  /// Ekstraksi mendapatkan literal identitas jalur String file objek ini (`assets/...`)
  String get path => _assetName;

  /// Ekstraksi memperoleh literal key identifikasi unik untuk objek ini
  String get keyName => _assetName;
}

/// Komponen pemandu pengaturan [AssetGenImageAnimation] yang mengkoleksi karakteristik statis mengenai gerakan.
class AssetGenImageAnimation {
  /// Memerlukan pendefinisian status keaktifan boolean, durasi berjalan, serta kuantitas kelajuan frames dari image berektensi animasi.
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  /// Mengandung pernyataan jika model memiliki komponen visual dinamis bergerak
  final bool isAnimation;
  
  /// Parameter rentang interval durasi pertunjukan iterasi frame bergambar itu sebelum kembali/berhenti
  final Duration duration;
  
  /// Banyaknya irisan tumpukan gambar satuan sebagai penentu seberapa mulusnya aksi.
  final int frames;
}

/// Perantara utilitas terfokus yaitu [SvgGenImage] yang menjembatani ekstraksi aset 
/// dengan kemampuan rendernya pada mesin grafis dari plugin vektor.
class SvgGenImage {
  /// Metode pemanggil normal/klasik SVG dari rute berkas file sumber format asli `.svg`.
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false; // Penanda boolean bahwa kode ini bukan binary vektor kompilasi .vec.

  /// Alternatif metode pemanggilan tipe file grafik yang sudah menjalani prakompilasi (.vec),
  /// agar load SVG ini jadi sangat ringkas dan ringan.
  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true; // Penanda boolean memvalidasi sebagai grafis vektor terkompilasi (.vec).

  /// Mendeklarasikan informasi nama string asal mula posisi rute filenya
  final String _assetName;
  
  /// Mendeklarasikan patokan bawaan proporsional dimensinya (opsional).
  final Size? size;
  
  /// Mendeklarasikan kumpulan batasan flavor environment-nya (opsional).
  final Set<String> flavors;
  
  /// Menyimpan kondisi biner indikator apakah resource adalah hasil pre-compile (ext .vec format) atau tidak (ext .svg format).
  final bool _isVecFormat;

  /// Fungsi pemrosesan perenderan [svg] pada kerangka library SvgPicture dari Flutter.
  /// Terdapat begitu banyak opsi argumen untuk mengendalikan karakteristik penggambaran garis/titik di tampilan.
  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color, // Argumen usang untuk warna SVG (tidak disarankan lagi).
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn, // Argumen usang metode perpaduan SVG (tidak disarankan lagi).
    @deprecated bool cacheColorFilter = false, // Argumen usang memori caching (tidak disarankan).
  }) {
    // Variabel penghubung antara lokasi file dan data biner / XML parsing grafis vektor pada Flutter (loader adapter).
    final _svg.BytesLoader loader;
    
    // Tahap filter kondisi mode.
    if (_isVecFormat) {
      // Jika mode .vec diaktifkan, terjemahkan memalui adaptor grafis binary loader (sangat efisien RAM) milik library vec
      loader = _vg.AssetBytesLoader(
        _assetName, // Lokasi string target `.vec`
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      // Tetapi, jikalau filenya berupa karakter string XML SVG pada umumnya (plain `.svg`), baca dan parsial secara tradisional menggunakan modul internal `flutter_svg`
      loader = _svg.SvgAssetLoader(
        _assetName, // Lokasi text target
        assetBundle: bundle,
        packageName: package,
        theme: theme, // Mengingstruksikan tata aturan pewarnaan sistem temanya (seperti darkmode/lightmode pada file svg-nya)
        colorMapper: colorMapper, // Algoritma penyesuaian fungsi pengubah indeks kode hexa dalam SVG tersebut menjadi spesifik lain secara dinamis (replace dynamic value color)
      );
    }
    
    // Tahap akhir mengirimkan konfigurasi loader aset beserta sekumpulan modifikator parameter interaktif kepada widget `SvgPicture`
    return _svg.SvgPicture(
      loader, // Pemasok bytes utama untuk memanggil pemrosesan struktur kode/biner grafis
      key: key, // Mengalokasikan unique Identifier widget
      matchTextDirection: matchTextDirection, // Konfigurasi arah susunan pembacaan teks apakah akan menyesuaikan arah penulisan ke budaya timur-tengah (kiri-kanan)
      width: width, // Titik pembesaran atau limit luas lebar
      height: height, // Titik perbesaran tinggi yang dikehendaki pada ukuran pembungkus
      fit: fit, // Mode persesuaian proporsi gambar saat ditekan/diulur ke box pembungkus luar
      alignment: alignment, // Setingan tata peletakan tengah, pinggir, atas/bawah
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox, // Aturan mematikan atau membiasakan elemen SVG tergambar meski menembus ukuran koordinat viewport (overflow visible)
      placeholderBuilder: placeholderBuilder, // Membentuk antarmuka sementara sebagai widget selagi kode SVG diproses engine dan di-download/render berat
      semanticsLabel: semanticsLabel, // Petunjuk kalimat informatif untuk software pembaca layar sistem aksesibel orang buta/Low vision (screenreader)
      excludeFromSemantics: excludeFromSemantics, // Apakah grafik sengaja dihiraukan agar tak terbaca software aksesibilitas layar
      colorFilter: colorFilter ?? // Teknik menyalurkan perubahan gradasi corak hue terhadap elemen garis dan bidak SVG (sebagai pengganti fungsi `color` lama)
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior, // Memotong paksa piksel pada ujung bingkai luar jika overstep (memakai HardEdge atau halus memakai AntiAlias)
      cacheColorFilter: cacheColorFilter, // Aturan menyimpankan state nilai perwarnaan SVG.
    );
  }

  /// Ekstraksi parameter literal untuk mengenali jalur path string milik SVG-nya.
  String get path => _assetName;

  /// Ekstraksi alias untuk nama Identifier dari instance.
  String get keyName => _assetName;
}
