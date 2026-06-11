import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/config/themes/app_colors.dart';
import 'package:quran_player/ui/views/splash/splash_controller.dart';
import 'package:quran_player/ui/views/splash/widgets/mandala_painter_widget.dart';
import 'package:quran_player/ui/widgets/colored_status_bar.dart';

/// [SplashView] adalah representasi antarmuka visual (UI) paling pertama yang muncul saat startup aplikasi.
/// Principal Note: View ini terikat pada SplashController untuk mengkoordinasikan
/// state dan lifecycle perpindahan rute (routing) yang dikelola oleh GetX.
class SplashView extends GetView<SplashController> {
  /// Konstruktor bersifat konstan (const) untuk memberikan optimasi performa kompilasi pada widget.
  const SplashView({super.key});

  /// Deklarasi nama rute navigasi unik (route path) untuk menjangkau halaman Splash ini.
  static const String route = '/splash';

  /// Fungsi override pembentuk struktur widget visual Splash.
  @override
  Widget build(BuildContext context) {
    /// Mencari secara eksplisit (explicit find) instance untuk menjamin bahwa 
    /// controller sudah teregistrasi dengan benar sesaat sebelum view dirender.
    Get.find<SplashController>();

    // Membungkus layar dengan ColoredStatusBar agar warna bar status OS selaras dengan UI.
    return ColoredStatusBar(
      // Menggunakan Scaffold sebagai tulang punggung pondasi komponen Material
      child: Scaffold(
        // Konten diletakkan ke dalam satu Container dasar
        body: Container(
          /// Mengatur lebar container secara absolut untuk selalu memenuhi lebar layar.
          width: double.infinity,

          /// Mengatur tinggi container secara absolut untuk selalu memenuhi dimensi layar.
          height: double.infinity,

          /// Menggunakan gradien latar belakang linear yang premium 
          /// demi menghadirkan kesan spiritual, elegan, sekaligus modern.
          decoration: const BoxDecoration(
            // Menerapkan objek LinearGradient
            gradient: LinearGradient(
              // Titik mula pancaran gradien dari sudut kiri atas
              begin: Alignment.topLeft,
              // Titik akhir gradien memusat di kanan bawah
              end: Alignment.bottomRight,
              // Deret paduan warna dari biru pekat ke warna biru aksen tema utama
              colors: [
                Color(0xFF1E3C72),
                Color(0xFF2A5298),
                AppColors.primary,
              ],
            ),
          ),
          // Memakai mekanisme Stack agar widget dapat bertumpuk (layering)
          child: const Stack(
            // Memastikan penumpukan selalu diposisikan sentral (tengah) di sumbu X dan Y
            alignment: Alignment.center,
            children: [
              /// Layer bawah: Latar belakang animasi kustom berupa seni Mandala Painter (OP UI).
              MandalaPainterWidget(),

              /// Layer atas: Konten inti berupa teks dan ikon yang akan diletakkan tepat di pusat mandala.
              SplashContent(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bagian konten utama pada Splash screen sengaja dipisahkan menjadi widget tersendiri 
/// untuk menjaga kebersihan dan keterbacaan kode berprinsip SoC (Separation of Concerns).
class SplashContent extends StatelessWidget {
  /// Konstruktor statis konstan untuk entitas SplashContent.
  const SplashContent({super.key});

  /// Proses membina hierarki widget konten Splash.
  @override
  Widget build(BuildContext context) {
    // Menyusun elemen anak secara vertikal
    return Column(
      /// Mengatur penyelarasan tata letak elemen-elemen agar tertumpu simetris di tengah vertikal.
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Ikon bergaya modern yang merepresentasikan Kitab Suci Al-Quran, 
        /// diposisikan pada pusaran utama desain grafis mandala.
        const Icon(
          // Pemilihan ikon buku/baca dari bawaan material
          Icons.auto_stories,
          // Memberi skala dimensi lumayan besar agar menonjol
          size: 80,
          // Mewarnai cerah putih kontras atas dasar gradien biru
          color: Colors.white,
        ),

        /// Mengalokasikan sebuah ruang kosong (SizedBox) berjarak 16 piksel 
        /// guna memisahkan lambang ikon dengan tulisan.
        const SizedBox(height: 16),

        /// Menyisipkan nama aplikasi terjemahan (terlokalisasi) yang didukung gaya font solid & premium.
        Text(
          // Memanggil alias translasi bahasa berbasis lokasi perangkat
          'txt_quran_title'.tr,
          // Menyetel pusat rata paragraf menjadi tengah (center)
          textAlign: TextAlign.center,
          // Penyesuaian karakteristik rupa tipe teks
          style: const TextStyle(
            // Warna dasar huruf yang mencolok
            color: Colors.white,
            // Ukuran huruf dibesarkan ke poin 28
            fontSize: 28,
            // Penegasan ketebalan tipografi (Bold)
            fontWeight: FontWeight.bold,
            // Rentang ruang antara karakter sedikit dilebarkan (1.5)
            letterSpacing: 1.5,
            // Pemberian ornamen efek bayangan kecil agar mudah terbaca atas tekstur dasar
            shadows: [
              Shadow(
                // Kelembutan baur tepi dari bayangan
                blurRadius: 10,
                // Tingkat kepekatan atau kelir bayangan
                color: Colors.black26,
                // Jauh lemparan sudut kemiringan bayangan (jatuh di area bawah)
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
