import 'package:quran_player/ui/widgets/sky_appbar.dart';
import '/ui/widgets/sky_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Komponen Widget visual yang didedikasikan untuk merepresentasikan status antarmuka "Kosong" (Empty State).
/// Utamanya disematkan secara dinamis saat muatan daftar array (data list) tiada isi, 
/// ataupun sesudah memproses operasi kueri pencarian yang membuahkan hasil nihil.
class EmptyView extends StatelessWidget {
  /// Parameter inisialisasi awal konstruktor bagi komponen layout [EmptyView].
  const EmptyView({
    super.key,
    this.emptyImage,
    this.emptyImageWidget,
    this.emptyTitle,
    this.emptySubtitle,
    this.physics,
    this.imageHeight,
    this.imageWidth,
    this.verticalSpacing = 24,
    this.horizontalSpacing = 24,
    this.titleStyle,
    this.subtitleStyle,
    this.retryText,
    this.onRetry,
    this.retryWidget,
    this.emptyRetryEnabled = false,
  });

  /// Widget ilustrasi gambar kustom yang diperkenankan dioverride dan diselipkan ke tengah.
  /// Jika variabel dibiarkan (null), sistem merujuk dan mengekstrak gambar cadangan default di dalam parameter [emptyImage].
  final Widget? emptyImageWidget;

  /// Target jalur rute / alamat lokasi aset (path string) ilustrasi untuk dipasang di situasi nihil data.
  final String? emptyImage;

  /// Blok kalimat penegasan (headline teks) pemberi tahu akan ketiadaan informasi spesifik.
  final String? emptyTitle;

  /// Kalimat deskripsi pelengkap (subjudul pendukung) demi menjabarkan instruksi kepada user ketika kosong.
  final String? emptySubtitle;

  /// Referensi pengatur sifat dan gaya interaksi layar geser yang dipengaruhi oleh komponen scroll view.
  final ScrollPhysics? physics;

  /// Opsi mematok ukuran tinggi tampilan dimensi untuk material aset grafis.
  final double? imageHeight;

  /// Opsi mematok pembatasan lebar horizontal dari pada aset visual.
  final double? imageWidth;

  /// Margin bukaan jeda vertikal yang konsisten guna meregangkan posisi antara ilustrasi dan teks tulisan sekeliling.
  final double verticalSpacing;

  /// Margin jarak yang diterapkan dari arah sebelah kiri ke dan sisi pojok penahan (layout constraint) di kanannya.
  final double horizontalSpacing;

  /// Opsional penataan properti warna maupun dimensi huruf teks tajuk kosong (headline stylings).
  final TextStyle? titleStyle;

  /// Tatanan dekoratif terpisah demi merekayasa penampilan rupa subjudul kosong (caption text format).
  final TextStyle? subtitleStyle;

  /// Konten baris frasa string unik pengganti tulisan asali di sisi muka tombol pemicu ulang.
  final String? retryText;

  /// Indikator sinyal pemicu kembali yang dijalankan seraya ditekan (dipanggil).
  final VoidCallback? onRetry;

  /// Bentukan wadah rupa visual elemen kustom sebagai jalan memodifikasi tombol antarmuka muat ulang default standar kita.
  final Widget? retryWidget;

  /// Bendera (flag boolean) yang memberlakukan perintah menyalakan lalu mempertontonkan tombol interaktif 'coba ulang' di layar ini.
  final bool emptyRetryEnabled;

