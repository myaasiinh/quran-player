import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:flutter/material.dart';

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
    return Card(
      color: isCurrent ? context.colorScheme!.primaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          child: Text(ayah.numberInSurah.toString()),
        ),
        title: Text(
          ayah.text ?? '',
          textAlign: TextAlign.right,
          style: context.typography.headline3,
        ),
        onTap: onTap,
      ),
    );
  }
}
