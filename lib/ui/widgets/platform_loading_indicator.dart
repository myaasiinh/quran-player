/// Widget yang menampilkan indikator loading yang sesuai dengan platform (Android atau iOS).
/// Ini akan menampilkan [CircularProgressIndicator] untuk Android dan [CupertinoActivityIndicator] untuk iOS.
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformLoadingIndicator extends StatelessWidget {
  /// Membuat instance [PlatformLoadingIndicator] baru.
  ///
  /// Parameter:
  /// - [key]: Kunci opsional untuk widget ini.
  /// - [color]: Warna opsional untuk indikator loading. Jika null, warna default platform akan digunakan.
  const PlatformLoadingIndicator({super.key, this.color});

  final Color? color; // Warna yang akan digunakan untuk indikator loading.

  @override
  /// Membangun UI widget berdasarkan konteks yang diberikan.
  /// Ini akan memilih indikator loading yang sesuai dengan platform saat ini.
  ///
  /// Parameter:
  /// - [context]: Konteks build dari widget.
  ///
  /// Mengembalikan:
  /// - Sebuah [Widget] yang merupakan indikator loading yang sesuai dengan platform.
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // Jika aplikasi berjalan di platform Android.
      return Center(
        child: CircularProgressIndicator(
          // Menampilkan indikator loading gaya Android.
          color: color,
        ),
      );
    } else {
      // Jika aplikasi berjalan di platform selain Android (misalnya iOS).
      return Center(
        child: CupertinoActivityIndicator(
          // Menampilkan indikator loading gaya iOS.
          radius: 16,
          color: color,
        ),
      );
    }
  }
}