import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Kelas utilitas yang berisi daftar format input kustom (CustomInputFormatters).
class CustomInputFormatters {
  /// Format input khusus untuk mata uang Rupiah (IDR).
  /// Memastikan hanya angka yang dapat diinput, lalu menerapkan format mata uang.
  static List<TextInputFormatter>? idrCurrency = [
    FilteringTextInputFormatter.digitsOnly,
    CurrencyInputFormatter(),
  ];
}

/// Pemformat teks (TextInputFormatter) untuk mengubah input angka 
/// menjadi format mata uang Rupiah secara langsung saat pengguna mengetik.
class CurrencyInputFormatter extends TextInputFormatter {
  /// Fungsi bantu untuk menghasilkan nilai teks dengan format mata uang bawaan.
  /// 
  /// Berguna ketika ingin mengatur nilai awal (default) pada sebuah form input.
  static TextEditingValue defaultFormat(String text) {
    return CurrencyInputFormatter().formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: text),
    );
  }

  /// Override metode pembaharuan edit dari [TextInputFormatter].
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika nilai sebelumnya '0', pertahankan nilai baru tanpa perubahan ekstra.
    if (oldValue.text == '0') {
      return newValue;
    }
    // Jika kursor berada di posisi awal, kembalikan nilai baru.
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Mengonversi teks ke format angka double untuk diformat.
    final value = double.parse(newValue.text);
    
    // Konfigurasi format mata uang menggunakan package intl:
    // Locale: Indonesia ('id'), simbol: 'Rp ', tanpa angka desimal.
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    
    // Terapkan format pada nilai angka yang diinput
    final newText = formatter.format(value);
    
    // Mengembalikan nilai baru yang sudah diformat beserta pembaruan posisi kursor.
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
