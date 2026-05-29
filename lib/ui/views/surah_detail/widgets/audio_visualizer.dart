import 'dart:math' as math;
import 'package:flutter/material.dart';

/// [AudioVisualizerPainter] menggambar animasi bar audio yang dinamis.
/// Principal Note: Menggunakan algoritma gelombang sinus untuk mensimulasikan
/// pergerakan audio yang estetik saat musik diputar.
class AudioVisualizerPainter extends CustomPainter {
  AudioVisualizerPainter({
    required this.animationValue,
    required this.isPlaying,
    required this.color,
  });

  final double animationValue;
  final bool isPlaying;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const barCount = 30; // Jumlah bar visualizer.
    final spacing = size.width / barCount;
    final random = math.Random(42); // Seed konstan untuk stabilitas visual.

    for (var i = 0; i < barCount; i++) {
      final x = i * spacing;
      double height;

      if (isPlaying) {
        // Logika Gelombang: Menggabungkan sinus animasi dengan variasi acak per bar.
        final wave = math.sin((animationValue * 2 * math.pi) + (i * 0.5));
        height = (size.height * 0.3) +
            (wave * size.height * 0.2 * random.nextDouble());
      } else {
        // Saat dipause, bar tetap tampil namun mengecil (idle state).
        height = size.height * 0.1;
      }

      // Menggambar garis vertikal sebagai representasi gelombang audio.
      canvas.drawLine(
        Offset(x, size.height / 2 - height / 2),
        Offset(x, size.height / 2 + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioVisualizerPainter oldDelegate) {
    // Repaint hanya jika ada perubahan nilai animasi atau status playback.
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying;
  }
}
