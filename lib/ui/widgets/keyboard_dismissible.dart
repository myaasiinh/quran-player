import 'package:flutter/material.dart';

/// Widget yang digunakan untuk menyembunyikan keyboard secara otomatis
/// saat area di luar input teks (seperti [TextField]) diketuk oleh pengguna.
class KeyboardDismissible extends StatelessWidget {
  /// Konstruktor untuk widget [KeyboardDismissible].
  const KeyboardDismissible({required this.child, super.key});

  /// Widget child yang akan dibungkus oleh fitur dismiss keyboard ini.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Menyembunyikan (unfocus) keyboard saat area diketuk.
      onTap: () => FocusScope.of(context).focusedChild?.unfocus(),
      child: child,
    );
  }
}
