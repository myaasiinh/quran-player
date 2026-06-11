import '/config/themes/default_typography.dart';
import 'package:flutter/material.dart';

/// Ekstensi tipe tata huruf kustom untuk aplikasi (Typography).
///
/// Digunakan apabila gaya tulisan kurang, berbeda, atau lebih kompleks dari 
/// [DefaultTypography] bawaan yang disediakan oleh sistem.
/// 
/// Tambahkan lebih banyak style teks di sini jika dibutuhkan.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  /// Konstruktor data model tata huruf (typography).
  const AppTypography({
    required this.headline1,
    required this.headline2,
    required this.headline3,
    required this.headline4,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.subtitle4,
    required this.body1,
    required this.body2,
    required this.body3,
    required this.small,
    required this.verySmall,
    required this.link,
  });
  
  /// Teks gaya headline 1 (Paling Besar)
  final TextStyle headline1;
  /// Teks gaya headline 2
  final TextStyle headline2;
  /// Teks gaya headline 3
  final TextStyle headline3;
  /// Teks gaya headline 4
  final TextStyle headline4;
  
  /// Teks gaya judul 1
  final TextStyle title1;
  /// Teks gaya judul 2
  final TextStyle title2;
  /// Teks gaya judul 3
  final TextStyle title3;
  /// Teks gaya judul 4
  final TextStyle title4;

  /// Teks gaya subjudul 1
  final TextStyle subtitle1;
  /// Teks gaya subjudul 2
  final TextStyle subtitle2;
  /// Teks gaya subjudul 3
  final TextStyle subtitle3;
  /// Teks gaya subjudul 4
  final TextStyle subtitle4;

  /// Teks gaya isi tubuh paragraf 1
  final TextStyle body1;
  /// Teks gaya isi tubuh paragraf 2
  final TextStyle body2;
  /// Teks gaya isi tubuh paragraf 3
  final TextStyle body3;
  
  /// Teks gaya berukuran kecil
  final TextStyle small;
  /// Teks gaya berukuran sangat kecil
  final TextStyle verySmall;

  /// Teks gaya bertautan URL
  final TextStyle link;

  /// Metode untuk menyalin konfigurasi dengan sedikit penggantian opsional.
  @override
  AppTypography copyWith({
    TextStyle? headline1,
    TextStyle? headline2,
    TextStyle? headline3,
    TextStyle? headline4,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? title4,
    TextStyle? subtitle1,
    TextStyle? subtitle2,
    TextStyle? subtitle3,
    TextStyle? subtitle4,
    TextStyle? body1,
    TextStyle? body2,
    TextStyle? body3,
    TextStyle? small,
    TextStyle? verySmall,
    TextStyle? link,
  }) {
    // Mereturn duplikasi obyek AppTypography dengan modifikasi yang diminta
    return AppTypography(
      headline1: headline1 ?? this.headline1,
      headline2: headline2 ?? this.headline2,
      headline3: headline3 ?? this.headline3,
      headline4: headline4 ?? this.headline4,
      title1: title1 ?? this.title1,
      title2: title2 ?? this.title2,
      title3: title3 ?? this.title3,
      title4: title4 ?? this.title4,
      subtitle1: subtitle1 ?? this.subtitle1,
      subtitle2: subtitle2 ?? this.subtitle2,
      subtitle3: subtitle3 ?? this.subtitle3,
      subtitle4: subtitle4 ?? this.subtitle4,
      body1: body1 ?? this.body1,
      body2: body2 ?? this.body2,
      body3: body3 ?? this.body3,
      small: small ?? this.small,
      verySmall: verySmall ?? this.verySmall,
      link: link ?? this.link,
    );
  }

  /// Metode transisi nilai (animasi) antara dua gaya tipografi.
  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    // Menghasilkan interpolasi linier (lerp) per atribut TextStyle di berbagai frame
    return AppTypography(
      headline1: TextStyle.lerp(headline1, other.headline1, t)!,
      headline2: TextStyle.lerp(headline2, other.headline2, t)!,
      headline3: TextStyle.lerp(headline3, other.headline3, t)!,
      headline4: TextStyle.lerp(headline4, other.headline4, t)!,
      title1: TextStyle.lerp(title1, other.title1, t)!,
      title2: TextStyle.lerp(title2, other.title2, t)!,
      title3: TextStyle.lerp(title3, other.title3, t)!,
      title4: TextStyle.lerp(title4, other.title4, t)!,
      subtitle1: TextStyle.lerp(subtitle1, other.subtitle1, t)!,
      subtitle2: TextStyle.lerp(subtitle2, other.subtitle2, t)!,
      subtitle3: TextStyle.lerp(subtitle3, other.subtitle3, t)!,
      subtitle4: TextStyle.lerp(subtitle4, other.subtitle4, t)!,
      body1: TextStyle.lerp(body1, other.body1, t)!,
      body2: TextStyle.lerp(body2, other.body2, t)!,
      body3: TextStyle.lerp(body3, other.body3, t)!,
      small: TextStyle.lerp(small, other.small, t)!,
      verySmall: TextStyle.lerp(verySmall, other.verySmall, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
    );
  }
}
