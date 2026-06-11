// Mengimpor bundel perangkat dasar penciptaan perwajahan visual antarmuka sistem (Material Design UI toolkit).
import 'package:flutter/material.dart';

// Mengimpor paket utilitas pembacaan arsitektur penanganan pergerakan mesin akses diskripsi berkas nyata di I/O (dart:io) laiknya dokumen/gambar.
import 'dart:io';

// Mengimpor kelas manajer pembantu pembuat rupa gulungan seprei menu di ranjang bawah layar (Bottom Sheet UI Helper).
import '/core/helper/bottom_sheet_helper.dart';
// Mengimpor fasilitas peracikan sintesis elemen multimedia yang mensuport generasi teks menjadi rupa avatar gambar ilustrasi artifisial.
import '/core/helper/media_helper.dart';
// Mengimpor lembaran menu interaktif dasar bawah pelataran layar peruntukan bursa sentral galeri/kamera asal usul potret foto (Attachment picker).
import '/ui/widgets/media/attachments_source_bottom_sheet.dart';
// Mengimpor komponen pamungkas pelindung dan pemroses render visual gambar spesifik yang diinjeksi kecerdasan pembersihan error/caching (SkyImage).
import '/ui/widgets/sky_image.dart';
// Mengimpor serangkaian modul tajuk AppBar meskipun sekadar guna meraup dan mengakses konstanta definisi daftar `AppImages` pendukungnya di dalam direktori satu atapnya.
import 'package:quran_player/ui/widgets/sky_appbar.dart';

/// Perangkat komponen widget terstruktur [AvatarPicker] menjelma sebagai posko mini pos perbaikan profil interaktif
/// yang mengakomodasi manuver ganti busana, pemilihan, hingga etalase pertunjukan portret lambang gambar wajah penggunanya di pojok layar.
///
/// Modul brilian purna rupa ini direkayasa terampil mengeksekusi misi-misi pamungkasnya: (1) Menyerap material dan mengekspos foto rupa 
/// menilik alur alamat penunjukan disk gawai (Local path mapping), (2) Meracik keajaiban sulap substitusi inisial nama generik (Placeholder art) 
/// tatkala gawai mandul foto orisinal aslinya, serta (3) Dipersenjatai sergapan tombol amunisi (aksi sunting ganti & tombol eksekusi perobohan pembuangan potretnya).
class AvatarPicker extends StatelessWidget {
  /// Bangunan konstruktor permanen pencetak balok widget wujudnya bernama [AvatarPicker].
  const AvatarPicker({
    required this.onAvatarSelected,
    super.key,
    this.imagePath,
    this.editWidget,
    this.hideRemove = false,
    this.enabled = true,
    this.namePlaceholder,
    this.onRemoveImage,
    this.editIcon,
    this.editBackgroundColor,
  });

  /// Sandi catatan alamat baris rute memori perangkat terlampir ke muatan fisik gambar muka subjek.
  final String? imagePath;

  /// Rekam jejak coretan abjad nama sang pemakai orisinalnya (dipekerjakan khusus demi melahirkan ilustrasi 
  /// profil topeng rakitan tebakan grafis inisial dua huruf semata di saat kerangka wujud [imagePath] masih fiktif (null)).
  final String? namePlaceholder;

  /// Modul keleluasaan buat Anda sekalian para desainer UI merombak ganti sekujur wujud tombol aksi perombakan/Editing suntingnya dari luar kelas parameter ini 
  /// menyisipkan rancangannya pada [editWidget].
  final Widget? editWidget;

  /// Keringanan parameter bagi mereka yang tak berminat merevisi desain cangkang kulit utuh wadah tombok sunting,
  /// hanya cukup menyodorkan lambang gambar pensil vektornya (editIcon). Perlu diingat ini akan unjuk gigi cuma kalau letak [editWidget] masih terbengkalai.
  final Widget? editIcon;

  /// Percikan warna pelapis dasar alas dari tombol melingkar editan tersebut buat Anda yang mau penyesuaian nuansa tema rona khusus.
  final Color? editBackgroundColor;

  /// Saklar pemutus nasib boolean penindas yang kala dijejal true membuahkan lenyapnya wujud kemunculan lambang salib merah pembuang berkas pencopot potret.
  final bool hideRemove;

  /// Engsel pintu boolean penjaga kuncian fungsional interaksi picker yang senantiasa menahan cegah ketukan sentuh telunjuk (Unclickable) seketika ia direndahkan ke 'false'.
  final bool enabled;

