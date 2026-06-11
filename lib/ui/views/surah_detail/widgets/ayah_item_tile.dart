import 'package:flutter/material.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';

/// [AyahItemTile] merender satu baris ayat dengan desain premium.
/// 
/// **Catatan Utama**: Memperbaiki kontras warna saat highlight aktif (isCurrent).
/// Menggunakan warna emas (Secondary) untuk teks Arab saat background kartu 
/// berubah menjadi biru (Primary).
class AyahItemTile extends StatelessWidget {
  /// Konstruktor konstan untuk komponen baris ayat.
  const AyahItemTile({
    required this.ayah,
    required this.isCurrent,
    required this.onTap,
    super.key,
  });

  /// Model data tunggal yang menyimpan informasi tentang satu ayat (teks Arab, terjemahan, dll).
  final AyahModel ayah;
  
  /// Penanda boolean apakah ayat ini adalah ayat yang saat ini sedang diputar (aktif).
  final bool isCurrent;
  
  /// Fungsi panggilan balik (callback) yang akan dieksekusi saat baris ini ditekan oleh pengguna.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Membungkus dengan AnimatedContainer agar transisi pergantian status aktif/non-aktif menjadi halus (smooth).
    return AnimatedContainer(
      // Durasi animasi transisi selama 300 milidetik
      duration: const Duration(milliseconds: 300),
      // Jarak margin di bagian bawah agar ada pemisah antar ayat
      margin: const EdgeInsets.only(bottom: 12),

      /// Desain kartu dinamis: Background menjadi Primary saat aktif.
      decoration: BoxDecoration(
        // Melengkungkan sudut bingkai kartu (rounded corners) sebesar 16 piksel
        borderRadius: BorderRadius.circular(16),
        // Mewarnai latar belakang kartu:
        // Jika ayat aktif, warna menjadi biru gelap agak transparan (Primary with alpha)
        // Jika tidak aktif, warnanya putih bersih
        color: isCurrent
            ? context.colorScheme!.primary.withValues(alpha: 0.9)
            : Colors.white,
        // Memberikan garis batas (border):
        // Garis emas tebal jika ayat aktif, atau garis abu-abu tipis jika tidak aktif
        border: isCurrent
            ? Border.all(color: context.colorScheme!.secondary, width: 2)
            : Border.all(color: Colors.black.withValues(alpha: 0.05)),
        // Memberikan efek bayangan (shadow) hanya saat ayat aktif agar terkesan mengambang/pop-out
        boxShadow: [
          if (isCurrent)
            BoxShadow(
              color: context.colorScheme!.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4), // Bayangan jatuh ke bawah
            ),
        ],
      ),
      // Konten aktual di dalam kotak (Card), menggunakan komponen standar ListTile
      child: ListTile(
        // Bantalan/jarak internal di sekeliling teks dan ikon
        contentPadding: const EdgeInsets.all(16),

        /// Nomor ayat dengan bentuk lingkaran yang memiliki kontras warna responsif.
        leading: Container(
          // Ukuran tetap untuk lingkaran nomor ayat
          width: 36,
          height: 36,
          // Dekorasi pembentuk lingkaran
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Jika aktif berwarna Emas (Secondary), jika non-aktif abu-abu transparan
            color: isCurrent ? context.colorScheme!.secondary : Colors.black12,
          ),
          // Memosisikan nomor tepat di bagian tengah (Center) lingkaran
          child: Center(
            child: Text(
              // Menampilkan nomor urut ayat dalam surah yang dikonversi menjadi string
              ayah.numberInSurah.toString(),
              style: TextStyle(
                // Warna teks kontras terhadap latar lingkarannya
                color: isCurrent ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.bold, // Ditebalkan agar mudah dibaca
                fontSize: 12, // Ukuran teks nomor ayat
              ),
            ),
          ),
        ),

        /// Teks Arab dengan warna emas (Secondary) saat highlight aktif 
        /// agar tidak 'tumpang tindih' atau kurang terlihat dengan background biru gelap.
        title: Text(
          // Teks aksara Arab dari model, gunakan string kosong jika null
          ayah.text ?? '',
          // Teks Arab harus rata kanan (right-aligned) sesuai standar penulisan hijaiyah
          textAlign: TextAlign.right,
          // Menurunkan gaya tipografi kustom dari tema (headline3)
          style: context.typography.headline3.copyWith(
            // Pewarnaan teks teks: Emas (Secondary) jika aktif, Hitam pekat jika normal
            color: isCurrent ? context.colorScheme!.secondary : Colors.black87,
            // Jarak spasi vertikal antar baris teks diperlebar (height 1.8) agar harakat tidak saling tumpuk
            height: 1.8,
            // Jika aktif, teks diberi bobot lebih tebal (bold)
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            // Menambahkan efek bayangan halus pada teks Arab saat aktif untuk mempertajam visibilitas
            shadows: [
              if (isCurrent)
                const Shadow(
                  blurRadius: 1, // Sedikit blur
                  color: Colors.black26, // Warna bayangan gelap semi-transparan
                  offset: Offset(0, 1), // Turun sedikit ke bawah
                ),
            ],
          ),
        ),
        // Menempelkan fungsi callback `onTap` ketika baris ayat ini disentuh pengguna
        onTap: onTap,
      ),
    );
  }
}
