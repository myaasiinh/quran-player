import 'package:flutter/material.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';

/// [AyahItemTile] merender satu baris ayat dengan desain premium.
/// Principal Note: Memperbaiki kontras warna saat highlight aktif (isCurrent).
/// Menggunakan warna emas (Secondary) untuk teks Arab saat background kartu berubah menjadi biru (Primary).
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),

      /// Desain kartu dinamis: Background menjadi Primary saat aktif.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isCurrent
            ? context.colorScheme!.primary.withValues(alpha: 0.9)
            : Colors.white,
        border: isCurrent
            ? Border.all(color: context.colorScheme!.secondary, width: 2)
            : Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          if (isCurrent)
            BoxShadow(
              color: context.colorScheme!.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        /// Nomor ayat dengan lingkaran kontras.
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? context.colorScheme!.secondary : Colors.black12,
          ),
          child: Center(
            child: Text(
              ayah.numberInSurah.toString(),
              style: TextStyle(
                color: isCurrent ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),

        /// Teks Arab dengan warna emas (Secondary) saat highlight aktif agar tidak 'tumpang tindih' dengan background biru.
        title: Text(
          ayah.text ?? '',
          textAlign: TextAlign.right,
          style: context.typography.headline3.copyWith(
            color: isCurrent ? context.colorScheme!.secondary : Colors.black87,
            height: 1.8,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            shadows: [
              if (isCurrent)
                const Shadow(
                  blurRadius: 1,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