  /// Pembangunan struktur arsitektur grafikal (komposisi rendering UI) yang akan dilihat akhir oleh sang pengguna aplikasi.
  @override
  Widget build(BuildContext context) {
    // Membawa semua komponen menyusup ke tengah dengan membungkus Center
    return Center(
      // Merangkai isi supaya kompatibel untuk ditarik vertikal memakai perlakuan scroller bawaan layar sentuh.
      child: SingleChildScrollView(
        // Pengaturan proporsi jarak margin (tata ruang) yang mengepung pinggiran komponen list view.
        padding: EdgeInsets.symmetric(
          // Ruang spasi berirama yang membentang arah y
          vertical: verticalSpacing,
          // Bukaan spasi yang membentang arah x
          horizontal: horizontalSpacing,
        ),
        // Menerapkan model sentakan scroll (fisika scroll per area) ke wadah UI ini
        physics: physics,
        // Menyederhanakan tumpukan obyek supaya rapi ditata garis memanjang dari arah sumbu bagian atas ke bagian dasar sumbu bawah.
        child: Column(
          children: [
            // Blok penampang visual grafis dari indikasi gambar penanda rupa state list kosong
            emptyImageWidget ??
                // Atau, andai komponen tak diekspresikan, gunakan widget standar ini via rujukan aset gambar.
                Image.asset(
                  // Jika properti null terapkan gambar lokal default 'AppImages.imgEmpty'
                  emptyImage ?? AppImages.imgEmpty,
                  // Menyusun batasan tingginya
                  height: imageHeight,
                  // Memaksakan patokan pelebaran grafiknya
                  width: imageWidth,
                ),
            // Penambahan spacer udara renggang vertikal berukuran sebesar spesifikasi di paramater.
            SizedBox(height: verticalSpacing),
            // Blok penampang keterangan pokok / kalimat kunci yang menarik atensi user langsung 
            Text(
              // Tulisan utama yang ditarik, atau berlabuh pada lokal terjemahan 'txt_empty_list_title' andai data nil
              emptyTitle ?? 'txt_empty_list_title'.tr,
              // Format pelurusan perenggan memusat
              textAlign: TextAlign.center,
              // Terapkan arahan perwajahan jenis text sesuai suplai kustomisasi atau serap dari tema aplikasi besar
              style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
            // Ruang perenggang sedikit tipis pembelah antar text tajuk dengan teks uraian pelengkap 
            SizedBox(height: verticalSpacing / 6),
            // Subjudul penjelas detail yang disertai proteksi batas bukaan pad sempit di sisinya.
            Padding(
              // Padding halus sekadar merenggangkan tepi sebanyak 8 dp kiri & kanan
              padding: const EdgeInsets.symmetric(horizontal: 8),
              // Paragraf deskriptif pencerah arahan state yang sedang tak produktif 
              child: Text(
                // Isikan variabel penjelas, sebaliknya berpulang memakai default frasa translasi.
                emptySubtitle ?? 'txt_empty_list_subtitle'.tr,
                // Pastikan blok perenggan selaras center
                textAlign: TextAlign.center,
                // Meneruskan kustom style ke material subjudul
                style: subtitleStyle,
              ),
            ),
            // Penyekat penahan akhir sebelum menumbuhkan susunan bottom actions.
            SizedBox(height: verticalSpacing),
            // Evaluasi logika percabangan kondisional: perlukah tombol pengisi aksi coba muat tampilkan ulang dicantumkan?
            if (emptyRetryEnabled && onRetry != null)
              // Kalau ya, periksa kesiapan perwajahan widget utuh (custom widget button). Jika ada, tuangkan langsung,
              retryWidget ??
                  // Bila terbukti opsinya absen, hasilkan desain bentuk SkyButton siap guna kita dengan ukuran standardnya.
                  SkyButton(
                    // Pasangkan opsi menyesuaikan bentang badan tombol menyempit padat
                    wrapContent: true,
                    // Tetapkan porsi tinggi elemen dasar
                    height: 50,
                    // Imbuhkan batasan tepi celah mendatar guna meluaskan boks menangkup teks tulisan
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // Sajikan opsi kata terjemahan 'ulang aksi' untuk tampilan interaksi mukanya
                    text: retryText ?? 'txt_reload'.tr,
                    // Ikat rujukan rute call action pada properti fungsi pembalasan ketikan ini.
                    onPressed: onRetry,
                  ),
          ],
        ),
      ),
    );
  }
}
