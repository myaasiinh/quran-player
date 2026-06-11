/// Ekstensi pada `List<T>` (nullable) untuk memberikan fungsi pengurutan (sorting) yang mudah.
extension ListNullExtension<T> on List<T>? {
  /// Mengurutkan list secara menaik (ascending) berdasarkan nilai kunci tertentu.
  /// 
  /// Parameter [keySelector] digunakan untuk memilih properti yang akan dijadikan acuan pengurutan.
  void sortAscBy<K extends Comparable<dynamic>>(K Function(T) keySelector) {
    this?.sort((a, b) {
      final keyA = keySelector(a);
      final keyB = keySelector(b);
      return keyA.compareTo(keyB);
    });
  }

  /// Mengurutkan list secara menurun (descending) berdasarkan nilai kunci tertentu.
  /// 
  /// Parameter [keySelector] digunakan untuk memilih properti yang akan dijadikan acuan pengurutan.
  void sortDescBy<K extends Comparable<dynamic>>(K Function(T) keySelector) {
    this?.sort((a, b) {
      final keyA = keySelector(a);
      final keyB = keySelector(b);
      return keyB.compareTo(keyA);
    });
  }
}

/// Ekstensi pada `Iterable<E>` untuk mempermudah pengelompokan data.
extension Iterables<E> on Iterable<E> {
  /// Mengelompokkan elemen-elemen ke dalam [Map] berdasarkan fungsi [keyFunction].
  /// 
  /// Setiap kunci (key) akan memiliki nilai berupa list elemen-elemen yang cocok dengan kunci tersebut.
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
        <K, List<E>>{},
        (map, element) =>
            map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
      );
}

/// Ekstensi pada `List<E>` untuk memfilter elemen agar menjadi unik.
extension Unique<E, Id> on List<E> {
  /// Mengembalikan list yang hanya berisi elemen-elemen unik (tidak ada duplikat).
  /// 
  /// Parameter opsional [id] digunakan jika kita ingin menentukan properti mana
  /// yang dijadikan acuan keunikan. Jika tidak diberikan, keunikan berdasarkan elemen itu sendiri.
  /// Parameter opsional [inplace] menentukan apakah list aslinya ikut diubah ([true]) atau hanya menyalin list ([false]).
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    final list = inplace ? this : List<E>.from(this)
      ..retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
