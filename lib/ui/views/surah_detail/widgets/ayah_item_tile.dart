import 'package:flutter/material.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';

/// [AyahItemTile] merender satu baris ayat dengan desain yang menonjolkan
/// status ayat yang sedang aktif diputar.
class AyahItemTile extends StatelessWidget {
  const AyahItemTile({
    required this.ayah,
    required this.isCurrent,
    required this.onTap,
    super.key,
  });

  final AyahModel ayah;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // Desain dinamis: Berubah warna dan border jika ayat sedang aktif (isCurrent).
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isCurrent
            ? context.colorScheme!.primary.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.7),
        border: isCurrent
            ? Border.all(color: context.colorScheme!.primary, width: 2)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        // Menampilkan nomor ayat dalam lingkaran sirkular.
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? context.colorScheme!.primary : Colors.black12,
          ),
          child: Center(
            child: Text(
              ayah.numberInSurah.toString(),
              style: TextStyle(
                color: isCurrent ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        // Teks ayat dengan perataan kanan (Arabic standard) dan tipografi headline.
        title: Text(
          ayah.text ?? '',
          textAlign: TextAlign.right,
          style: context.typography.headline3.copyWith(
            color: isCurrent ? context.colorScheme!.primary : Colors.black87,
            height: 1.8, // Spasi baris untuk kenyamanan membaca teks Arab.
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
