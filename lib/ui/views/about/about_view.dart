import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/about/about_controller.dart';
import 'package:quran_player/ui/widgets/sky_appbar.dart';

/// Kelas [AboutView] adalah sebuah halaman antarmuka pengguna (UI) yang bertugas 
/// menampilkan informasi profil pengembang dan rincian lisensi aplikasi (Tentang Aplikasi/Pembuat).
///
/// Principal Note: Menggunakan layout `SingleChildScrollView` (scroll tunggal) 
/// untuk menjamin seluruh konten tetap leluasa dapat di-scroll dan diakses dengan baik 
/// sekalipun dijalankan pada layar perangkat berukuran kecil atau dalam mode horizontal (landscape).
class AboutView extends GetView<AboutController> {
  /// Konstruktor inisiasi konstan untuk kelas visual [AboutView].
  const AboutView({super.key});

  /// Deklarasi jalur nama rute (route name) konstan `/about` yang memudahkan penavigasian antar halaman secara terstruktur.
  static const String route = '/about';

  /// Metode turunan (override) [build] yang menyusun hierarki kerangka visual/widget di kanvas layar.
  @override
  Widget build(BuildContext context) {
    // Widget Scaffold menyediakan kerangka visual dasar standar ala Material Design (mengelola appbar, warna dasar, posisi, dsb).
    return Scaffold(
      // Menyediakan bilah navigasi header (SkyAppBar) berjenis kustom sekunder.
      // Bagian judulnya mengadopsi hasil terjemahan dari kata kunci bahasa 'txt_about_me'.
      appBar: SkyAppBar.secondary(
        title: 'txt_about_me'.tr,
      ),
      // Body seluruhnya dibungkus dengan view yang bisa di-scroll guna meminimalisir risiko area terpotong (overflow pixel) 
      // seandainya tinggi rentetan komponen melebihi tinggi layar utamanya.
      body: SingleChildScrollView(
        // Memberikan kelegaan ruang spasi nafas internal (padding) sebesar 24 piksel seragam di semua sisi (atas, bawah, kiri, kanan).
        padding: const EdgeInsets.all(24),
        // Widget Column menjejerkan dan mengurutkan anak-anak (children) elemennya ke arah bawah secara vertikal.
        child: Column(
          children: [
            // Bagian khusus Representasi Visual Profil Pengembang berupa avatar bundar yang diposisikan merata di tengah area.
            const Center(
              // Widget CircleAvatar bertindak praktis mengotomatiskan pembentukan latar grafis melingkar ibarat potret foto profil pengguna
              child: CircleAvatar(
                // Mengatur besaran radius (jari-jari) lingkaran sebesar 60 piksel
                radius: 60,
                // Mengatur warna latar pengisi bangun lingkarannya dengan rona warna kebiruan terang (blueAccent)
                backgroundColor: Colors.blueAccent,
                // Merender teks inisial 'MYH' persis di pusat poros bulatan avatar
                child: Text(
                  'MYH',
                  // Menentukan pemodelan gaya huruf untuk inisial teks tersebut
                  style: TextStyle(
                    fontSize: 40, // Menetapkan besaran tingkat ukuran font agar sangat besar dan mudah dilirik
                    color: Colors.white, // Menyapukan pewarnaan pada huruf dengan rona putih cerah
                    fontWeight: FontWeight.bold, // Dicetak dengan pola tebal/bold agar terlihat tegas mendominasi
                  ),
                ),
              ),
            ),
            // Mengalokasikan sela pemisah/jarak vertikal (SizedBox) setinggi 24 piksel dengan objek di bawahnya.
            const SizedBox(height: 24),
            
            // Kolom visual untuk Menampilkan Entitas Nama Lengkap Pengembang.
            Text(
              // Mengekstrak pengembalian nilai nama pengarang secara statik/dinamis dari jembatan logic kontroler ([AboutController]).
              controller.authorName,
              // Mengadopsi pedoman gaya desain tipografi (context.typography.headline3) 
              // seraya menimpa ulang ketebalan hurufnya (fontWeight: FontWeight.bold) menggunakan extension context.
              style: context.typography.headline3
                  .copyWith(fontWeight: FontWeight.bold),
              // Menyelaraskan distribusi perataan teks tersebut dengan penempatan tegak simetris di sentrum (Tengah-Center).
              textAlign: TextAlign.center,
            ),
            // Sela vertikal yang tipis dan rapat setebal 8 piksel
            const SizedBox(height: 8),
            
            // Kolom visual untuk Mempublikasikan Info Alamat Surel (Email) Kontak.
            Text(
              // Mendapatkan properti nilai teks email dari referensi logic kontroler
              controller.authorEmail,
              // Menggunakan styling standar khusus porsi badan teks (body1) dengan penimpaan rona tulisan jadi warna kelabu
              style: context.typography.body1.copyWith(color: Colors.grey),
            ),
            // Spasi sela vertikal yang lebih melonggar tinggi yakni 32 piksel sebagai indikasi berpisahnya seksi perkenalan.
            const SizedBox(height: 32),
            
            // Menggambar satu garis lurus horizon pembatas antar bagian visual (Divider) 
            const Divider(),
            
            // Menyediakan luang spasi jeda sepanjang 16 piksel setelah berhentinya garis pemisah itu.
            const SizedBox(height: 16),
            
            // Segmen kolom yang memuat esai deskriptif atau latar belakang rincian fungsionalitas Proyek/Aplikasi.
            Text(
              // Mencetak string terjemahan bahasa dinamis internasionalisasi (.tr) dari rujukan kunci 'txt_about_description'.
              'txt_about_description'.tr,
              // Memberikan standar format pewarnaan/bentuk huruf untuk bagian bacaan utama (body1).
              style: context.typography.body1,
              // Tatanan penyusunan teks paragraf yang terdistribusi menutupi rata celah antara dinding pinggir kiri ke kanan (Justify).
              textAlign: TextAlign.justify,
            ),
            
            // Alokasi ruang kosong vertikal setinggi 32 piksel sebelum pindah area selanjutnya.
            const SizedBox(height: 32),
            
            // Menyusun deretan informasi pendukung (Legal and Info) lewat intervensi metode pembuat komponen eksternal.
            // Memanggil helper [_buildInfoTile] untuk membuat sel infografis soal regulasi hak cipta (license).
            _buildInfoTile(
              context,
              // Penetapan visual simbolis pelindungan terverifikasi
              icon: Icons.verified_user,
              // Menyuntikkan muatan teks berterjemahan (lokal) sesuai perbendaharaan 'txt_license'
              title: 'txt_license'.tr,
              // Membubuhi tulisan statik sub-keterangan mengenai tipe perjanjian hak pakainya.
              subtitle: 'MIT License',
            ),
            
            // Memanggil metode pembuat sel tile untuk mendefinisikan rincian kompilasi nomor rilis/versi perangkat lunak.
            _buildInfoTile(
              context,
              // Penetapan simbol visual pemberitahuan yang menunjang info
              icon: Icons.info_outline,
              // Judul teks berterjemahan merujuk pada kata perbendaharaan 'txt_app_version'
              title: 'txt_app_version'.tr,
              // Menyisipkan realitas angka seri versi rilis software (appVersion) dengan mengambil di file config lewat controller.
              subtitle: controller.appVersion,
            ),
          ],
        ),
      ),
    );
  }

  /// Fungsi helper/pembantu internal bernama [_buildInfoTile] untuk menyusun kembali komponen berulangkali (Modular).
  ///
  /// Tujuan utamanya yakni menyingkat kepadatan penulisan kode sumber dan merapikan komponen berulang (Don't Repeat Yourself / DRY pattern).
  /// Modul mengharuskan ketersediaan pasokan konteks ([context]) buat menyarikan tema warna, serta diisi properti kunci: 
  /// desain grafis ikon ([icon]), teks primer baris utama ([title]), teks bawahan ekstra pendukung ([subtitle]).
  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    // Mewujudkan komponen bawaan list (ListTile) sebagai formasi tampilan barisan komplit yang proporsional 
    return ListTile(
      // Lokasi blok 'leading' yang bermukim di ujung kiri barisan, ditempati oleh ornamen ikon yang diwarnai mengikuti tema [primary].
      leading: Icon(icon, color: context.colorScheme!.primary),
      // Lokasi tengah atas (title) disediakan buat merender huruf bercetak tebal sebagai tajuk.
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      // Lokasi tengah bawah (subtitle) diperuntukkan menjabarkan rincian informasinya secara detail
      subtitle: Text(subtitle),
    );
  }
}
