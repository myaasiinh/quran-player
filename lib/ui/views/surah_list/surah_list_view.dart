import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/about/about_view.dart';
import 'package:quran_player/ui/views/surah_detail/surah_detail_view.dart';
import 'package:quran_player/ui/views/surah_list/surah_list_controller.dart';
import 'package:quran_player/ui/widgets/base/state_view.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'package:quran_player/ui/widgets/sky_form_field.dart';

/// [SurahListView] adalah halaman utama untuk penjelajahan surah dalam aplikasi.
/// 
/// **Catatan Utama**: Menggunakan pola `GetView` dari GetX untuk memisahkan UI (Tampilan)
/// dan logika State (Model-View-ViewModel / MVVM).
class SurahListView extends GetView<SurahListController> {
  /// Konstruktor konstan untuk daftar surah.
  const SurahListView({super.key});
  
  /// Konstanta rute statis untuk navigasi ke halaman ini.
  static const String route = '/surah-list';

  @override
  Widget build(BuildContext context) {
    // Scaffold bertindak sebagai kerangka utama untuk desain visual halaman
    return Scaffold(
      // Mengizinkan latar belakang body (konten) mengisi hingga ke belakang AppBar
      extendBodyBehindAppBar: true,
      // AppBar kustom aplikasi, diatur menjadi transparan
      appBar: SkyAppBar.primary(
        // Judul aplikasi yang diterjemahkan dari file lokalisasi
        title: 'txt_quran_title'.tr,
        // Menyusun teks judul di tengah secara eksplisit
        centerTitle: true,
        // Latar belakang transparan agar menyatu dengan gradient body
        backgroundColor: Colors.transparent,
        // Daftar aksi di sebelah kanan AppBar
        actions: [
          // Tombol ikon profil pengguna
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            // Ketika ditekan, navigasi menuju halaman 'About'
            onPressed: () => Get.toNamed(AboutView.route),
          ),
        ],
      ),
      // Wadah pembungkus konten utama
      body: Container(
        // Latar belakang gradient untuk konsistensi desain yang elegan dengan Splash Screen
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Gradasi dimulai dari tengah atas
            begin: Alignment.topCenter,
            // Berakhir di tengah bawah
            end: Alignment.bottomCenter,
            // Perpaduan warna primer yang sedikit transparan ke warna latar permukaan (surface)
            colors: [
              context.colorScheme!.primary.withValues(alpha: 0.8),
              context.colorScheme!.surface,
            ],
          ),
        ),
        // Tata letak daftar secara vertikal
        child: Column(
          children: [
            // Jarak atas (SizedBox) untuk menghindari tumpang tindih konten dengan AppBar transparan
            const SizedBox(height: 100),
            // Kolom Input pencarian surah (Search Discovery) dengan bantalan horizontal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              // Field form kustom
              child: SkyFormField(
                // Placeholder teks pencarian yang diterjemahkan
                hint: 'txt_search_surah_hint'.tr,
                // Mengirimkan teks yang diketik ke fungsi pencarian di controller
                onChanged: controller.onSearch,
                // Ikon kaca pembesar di sebelah kiri field pencarian
                prefixWidget: const Icon(Icons.search, color: Colors.white70),
                // Gaya font input teks
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // Expanded agar daftar memakan seluruh sisa layar yang tersedia
            Expanded(
              // Widget reaktif dari GetX untuk mendengarkan perubahan state di controller
              child: Obx(
                () => StateView.component(
                  // Mengelola transisi state: Loading -> Success/Error/Empty
                  loadingEnabled: controller.isLoading,
                  // Mengaktifkan tampilan error jika isError dari controller bernilai true
                  errorEnabled: controller.isError,
                  // Mengaktifkan tampilan kosong jika daftar surah kosong
                  emptyEnabled: controller.isEmpty,
                  // Callback mencoba kembali jika terjadi error
                  onRetry: controller.getSurahList,
                  // ListView untuk membangun daftar surah
                  child: ListView.builder(
                    // Jarak tambahan di sekeliling daftar surah
                    padding:
                        const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                    // Total item yang akan dirender sebanyak panjang data
                    itemCount: controller.dataList.length,
                    // Pembangun tiap-tiap baris daftar
                    itemBuilder: (context, index) {
                      // Mengambil objek surah individual pada indeks tertentu
                      final surah = controller.dataList[index];
                      // Setiap item surah dibungkus dalam Container mirip Card dengan desain modern
                      return Container(
                        // Margin antar item
                        margin: const EdgeInsets.only(bottom: 12),
                        // Desain latar belakang dan sudut membulat untuk Card
                        decoration: BoxDecoration(
                          // Membuat sudut menjadi bulat
                          borderRadius: BorderRadius.circular(16),
                          // Gradasi warna lembut yang sedikit transparan untuk kesan modern
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.7),
                            ],
                          ),
                          // Efek bayangan halus agar Card tampak melayang
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        // ListTile mengatur konten baris (kiri, tengah, kanan)
                        child: ListTile(
                          // Ruang bantalan internal Card
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          // Ikon sebelah kiri (Angka Urutan Surah)
                          leading: SurahNumberAvatar(number: surah.number ?? 0),
                          // Judul tengah (Nama Surah Bahasa Latin/Inggris)
                          title: Text(
                            surah.englishName ?? '',
                            // Gaya tipografi tebal
                            style: context.typography.body1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          // Subjudul (Tipe Turunnya Surah Makkiyah/Madaniyah dan Jumlah Ayat)
                          subtitle: Text(
                            // Logika penerjemahan tipe pewahyuan surah
                            '${surah.revelationType == 'Meccan' ? 'txt_meccan'.tr : 'txt_medinan'.tr} • ${surah.numberOfAyahs} ${'txt_ayahs'.tr}',
                            // Gaya teks subjudul sedikit redup
                            style: context.typography.body2
                                .copyWith(color: Colors.black54),
                          ),
                          // Ikon di sisi paling kanan (Nama Surah Berbahasa Arab)
                          trailing: Text(
                            surah.name ?? '',
                            // Menggunakan gaya teks dekoratif Arab berwarna primer
                            style: context.typography.headline3.copyWith(
                              color: context.colorScheme!.primary,
                              fontSize: 20,
                            ),
                          ),
                          // Aksi saat Card surah ditekan
                          onTap: () {
                            // Navigasi asinkron ke detail surah, dengan membuang (unawait) prospek asinkronnya
                            unawaited(
                              Get.toNamed(
                                // Memanggil rute ke halaman Detail Surah
                                SurahDetailView.route,
                                // Melemparkan data (argumen) objek surah ke halaman tujuan
                                arguments: surah,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `SurahNumberAvatar` adalah Widget kecil (komponen) statis untuk menampilkan 
/// nomor urut surah di dalam lingkaran dengan desain sirkular gradient warna primer.
class SurahNumberAvatar extends StatelessWidget {
  /// Konstruktor untuk widget avatar angka surah.
  const SurahNumberAvatar({required this.number, super.key});
  
  /// Nomor surah yang akan dicetak di dalam lingkaran.
  final int number;

  @override
  Widget build(BuildContext context) {
    // Wadah berukuran tetap yang akan menampung angka
    return Container(
      width: 45, // Lebar lingkaran
      height: 45, // Tinggi lingkaran
      decoration: BoxDecoration(
        // Menentukan bentuk wadah menjadi lingkaran murni
        shape: BoxShape.circle,
        // Gradien warna linear dari skema warna tema
        gradient: LinearGradient(
          colors: [
            context.colorScheme!.primary,   // Warna mulai gradasi
            context.colorScheme!.secondary, // Warna akhir gradasi
          ],
        ),
      ),
      // Memposisikan angka dengan tepat di tengah lingkaran
      child: Center(
        // Merender angka tersebut sebagai Text
        child: Text(
          number.toString(),
          // Memberi warna font putih terang dengan ketebalan bold
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
