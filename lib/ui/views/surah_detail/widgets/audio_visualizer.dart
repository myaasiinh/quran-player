import 'dart:math' as math;
import 'package:flutter/material.dart';

/// [AudioVisualizerPainter] menggambar animasi bar audio yang dinamis.
/// Principal Note: Menggunakan algoritma gelombang sinus untuk mensimulasikan
/// pergerakan audio yang estetik saat musik diputar.
class AudioVisualizerPainter extends CustomPainter {
  /// Konstruktor untuk [AudioVisualizerPainter].
  /// Membutuhkan [animationValue] untuk mengatur animasi, [isPlaying] untuk
  /// status pemutaran, dan [color] untuk warna visualizer.
  AudioVisualizerPainter({
    required this.animationValue,
    required this.isPlaying,
    required this.color,
  });

  /// Nilai animasi yang berjalan (biasanya dari AnimationController).
  final double animationValue;
  
  /// Status apakah audio sedang dimainkan atau tidak.
  final bool isPlaying;
  
  /// Warna yang digunakan untuk menggambar bar visualizer.
  final Color color;

  /// Method [paint] dipanggil setiap kali visualizer perlu digambar ulang pada [canvas].
  @override
  void paint(Canvas canvas, Size size) {
    // Inisialisasi objek Paint dengan warna, ketebalan, dan bentuk ujung garis.
    final paint = Paint()
      ..color = color // Menetapkan warna paint sesuai dengan properti [color].
      ..strokeWidth = 3.0 // Menetapkan ketebalan garis bar menjadi 3.0.
      ..strokeCap = StrokeCap.round; // Membuat ujung garis membulat.

    const barCount = 30; // Jumlah bar visualizer yang akan digambar pada kanvas.
    // Menghitung jarak horizontal antar bar.
    final spacing = size.width / barCount;
    // Menggunakan objek Random dengan seed konstan (42) agar pola acaknya tetap stabil.
    final random = math.Random(42); 

    // Loop untuk menggambar masing-masing bar.
    for (var i = 0; i < barCount; i++) {
      // Menghitung posisi koordinat X untuk bar ke-i.
      final x = i * spacing;
      // Variabel untuk menyimpan tinggi bar saat ini.
      double height;

      // Jika audio sedang diputar (isPlaying = true), hitung gelombang animasi.
      if (isPlaying) {
        // Logika Gelombang: Menggabungkan fungsi sinus berdasarkan nilai animasi dan indeks bar.
        final wave = math.sin((animationValue * 2 * math.pi) + (i * 0.5));
        // Menentukan tinggi bar berdasarkan tinggi kanvas dasar, gelombang sinus, dan angka acak.
        height = (size.height * 0.3) +
            (wave * size.height * 0.2 * random.nextDouble());
      } else {
        // Saat dipause, bar tidak bergerak dan tinggi bar menjadi sangat kecil (idle state).
        height = size.height * 0.1;
      }

      // Menggambar garis vertikal sebagai representasi gelombang audio.
      // Garis ditarik dari titik Y atas ke titik Y bawah, berpusat di tengah kanvas secara vertikal.
      canvas.drawLine(
        Offset(x, size.height / 2 - height / 2), // Titik awal (atas bar)
        Offset(x, size.height / 2 + height / 2), // Titik akhir (bawah bar)
        paint, // Objek paint yang telah dikonfigurasi sebelumnya
      );
    }
  }

  /// Menentukan apakah [AudioVisualizerPainter] perlu menggambar ulang (repaint).
  /// Mengembalikan true jika ada perubahan pada [animationValue] atau [isPlaying].
  @override
  bool shouldRepaint(covariant AudioVisualizerPainter oldDelegate) {
    // Repaint hanya jika ada perubahan nilai animasi atau status pemutaran.
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying;
  }
}
