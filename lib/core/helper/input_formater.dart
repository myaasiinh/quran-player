import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInputFormatters {
  static List<TextInputFormatter>? idrCurrency = [
    FilteringTextInputFormatter.digitsOnly,
    CurrencyInputFormatter(),
  ];
}

class CurrencyInputFormatter extends TextInputFormatter {
  static TextEditingValue defaultFormat(String text) {
    return CurrencyInputFormatter().formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: text),
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text == '0') {
      return newValue;
    }
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final value = double.parse(newValue.text);
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final newText = formatter.format(value);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