  /// Terowongan penyambung arus panggilan pengiriman balik (Callback Event Tunnel) pemancar rezeki hasil jepretan/unduhan, 
  /// yang menyajikan buah tangan pilihan tervalidasi objek bertajuk seonggok dokumen ([File]) foto orisinal buat dipasok menyuapi induk layarnya.
  final void Function(File) onAvatarSelected;

  /// Terowongan penyambung arus sirkuit perombakan perobohan pemutusan kaitan file gambar yang merespons gelegar perintah dari tekanan pemakai pada ikon singkir buang silang/hapus memori (onRemoveImage).
  final VoidCallback? onRemoveImage;

  /// Metode pementasan arsitektur [build] penata balok susunan tata raut komponen di layar dimensi piranti genggam perangkat.
  @override
  Widget build(BuildContext context) {
    // Kurungan pembatas pagar geometris pengekangan luas kavling area pakem di batas ruang ketat dimensi imbang 80x80 titik pixel kotak persis.
    return SizedBox(
      height: 80,
      width: 80,
      // Menyodorkan bidang hamparan susunan piramida piringan kartu tumpukan berlapis mendalam yang merayap maju-mundur di sumbu z-index (Stack widget element).
      child: Stack(
        children: [
          // Tata tumpukan level satu/Terendah: Area pementasan sentral pertunjukan wujud utama pelukis rupa cermin muka pemakainya (main profile picture renderer).
          GestureDetector(
            // Melatih ketanggapan kulit sentuh ketukan pendek beraksi gesit menyelenggarakan pertunjukan bursa menu opsi jepret [ _onPickAvatar ] namun sekadar hanya tatkala pintu perizinan direstui (enabled).
            onTap: enabled ? _onPickAvatar : null,
            // Perisai kustom pembungkus mesin jagoan perender lukisan image ajaib yang mampu meredam turbulensi gangguan url (SkyImage).
            child: SkyImage(
              width: 80,
              height: 80,
              // Mencanangkan titah keras ketetapan memahat wujud potongan rupa kanvas gambar harus dipapas melingkar sirkuler bujur telur (Oval profile).
              shapeImage: ShapeImage.oval,
              // Nalar algoritma sumber pasokan muatan gambar visualnya: Pertama-tama cecap dahulu sedotan string berkas jalurnya.
              // Jikalau [imagePath] nyata isinya, cerna. Namun andai meleset alpa/null, segera tengok pundi-pundi jejak sandi nama peninggalannya ([namePlaceholder]). 
              // Jikalau terungkap pula nama abjad rupanya, racik kilat sketsa ukiran piringan inisialnya lewat campur tangan modul sulap instan `generateAvatarByName`.
              // Andai didera nasib naas seluruhnya mandul null memori fiktif ganda melompong, sematkan langsung pasak siluet raga bayangan anonim boneka tak berwajah milik `AppImages.imgPlaceholderUser`.
              src: imagePath ??
                  (namePlaceholder != null
                      ? MediaHelper.generateAvatarByName(
                          namePlaceholder.toString(),
                        )
                      : AppImages.imgPlaceholderUser),
            ),
          ),
          
          // Tata tumpukan level pertengahan/Kedua: Menerjunkan penerjun payung pernak-pernik tombol revisi penyunting aksesoris modifikasi peremajaan tampang muka (Edit badge floating).
          Container(
            // Merapatkan pangkalan persandarannya melipir tersudut diam menekan perbatasan daratan penjuru bagian lereng pantat sebelah kanan kanvas wadah besarnya (bottomRight).
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              // Menampung dan mendeteksi getaran sentuhan ketuk pemicuan ritual pemanggilan dewa bursa daftar kamera foto perombakan rupa [ _onPickAvatar ], selalu menimbang apakah palang gembok dalam keadan terbuka (`enabled`).
              onTap: enabled ? _onPickAvatar : null,
              // Manakala tuannya si pencetus desain (Developer) bersedia mengirim delegasi cetak biru modifikasi bodi tombol khusus lewat laci [editWidget], muat dia seutuhnya! 
              // Tapi bila abai melupakannya, kita buatkan bentukan wujud kulit cangkang bawaan generiknya (default fallback UI).
              child: editWidget ??
                  Container(
                    width: 24, // Menyita rongga mini sebatas bentang 24 dot mikro
                    height: 24,
                    padding: const EdgeInsets.all(4), // Meletakkan gabus spasi penahan bantalan sela tepi luar dari sentrum objek berjarak setara 4 lompatan titik.
                    decoration: BoxDecoration(
                      // Memulas pewarnaan tatanan dasar landasannya menuruti pasokan preferensi tuannya ([editBackgroundColor]), jikalau pun tiada maka disiram polosan Putih mulus.
                      color: editBackgroundColor ?? Colors.white,
                      // Mencukur papasan lekukan keempat penjuru tepi dinding membentuk kurva bundaran purna absolut (Sirkular drastis beringas 30 unit sudut bulat).
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      // Menebar pendar kabut bayangan maya halus ilusi 3D guna membedakan penempatan objek supaya melayang terpisah dengan dasar bumi pijakan gambar potretnya.
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2), // Kelabu kusam transparansi rendah embun
                          spreadRadius: 2, // Penjalaran pancaran aura bayang
                          blurRadius: 1, // Kepadatan pemudaran tepian kabut warna (Blur)
                        ),
                      ],
                    ),
                    // Menyisipkan gambar lukis ornamen ikon vektor bolpoin penyunting (`Icons.mode_edit`) asalkan sang majikan tak meninggalkan bingkisan ikon pusaka perubahnya sendiri dalam slot [editIcon].
                    child: editIcon ??
                        const Icon(
                          Icons.mode_edit,
                          size: 15.9,
                          color: Colors.black, // Penegasan tinta hitam tajam
                        ),
                  ),
            ),
          ),
          
