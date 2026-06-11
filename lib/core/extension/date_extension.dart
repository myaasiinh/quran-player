import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/localization/locale_helper.dart';
import 'package:intl/intl.dart';

/* author
   myaasiinh@gmail.com
*/

/// Ekstensi pada tipe [DateTime] untuk mempermudah manipulasi dan pemformatan tanggal.
extension DateTimeExt on DateTime {
  /// Membuat salinan (copy) dari objek [DateTime] saat ini.
  /// 
  /// Mempertahankan nilai [isUtc] dari waktu aslinya.
  DateTime copy() =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc);

  /// Mengonversi [DateTime] ke dalam bentuk format string yang diberikan.
  /// 
  /// Secara bawaan (default), format adalah 'dd MMM yyyy'.
  /// Parameter [idFormat] opsional memungkinkan untuk menyediakan format khusus untuk bahasa Indonesia (id).
  /// Fungsi ini otomatis mengambil preferensi bahasa pengguna (locale) dari penyimpanan lokal.
  String format([String format = 'dd MMM yyyy', String? idFormat]) {
    final local =
        (StorageManager().get(StorageKey.CURRENT_LOCALE) as String?) ?? 'id';
    return LocaleHelper.builder<String>(
      en: DateFormat(format, local).format(this),
      id: DateFormat(idFormat ?? format, local).format(this),
    );
  }

  /// Mengembalikan string dengan format seperti 'Kamis, 01 Jan 2026' atau 'Thursday, 01 Jan 2026'.
  String get todayddMMMyyyy => format('EEEE, dd MMM yyyy');

  /// Mengembalikan string jam dan menit dengan format 'HH:mm' (misalnya 15:30).
  String get toHHmm => format('HH:mm');

  /// Mengembalikan string dengan format 'yyyy-MM-dd' (misalnya 2026-01-30).
  String get toyyyyMMdd => format('yyyy-MM-dd');

  /// Mengembalikan string dengan format tanggal dan bulan lengkap 'd MMMM yyyy' (misalnya 1 Januari 2026).
  String get todMMyyyy => format('d MMMM yyyy');

  /// Mengembalikan string dengan format tanggal dan bulan lengkap 'dd-MMMM-yyyy' (misalnya 01-Januari-2026).
  String get toddMMyyyy => format('dd-MMMM-yyyy');

  /// Mengembalikan string dengan format bulan di depan 'MM/dd/yyyy' (misalnya 01/30/2026).
  String get toMMddyyyy => format('MM/dd/yyyy');

  /// Mengembalikan string dalam format waktu database lengkap 'yyy-MM-dd HH:mm:ss' (misalnya 2026-01-30 15:30:00).
  String get toTimestamp => format('yyy-MM-dd HH:mm:ss');
}
