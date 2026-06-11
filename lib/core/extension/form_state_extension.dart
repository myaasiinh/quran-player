import 'package:flutter/material.dart';

/// Ekstensi pada `GlobalKey<FormState>` untuk mempermudah validasi dan penyimpanan form.
extension FormStateExtension on GlobalKey<FormState> {
  /// Menjalankan validasi form, dan jika berhasil divalidasi,
  /// maka fungsi penyimpanan form dijalankan.
  /// 
  /// Mengembalikan [true] jika form lolos validasi, jika tidak mengembalikan [false].
  bool saveAndValidate() {
    final form = currentState;
    if (form == null) return false;
    if (!form.validate()) return false;
    form.save();
    return true;
  }
}