          // Tata tumpukan level tambahan opsional: Menayangkan bentukan pentolan saklar pembasmian pencabutan kenangan potret wajah (X symbol) eksklusif
          // bila dan hanya bila terendus nyata keberadaan barang buktinya ([imagePath != null]) serta tak ada intrik titah politik pelarangan pencabutan daripadanya ([!hideRemove]).
          if (imagePath != null && !hideRemove)
            GestureDetector(
              // Menangkap keusilan telunjuk si pemilik guna membakar hangus eksekusi metode putus silaturahmi pencabutan riwayat (onRemoveImage)
              onTap: onRemoveImage,
              child: Container(
                // Diarahkan memusat seragam menghimpit tumpukan yang sedari tadi berdesakan padat yakni pada posisi sudut dasar lereng kanan bundaran profil (`bottomRight`).
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  // Memahat ukiran pertanda palang aral rintang perpisahan pedih tanda buang perobohan bekas wajah lewat ikonisasi `close_rounded`.
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15.9,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Fasilitas pemicu magis rutinitas perantara asinkronus rahasia sang layar bawah memancar `_onPickAvatar`, bertugas agung guna menggelar panggung tikar bentangan lipatan layar separuh dari telapak bawahan gawai (Bottom Sheet Menu).
  /// Ajang ini ialah kancah pameran loket lelang para kontestan penyumbang galeri berkas muasal citra (Berupa alternatif memburu dari mesin Kamera atau menyendok di Gudang Album Galeri tersimpan) yang kesemuanya dikomandoi utilitas `AttachmentsSourceBottomSheet`.
  Future<void> _onPickAvatar() async {
    // Mengeksekusi instruksi perikatan interupsi layar memanggil pahlawan alat penggeser menu lipatan `BottomSheetHelper.bar`.
    await BottomSheetHelper.bar(
      // Membawa bingkisan pertunjukan akbar sang hakim pialang penyaring media bernama komite `AttachmentsSourceBottomSheet`.
      child: AttachmentsSourceBottomSheet(
        // Menegakkan konstitusi pelarangan seleksi curang masif memborong rentengan potret gerbong banyak sekaligus (Wajib hukumnya memboyong satu portret tunggal semata).
        allowMultiple: false,
        // Menyulut instruksi kompresor kejam pengecil rupa beban resolusi gajah (Image Compression) demi mengikis muatan obesitas bobot megabyte berlebih sebelum dimasukkan database memori sistem.
        withImageCompression: true,
        // Menyerahkan mahkota piala berkas sang kampiun tunggal (File terpilih dari layar utilitas penyaringan bawah tersebut) merangsek menerobos tembus mengaliri muara sakral pipa utamanya (onAvatarSelected) di konstruktor.
        onAttachmentsSelected: onAvatarSelected,
        // Mencegat kekosongan hampa pada wadah corong serok ganda (Multiple Results) oleh sebab di atas tadi sistem seleksi ganda telah digembok ketat dimatikan (Dibiarkan kosong hampa logic).
        onMultipleAttachmentsSelected: (results) {},
      ),
    );
  }
}
