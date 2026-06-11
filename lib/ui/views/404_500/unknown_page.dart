import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_player/core/extension/context_extension.dart';

/// [unknownPage] adalah sebuah getter yang mengembalikan konfigurasi route halaman untuk menangani 
/// rute yang tidak terdaftar (biasanya diistilahkan dengan HTTP 404 Not Found).
/// 
/// Catatan Utama (Principal Note): Rute ini didesain dengan tema Islami untuk memberikan 
/// petunjuk jalan yang benar saat pengguna mengalami salah navigasi (tersesat) di dalam aplikasi.
GetPage<dynamic> get unknownPage {
  return GetPage(
    // Mendefinisikan nama path khusus untuk kondisi tidak diketahui
    name: '/unknown',
    // Mengarahkan rendering ke kelas widget [UnknownView]
    page: UnknownView.new,
  );
}

/// Kelas [UnknownView] menampilkan antarmuka pesan kesalahan (error view) saat halaman tidak ditemukan.
/// 
/// Merupakan widget tak berstatus (Stateless) yang menyuguhkan panduan desain yang seragam
/// dan menenangkan bagi pengguna ketika ada tautan aplikasi yang cacat/putus.
class UnknownView extends StatelessWidget {
  /// Konstruktor standar untuk [UnknownView].
  const UnknownView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Scaffold untuk kerangka struktural paling dasar
    return Scaffold(
      // Tubuh scaffold (konten) yang menutupi keseluruhan dimensi perangkat
      body: Container(
        // Melebarkan wadah (container) hingga penuh mengisi horizontal layar
        width: double.infinity,
        // Dekorasi untuk membuat latar belakang menjadi gradasi linear
        decoration: BoxDecoration(
          // Mendefinisikan warna latar yang perlahan membaur (gradient)
          gradient: LinearGradient(
            // Mulai gradasi dari pojok kiri atas
            begin: Alignment.topLeft,
            // Berakhir di pojok kanan bawah
            end: Alignment.bottomRight,
            // Daftar paduan warna gradasi
            colors: [
              // Mengambil warna utama dari tema, dimudarkan sedikit menjadi 10%
              context.colorScheme!.primary.withValues(alpha: 0.1),
              // Warna dasar permukaan (surface) standar aplikasi
              context.colorScheme!.surface,
            ],
          ),
        ),
        // Memberikan ruang pemisah yang luas di setiap sisinya (32 piksel)
        padding: const EdgeInsets.all(32),
        // Menata komponen di tengah secara vertikal (kolom)
        child: Column(
          // Posisikan semua konten di pusat layar secara tegak lurus
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Ikon Kompas / Penunjuk Arah (Bimbingan Spiritual).
            /// Mengisyaratkan bahwa pengguna butuh bantuan untuk kembali.
            Icon(
              Icons.explore_off_rounded,
              // Ukuran ikon super besar (100)
              size: 100,
              // Warna utama dibuat lebih pucat sebesar 60%
              color: context.colorScheme!.primary.withValues(alpha: 0.6),
            ),
            // Memberikan jarak vertikal
            const SizedBox(height: 16),

            /// Branding identitas judul Al-Quran Premium (Senada gaya layar Splash).
            /// Catatan Utama (Principal Note): Dibuat lebih kontras agar identitas (branding) 
            /// aplikasi tetap terlihat berkesan dan jelas di halaman 404.
            Text(
              // Terjemahan judul Al-Quran
              'txt_quran_title'.tr,
              // Posisi tulisan diatur agar simetris di tengah
              textAlign: TextAlign.center,
              // Memodifikasi tipografi asli (Headline3)
              style: context.typography.headline3.copyWith(
                // Warna primer 70%
                color: context.colorScheme!.primary.withValues(alpha: 0.7),
                // Font dibuat menjadi tebal (bold)
                fontWeight: FontWeight.bold,
                // Memberikan jarak regang antar huruf agar tampak elegan
                letterSpacing: 4,
              ),
            ),
            // Jarak yang lebih jauh
            const SizedBox(height: 32),

            /// Teks pemberitahuan bahwa halaman tidak ditemukan (Not Found).
            Text(
              // Terjemahan dari string 'Tidak Ditemukan'
              'txt_not_found'.tr,
              // Tulisan di tengah
              textAlign: TextAlign.center,
              // Mengubah gaya Headline3
              style: context.typography.headline3.copyWith(
                fontWeight: FontWeight.bold,
                // Warna primer penuh agar cukup mencolok
                color: context.colorScheme!.primary,
              ),
            ),
            const SizedBox(height: 16),

            /// Kutipan Ayat Al-Quran tematik untuk 404 (QS. Al-Fatihah: 6).
            /// Mengajak secara halus untuk memohon petunjuk.
            const Text(
              '"Tunjukkanlah kami jalan yang lurus."',
              textAlign: TextAlign.center,
              // Gaya kutipan miring (italic)
              style: TextStyle(
                fontStyle: FontStyle.italic,
                // Warna abu-abu yang lebih tenang
                color: Colors.black54,
                // Ukuran font standar
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            /// Teks Deskripsi Error (Dalam bahasa Indonesia).
            const Text(
              'Maaf, halaman yang Anda cari tidak tersedia atau telah dipindahkan.',
              textAlign: TextAlign.center,
              // Warna pudar agar tidak mendistraksi
              style: TextStyle(color: Colors.black45),
            ),
            const SizedBox(height: 48),

            /// Tombol navigasi aksi untuk kembali ke jalan yang benar (Halaman Beranda).
            ElevatedButton.icon(
              // Membersihkan seluruh tumpukan riwayat halaman dan memuat halaman beranda (/surah-list)
              onPressed: () => Get.offAllNamed('/surah-list'),
              // Ikon yang menyatakan kepulangan/Home
              icon: const Icon(Icons.home_rounded),
              // Label instruksi
              label: const Text('Kembali ke Beranda'),
              // Kustomisasi visual dari tombol melayang
              style: ElevatedButton.styleFrom(
                // Tombol berwarna dominan (primary)
                backgroundColor: context.colorScheme!.primary,
                // Teks berwarna terang (putih)
                foregroundColor: Colors.white,
                // Membuat tombol lebih montok (padding disesuaikan)
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                // Sudut tombol dibulatkan (radius 12)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
