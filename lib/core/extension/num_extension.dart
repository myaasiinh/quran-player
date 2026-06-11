import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Ekstensi pada tipe angka ([num]) untuk mempermudah pembuatan spasi dan pemformatan mata uang.
extension NumExtension on num {
  /// Mengembalikan widget [SizedBox] dengan tinggi sesuai dengan nilai angka.
  /// Berguna untuk memberikan spasi vertikal antar widget.
  Widget get verticalSpacing => SizedBox(height: toDouble());

  /// Mengembalikan widget [SizedBox] dengan lebar sesuai dengan nilai angka.
  /// Berguna untuk memberikan spasi horizontal antar widget.
  Widget get horizontalSpacing => SizedBox(width: toDouble());

  /// Memformat angka ke dalam bentuk string mata uang.
  /// 
  /// Parameter opsional [symbol] untuk simbol mata uang (bawaan kosong).
  /// Parameter opsional [decimalDigit] untuk menentukan jumlah digit desimal (bawaan 0).
  /// Parameter opsional [locale] untuk preferensi bahasa (bawaan 'id').
  String currencyFormat({
    String symbol = '',
    int decimalDigit = 0,
    String locale = 'id',
  }) {
    final number = this;
    return NumberFormat.currency(
      locale: locale,
      decimalDigits: decimalDigit,
      symbol: symbol,
    ).format(number);
  }
}

/// Ekstensi pada tipe angka yang nullable ([num?]) untuk memformat string mata uang.
extension NumNullExtension on num? {
  /// Memformat angka ke dalam bentuk string mata uang (misalnya Rupiah).
  /// Jika angka bernilai null, maka akan dianggap sebagai 0.
  /// 
  /// Parameter opsional [symbol] untuk simbol mata uang (bawaan 'Rp. ').
  /// Parameter opsional [decimalDigit] untuk menentukan jumlah digit desimal (bawaan 0).
  /// Parameter opsional [locale] untuk preferensi bahasa (bawaan 'id').
  String currencyFormat({
    String symbol = 'Rp. ',
    int decimalDigit = 0,
    String locale = 'id',
  }) {
    final number = this ?? 0;
    return NumberFormat.currency(
      locale: locale,
      decimalDigits: decimalDigit,
      symbol: symbol,
    ).format(number);
  }
}
