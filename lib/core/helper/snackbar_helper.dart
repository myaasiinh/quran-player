// Mengimpor perpustakaan pondasi dasar kerangka Material UI yang membawa perbekalan ragam instrumen antarmuka (termaktub di dalamnya fasilitas peluncur SnackBar).
import 'package:flutter/material.dart';
// Mengimpor perpustakaan peretas lintas batas dari GetX guna mengakuisisi kunci akses konteks sakti dari awan global (Get.context) serta kekuatan sulih bahasa bawaannya (.tr).
import 'package:get/get.dart';

/// Himpunan himbauan takdir ketetapan status kategori rupa (Enumerasi) berjuluk [SkySnackBarType].
/// 
/// Ditakdirkan sebagai klasifikasi pemilah ragam nuansa keluh kesah layar sorong bawah (SnackBar)
/// agar dapat memilah kadar kepentingan/urgensinya lewat pancaran rona visual yang berlainan.
enum SkySnackBarType { 
  /// Tipe Pesan Datar (Normal): Mengantar warta lumrah keseharian nihil sentimen (Acap kali dipoles nuansa kelam hitam monokrom).
  NORMAL, 
  /// Tipe Selebrasi Riang (Success): Memukul gong perayaan panen berlimpah atas suksesnya transaksi (Senantiasa dibalut hamparan rona hijau permai).
  SUCCESS, 
  /// Tipe Pertanda Malapetaka (Error): Menjeritkan terompet peringatan insiden kemalangan, tatkala roda eksekusi patah di jalan (Ditaburi siraman tinta merah membara api).
  ERROR, 
  /// Tipe Isyarat Waswas (Warning): Menyulut obor remang kehati-hatian demi mencegah ketersesatan pengguna merambah lebih jauh (Kerap dilabur warna mentari jingga oranye).
  WARNING 
}

/// Cetak biru abstrak utilitas berdikari milik dewan pertimbangan pesuruh [SnackBarHelper].
/// 
/// Dicanangkan spesifik meredam penderitaan keluhuran pengetikan bahasa pemrograman bertele-tele (Boilerplate code).
/// Ia menjadi jalan pintas pesuruh secepat kilat untuk merakit, menata, sekaligus meroketkan papan pengumuman
/// pop-up notifikasi daratan (SnackBar) menembus pandangan mata tanpa perlu mondar-mandir bersilat lidah memanggil `ScaffoldMessenger`.
abstract class SnackBarHelper {
  /// Antarmuka portal penyusunan perwujudan [SnackBar] bereksistensi hak merdeka (Custom mode).
  /// Membuka kran kebebasan seluas langit bagi penggambar UI untuk menyuntik, memoles, menata dan melumat rias kosmetik 
  /// hingga presisi piksel sesuai fantasi eksentrik seniman dev-nya.
  /// 
  /// Spesifikasi Rangkaian Parameter Opsional:
  /// * `[message]` : Rentetan abjad kaligrafi tulisan pokok yang diembannya.
  /// * `[behavior]` : Titah watak karakteristik pendiriannya (Akankah mendarat diam membumi 'Fixed' atau terbang mengudara anggun bebas 'Floating').
  /// * `[action]` : Tuas tombol kompensasi ganti rugi (Contoh kancing pelatuk "Urungkan/Batal" setelah tak sengaja menghapus objek).
  /// * `[backgroundColor]` : Sapuan corak rona tinta kelir latar kanvasnya.
  /// * `[margin]` : Benteng jarak celah pertahanan fisik tepi luar terluar, agar tak saling tabrak dengan lis bibir layar terbawah (Eksklusif saat Floating).
  /// * `[padding]` : Rongga insulasi busa bantal pelindung di batas dalam kotak yang menyekat sesak dinding ke tulisan utama.
  /// * `[width]` : Toleransi bentangan lebar pengunci garis ufuk batas maksimum kanvasnya.
  /// * `[shape]` : Pahat pencukur tepian pisau geometri (Lazim dipakai membengkokkan keangkuhan sudut-sudut kaku jadi membulat halus `RoundedRectangleBorder`).
  /// * `[elevation]` : Ketinggian dongkrak levitasi tiga dimensi berbayang fatamorgana untuk mempertegas objek berada lebih depan.
  static void custom({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    Color? backgroundColor,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    ShapeBorder? shape,
    double? elevation,
  }) {
    // Mengeksekusi penyerahan titipan berkas segenap modifikasi gila tersebut ke tangan pabrik induk pemroses utama internal.
    showDefaultSnackBar(
      message: message ?? 'txt_success'.tr,
      behavior: behavior,
      action: action,
      backgroundColor: backgroundColor,
      width: width,
      elevation: elevation,
      shape: shape,
      margin: margin,
      padding: padding,
    );
  }

