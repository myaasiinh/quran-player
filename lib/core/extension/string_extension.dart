/// Ekstensi untuk String yang bernilai nullable ([String?]) 
/// guna menyediakan berbagai pengecekan dan manipulasi teks, 
/// seperti pengecekan null/kosong dan format nomor telepon.
extension StringNullExtension on String? {
  /// Mengecek apakah String bernilai null atau bernilai '0'.
  bool get isZeroOrEmpty {
    return this == null || this == '0';
  }

  /// Mengecek apakah String bernilai null, string kosong (''), atau teks 'null'.
  bool get isNullOrEmpty {
    return this == null || this == '' || this == 'null';
  }

  /// Mengecek apakah String tidak null, tidak kosong, dan bukan teks 'null'.
  bool get isNotNullAndNotEmpty {
    return this != null && this != '' && this != 'null';
  }

  /// Mengonversi nomor telepon ke dalam format lokal yang diawali dengan '0'.
  /// Contoh: '628...' atau '+628...' menjadi '08...'.
  String get to08Phone {
    if (toString().startsWith('62')) {
      return toString().replaceRange(0, 2, '0');
    } else if (toString().startsWith('+62')) {
      return toString().replaceRange(0, 3, '0');
    } else {
      return toString();
    }
  }

  /// Mengonversi nomor telepon ke dalam format kode negara Indonesia '62'.
  /// Contoh: '08...' menjadi '628...', dan '+628...' menjadi '628...'.
  String get to62Phone {
    if (toString().startsWith('08')) {
      return toString().replaceRange(0, 1, '62');
    } else if (toString().startsWith('+628')) {
      return toString().replaceRange(0, 2, '');
    } else {
      return toString();
    }
  }
}
