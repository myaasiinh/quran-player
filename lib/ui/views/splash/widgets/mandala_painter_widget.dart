import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Widget [MandalaPainterWidget] secara visual menyediakan animasi latar belakang berpola
/// mandala yang memberikan kesan menenangkan dan estetik pada antarmuka.
/// Principal Note: Sangat direkomendasikan karena menggunakan teknologi CustomPaint 
/// untuk merender grafis dengan performa tinggi secara on-the-fly tanpa perlu memuat file aset gambar eksternal (menghemat memori).
class MandalaPainterWidget extends StatefulWidget {
  /// Konstruktor konstan statis untuk [MandalaPainterWidget].
  const MandalaPainterWidget({super.key});

  /// Mengimplementasikan metode createState untuk membentuk alur logika stateful.
  @override
  State<MandalaPainterWidget> createState() => _MandalaPainterWidgetState();
}

/// Kelas implementasi State internal (private) yang mendampingi widget [MandalaPainterWidget].
/// Mewariskan kelas [SingleTickerProviderStateMixin] yang esensial untuk memberi denyut rotasi animasi (vsync).
class _MandalaPainterWidgetState extends State<MandalaPainterWidget>
    with SingleTickerProviderStateMixin {
  /// Instance [AnimationController] sebagai mesin yang menggerakkan dan mengatur nilai laju animasi rotasi grafis.
  late AnimationController _animationController;

  /// Metode inisialisasi awal siklus hidup state.
  @override
  void initState() {
    // Memanggil inisialisasi superclass.
    super.initState();

    // Membangun instansiasi AnimationController dengan durasi rotasi lambat 1 putaran penuh memakan waktu 10 detik.
    _animationController = AnimationController(
      // Parameter vsync menjaga sinkronisasi layar untuk efisiensi render (mencegah animasi berjalan saat off-screen).
      vsync: this,
      // Durasi 1 putaran (cycle) animasi
      duration: const Duration(seconds: 10),
    );

    // Memicu (trigger) controller animasi untuk berjalan dalam siklus yang tiada henti (repeat secara berkesinambungan).
    // Digunakan operator unawaited karena metode ini berjalan asynchronous dan tidak perlu ditunggu di void blok ini.
    unawaited(_animationController.repeat());
  }

  /// Metode siklus penghancuran state.
  @override
  void dispose() {
    // Mendealokasikan / membuang memori pemroses (dispose) [AnimationController] saat halaman/widget hilang 
    // agar mencegah kebocoran memori (memory-leak).
    _animationController.dispose();
    
    // Melanjutkan eksekusi metode dispose milik superclass.
    super.dispose();
  }

  /// Membangun pohon elemen yang mewakili UI antarmuka dari komponen ini.
  @override
  Widget build(BuildContext context) {
    // Membalut widget inti dalam blok [AnimatedBuilder] agar pengubahan state rendering hanya terjadi di tingkat lokalisasi ini (performa tinggi).
    return AnimatedBuilder(
      // Mentautkan controller rotasi kepada pembangun animasi.
      animation: _animationController,
      // Metode pembangun objek grafis berdasarkan pembaruan frame animasi.
      builder: (context, child) {
        // Melahirkan / membina kanvas lukisan spesifik (CustomPaint).
        return CustomPaint(
          // Membatasi ruang kanvas lukisan absolut dengan tinggi dan lebar konstan sebesar 400x400.
          size: const Size(400, 400),
          // Memanggil kelas pelukis mandala (painter) dan menyuntikkan (inject) kalkulasi rotasi waktu yang ter-update dari animasi.
          painter: MandalaPainter(_animationController.value),
        );
      },
    );
  }
}

/// [MandalaPainter] adalah kelas kustom yang meng-extends pelukis abstrak [CustomPainter].
/// Menggambar pola geometris bernuansa spiritual secara murni menggunakan kalkulasi matematis kanvas.
class MandalaPainter extends CustomPainter {
  /// Konstruktor kelas painter yang menerima parameter nilai fraksi siklus rotasi dari controller.
  MandalaPainter(this.rotation);

