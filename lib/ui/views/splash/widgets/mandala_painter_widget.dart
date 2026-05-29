import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [MandalaPainterWidget] menyediakan animasi latar belakang yang menenangkan.
/// Principal Note: Menggunakan CustomPaint untuk performa tinggi tanpa asset gambar.
class MandalaPainterWidget extends StatefulWidget {
  /// Konstruktor konstan untuk MandalaPainterWidget.
  const MandalaPainterWidget({super.key});

  @override
  State<MandalaPainterWidget> createState() => _MandalaPainterWidgetState();
}

class _MandalaPainterWidgetState extends State<MandalaPainterWidget>
    with SingleTickerProviderStateMixin {
  /// Controller untuk menggerakkan animasi rotasi.
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    /// Inisialisasi animasi rotasi lambat selama 10 detik secara berulang.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    /// Menjalankan animasi secara rekursif (repeat).
    unawaited(_animationController.repeat());
  }

  @override
  void dispose() {
    /// Melepaskan resource controller saat widget dihancurkan.
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// AnimatedBuilder memastikan widget hanya rebuild bagian yang diperlukan.
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          /// Ukuran kanvas untuk menggambar mandala.
          size: const Size(400, 400),

          /// Objek painter yang menangani logika rendering matematika.
          painter: MandalaPainter(_animationController.value),
        );
      },
    );
  }
}

/// [MandalaPainter] menggambar pola geometris spiritual secara matematis.
class MandalaPainter extends CustomPainter {
  /// Konstruktor dengan nilai rotasi dari animation controller.
  MandalaPainter(this.rotation);

  /// Nilai rotasi dari 0.0 sampai 1.0.
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    /// Menentukan titik pusat kanvas.
    final center = Offset(size.width / 2, size.height / 2);

    /// Konfigurasi kuas untuk menggambar garis tepi (stroke).
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    /// Menggunakan cascade untuk efisiensi pemanggilan metode pada canvas.
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(rotation * 2 * math.pi);

    for (var i = 0; i < 8; i++) {
      /// Rotasi 45 derajat (pi/4) untuk setiap segmen pola.
      /// Menggunakan cascade untuk menggambar elemen geometris.
      canvas
        ..rotate(math.pi / 4)
        ..drawRect(
          Rect.fromCenter(center: Offset.zero, width: 200, height: 200),
          paint,
        )
        ..drawCircle(Offset.zero, 100, paint);

      /// Konfigurasi kuas untuk mengisi bentuk (fill).
      final petalPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.fill;

      /// Menggambar bentuk kelopak menggunakan Oval secara radial dengan cascade.
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(100, 0), width: 150, height: 50),
        petalPaint,
      );
    }

    /// Mengembalikan state kanvas ke kondisi sebelum transformasi.
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    /// Selalu repaint karena nilai rotasi terus berubah.
    return true;
  }
}
