import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [MandalaPainterWidget] menyediakan animasi latar belakang yang menenangkan.
/// Principal Note: Menggunakan CustomPaint untuk performa tinggi tanpa asset gambar.
class MandalaPainterWidget extends StatefulWidget {
  const MandalaPainterWidget({super.key});

  @override
  State<MandalaPainterWidget> createState() => _MandalaPainterWidgetState();
}

class _MandalaPainterWidgetState extends State<MandalaPainterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Animasi rotasi lambat selama 10 detik.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    unawaited(_animationController.repeat());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(400, 400),
          painter: MandalaPainter(_animationController.value),
        );
      },
    );
  }
}

/// [MandalaPainter] menggambar pola geometris spiritual secara matematis.
class MandalaPainter extends CustomPainter {
  MandalaPainter(this.rotation);
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.save();
    // Transformasi translasi ke titik tengah widget.
    canvas.translate(center.dx, center.dy);
    // Rotasi berdasarkan nilai progress animasi.
    canvas.rotate(rotation * 2 * math.pi);

    for (var i = 0; i < 8; i++) {
      // Rotasi 45 derajat untuk setiap segmen pola.
      canvas.rotate(math.pi / 4);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: 200, height: 200),
        paint,
      );
      canvas.drawCircle(Offset.zero, 100, paint);

      final petalPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.fill;

      // Menggambar bentuk kelopak menggunakan Oval.
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(100, 0), width: 150, height: 50),
        petalPaint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