  /// Variabel representasi laju nilai rotasi dinamis. Bergerak dari 0.0 hingga nilai desimal 1.0.
  final double rotation;

  /// Algoritma inti pelukisan yang dieksekusi terus-menerus setiap kali terjadi repaint.
  @override
  void paint(Canvas canvas, Size size) {
    // Mengekstraksi letak titik tengah absolut (koordinat x,y) berdasar bentang kanvas untuk dijadikan sebagai jangkar (anchor).
    final center = Offset(size.width / 2, size.height / 2);

    // Mengkonfigurasi definisi struktur material kuas (brush/paint) untuk menggambar guratan outline garis luar (stroke).
    final paint = Paint()
      // Menseting transparansi warna (putih dengan alpha 10%)
      ..color = Colors.white.withValues(alpha: 0.1)
      // Menseting mode perlakuan sapuan (stroke)
      ..style = PaintingStyle.stroke
      // Menseting nilai ketebalan garis tepi
      ..strokeWidth = 1;

    // Memanfaatkan operasi berjenjang (cascade: ..) untuk optimalisasi perintah berlapis pada kanvas secara berurutan.
    canvas
      // Menyimpan keadaan state kanvas mula-mula
      ..save()
      // Mentranslasikan atau memindahkan letak titik acuan 0,0 kanvas secara harfiah ke posisi titik [center].
      ..translate(center.dx, center.dy)
      // Memberikan perputaran radikal dari 0 hingga 2 * pi (yaitu 360 derajat) yang dipengaruhi oleh nilai [rotation].
      ..rotate(rotation * 2 * math.pi);

    // Menggunakan blok loop (perulangan) sebanyak 8 kali untuk menyusun konfigurasi sisi geometris simetris 8 bagian.
    for (var i = 0; i < 8; i++) {
      // Memutar kanvas per tahapan sebesar sudut pi / 4 (setara 45 derajat) dengan metode kaskade.
      canvas
        // Instruksi pemutaran sebesar 45 derajat
        ..rotate(math.pi / 4)
        // Menggambar objek segi empat (Rect) yang memusat pada koordinat asal (setelah ditranslasikan) dengan ukuran 200x200
        ..drawRect(
          // Mendefinisikan bangun kotak / bujur sangkar di tengah 
          Rect.fromCenter(center: Offset.zero, width: 200, height: 200),
          // Menggunakan spesifikasi kuas outline
          paint,
        )
        // Menggambar cincin lengkungan (Circle) sempurna berpusat di tengah dengan radius 100
        ..drawCircle(Offset.zero, 100, paint);

      // Membentuk definisi kuas/material berbeda khusus mengisi area bentuk memusat (fill).
      final petalPaint = Paint()
        // Memberikan warna gradasi kelopak yang lebih pudar (putih alpha 5%)
        ..color = Colors.white.withValues(alpha: 0.05)
        // Memakai gaya pengisian warna solid pada bangun geometri
        ..style = PaintingStyle.fill;

      // Membuat siluet bangun kelopak (oval melonjong) yang digambar pada radius sejauh 100 dari poros utama.
      canvas.drawOval(
        // Area oval spesifik: sumbu X bergeser 100 px, memanjang elips mendatar (150) serta memendek vertikal (50).
        Rect.fromCenter(center: const Offset(100, 0), width: 150, height: 50),
        // Mewarnai memakai kuas jenis bunga kelopak
        petalPaint,
      );
    }

    // Melaksanakan perintah wajib memulihkan (restore) pengaturan kanvas (seperti rotasi dan translate) ke titik pemulihan pada ..save().
    canvas.restore();
  }

  /// Metode pemberitahuan untuk memberi sinyal pada engine apakah perlu dipanggil ulan siklus draw.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Karena grafik secara kontinyu perlu diputar seiring berubahnya timer nilai [rotation], 
    // sistem dipaksa mengembalikan [true] setiap frame untuk me-repaint terus menerus.
    return true;
  }
}