  /// Antarmuka portal pemanggil pesan status Netral/Hambar tak berjiwa ([normal]).
  /// Tidak memiliki bias peringatan bahaya maupun gembira. Biasa dipakai di penayangan sekilas info sistem semata.
  static void normal({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    // Mewakilkan konstruksi instan wujud ini kepada pabrik pembangun rupa aslinya [showDefaultSnackBar].
    showDefaultSnackBar(
      message: message ?? 'txt_success'.tr,
      behavior: behavior,
      action: action,
    );
  }

  /// Antarmuka portal yang dipukul palunya menyambut gilang gemilang kala trofi operasi berhasil sukses dijemput pamakai ([success]).
  /// Biasa ditampakkan ke permukaan dengan mengenakan kostum bernuansa dedaunan rimba hijau.
  static void success({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    // Melemparkan pesanan ini seraya menegaskan cap stempel tipe perlakuan identitas `SkySnackBarType.SUCCESS`.
    showDefaultSnackBar(
      message: message ?? 'txt_success'.tr,
      type: SkySnackBarType.SUCCESS,
      behavior: behavior,
      action: action,
    );
  }

  /// Antarmuka portal pembunyian sirene ratapan manakala sistem tak berkutik dikurung kegagalan memilukan ([error]).
  /// Paling sering diperalat menayangkan penolakan mentah dari sergapan API (HTTP 500/400/Timeout), lantas meneror psikis pembaca dengan cipratan cat merah berdarah.
  static void error({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    // Membawa jeritan keluhan duka cita tersebut seraya mengikatkan identifikasi tipe `SkySnackBarType.ERROR` padanya.
    showDefaultSnackBar(
      message: message ?? 'txt_error'.tr,
      type: SkySnackBarType.ERROR,
      behavior: behavior,
      action: action,
    );
  }

  /// Antarmuka portal kibaran pita peringatan rintangan sandungan sebelum marabahaya nyata menghadang ([warning]).
  /// Diaplikasikan andai sistem ragu hendak meneruskan dan meminta pertimbangan penggunanya. Diwarnai nuansa remang jingga.
  static void warning({
    required String? message,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    // Mengukuhkan kategori pembentukannya dengan jubah khusus bernama `SkySnackBarType.WARNING`.
    showDefaultSnackBar(
      message: message ?? 'txt_warning'.tr,
      type: SkySnackBarType.WARNING,
      behavior: behavior,
      action: action,
    );
  }

  /// Ruang jagal sentral pembentukan mesin pengerak pondasi utama [showDefaultSnackBar]. (Pusat Single source of truth logika perwajahan).
  /// Tempat berputarnya roda-roda gigi penjahit jubah estetika fisik kotak SnackBar, 
  /// sekaligus panggung pendelegasian mandat komando pada gubernur tunggal `ScaffoldMessenger` untuk benar-benar menayangkannya ke alam nyata.
  static void showDefaultSnackBar({
    required String message,
    SkySnackBarType type = SkySnackBarType.NORMAL,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? width,
    ShapeBorder? shape,
    double? elevation,
  }) {
    // Menimbang penuangan kaleng cat alas. Andaikata belum ada wasiat yang dipesan ([backgroundColor] fiktif null),
    // kita rampas paksa mandat warna dasar utama tema aplikasinya via ekstensi sakti GetX `Theme.of(Get.context!).primaryColor`.
    var bgColor = backgroundColor ?? Theme.of(Get.context!).primaryColor;
    
    // Switch expression kontemporer persembahan Dart era modern buat memverifikasi arah aliran selokan warna 
    // lantas mengguyur ulang nuansa kelirnya diwarnai status takdir [SkySnackBarType] nasib asalnya yang mendikte.
    bgColor = switch (type) {
      SkySnackBarType.ERROR => bgColor = Colors.red, // Ditakdirkan menanggung beban error maut, mandikan lumpur cat Merah menyala.
      SkySnackBarType.SUCCESS => bgColor = Colors.green, // Diberkahi nasib kesuksesan sempurna, pakaikan daun hijau segar.
      SkySnackBarType.WARNING => bgColor = Colors.orange, // Disandung nasib isyarat teguran abu-abu, laburkan warna jeruk oranye remang.
      SkySnackBarType.NORMAL => bgColor = Colors.black, // Andai hampa cuma numpang lewat biasa, lebur warnanya dengan legam hitam.
    };

    // Perakitan sasis jasad materi widget komoditas andalan kita, si papan notifikasi [SnackBar].
    final snackBar = SnackBar(
      width: width, // Ambang penyempitan lebar dinding
      elevation: elevation, // Jengkal tingkat keangkuhan ketinggian ilusi pengangkat (Shadow cast)
      shape: shape, // Guratan pisau tumpul yang mencukur siku lekukannya (Misal membulat)
      action: action, // Cantolan cantelan kancing fungsi perintah penyelamat tambahan
      margin: margin, // Jarak pagar teritori terluar pemisah dari singgungan bibir batas perangkat
      padding: padding, // Jarak rongga dada interior bantalan aman pelindung teks di dalamnya
      // Menanamkan untaian aksara teks ke pusat dadanya dan memulas rona tinta sekujur abjad dengan cat Putih kapas supaya menjerit kontras bercahaya.
      content: Text(message, style: const TextStyle(color: Colors.white)),
      // Melestarikan watak asali agar ia luwes mendobrak bumi melayang angkuh di atas tanah (Floating behavior), andai tiada wejangan perilaku yang mengaturnya dari pemesan.
      behavior: behavior ?? SnackBarBehavior.floating,
      // Mengoleskan cat kuas dari peras keringat logika penyaringan switch di atas tadi.
      backgroundColor: bgColor,
    );

    // Mencekik kera sakti pewenang utama hierarki pengayom kanvas yang berkuasa di puncak (ScaffoldMessenger),
    // yang mana ditangkap melalui tangan panjangnya satelit koneksi semesta ala [Get.context].
    ScaffoldMessenger.of(Get.context!)
      // Menggebrak meja dan memberangus bungkam rahang setiap bibir sisa-sisa omongan pengumuman lawas (SnackBar) 
      // yang barangkali masih ngoceh bertengger menuh-menuhin kanvas agar minggat menyingkir tanpa ampun...
      ..hideCurrentSnackBar()
      // ...baru kemudian dihempaskan dan dipentaskan sosok primadona Anyar yang gres mulus baru keluar oven pemanggangan ini ke sorotan puncak pentasnya!
      ..showSnackBar(snackBar);
  }
}
