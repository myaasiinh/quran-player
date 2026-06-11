import 'package:flutter/material.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget kontainer serbaguna yang menyediakan dekorasi standar
/// seperti border radius, bayangan (box shadow), padding, margin, 
/// serta mendukung interaksi tap (klik) dan pembungkus berupa [Card].
class SkyBox extends StatelessWidget {
  /// Konstruktor untuk widget [SkyBox].
  const SkyBox({
    required this.child,
    super.key,
    this.margin,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.onPressed,
    this.color,
    this.gradient,
    this.borderColor,
    this.elevation = 4,
    this.boxShadow,
    this.enabledCard = true,
  });

  /// Widget konten yang akan ditempatkan di dalam [SkyBox].
  final Widget? child;

  /// Jarak (margin) luar dari widget ini.
  final EdgeInsetsGeometry? margin;

  /// Jarak (padding) dalam kontainer sebelum konten utama.
  /// Nilai default adalah `EdgeInsets.all(8)`.
  final EdgeInsetsGeometry? padding;

  /// Radius lengkungan sudut kontainer.
  /// Nilai default adalah `12`.
  final double? borderRadius;

  /// Lebar spesifik untuk kontainer.
  final double? width;

  /// Tinggi spesifik untuk kontainer.
  final double? height;

  /// Callback yang dipanggil saat kontainer diketuk.
  final VoidCallback? onPressed;

  /// Warna latar belakang untuk kontainer atau [Card].
  final Color? color;

  /// Warna batas pinggiran (border) kontainer.
  /// Nilai default adalah `Colors.grey.shade300`.
  final Color? borderColor;

  /// Efek gradien warna latar belakang kontainer.
  final Gradient? gradient;

  /// Ketinggian bayangan jika [enabledCard] bernilai `true`.
  /// Nilai default adalah `4`.
  final double elevation;

  /// Daftar efek bayangan kustom untuk kontainer.
  final List<BoxShadow>? boxShadow;

  /// Jika bernilai `true`, kontainer utama akan dibungkus dengan widget [Card].
  /// Jika `false`, hanya merender [Container] di dalam [InkWell].
  final bool enabledCard;

  @override
  Widget build(BuildContext context) {
    // Membangun body berupa InkWell + Container yang didekorasi
    final Widget body = InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        padding: padding ?? const EdgeInsets.all(8),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade300,
          ),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );

    // Jika enabledCard true, bungkus body di dalam Card
    if (enabledCard) {
      return Card(
        color: color,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        elevation: elevation,
        child: body,
      );
    } else {
      // Jika tidak, cukup kembalikan body biasa
      return body;
    }
  }
}
