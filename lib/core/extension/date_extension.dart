import '/core/database/storage/storage_key.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/localization/locale_helper.dart';
import 'package:intl/intl.dart';

/* author
   myaasiinh@gmail.com
*/
extension DateTimeExt on DateTime {
  DateTime copy() =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc);

  String format([String format = 'dd MMM yyyy', String? idFormat]) {
    final local =
        (StorageManager().get(StorageKey.CURRENT_LOCALE) as String?) ?? 'id';
    return LocaleHelper.builder<String>(
      en: DateFormat(format, local).format(this),
      id: DateFormat(idFormat ?? format, local).format(this),
    );
  }

  String get todayddMMMyyyy => format('EEEE, dd MMM yyyy');

  String get toHHmm => format('HH:mm');

  String get toyyyyMMdd => format('yyyy-MM-dd');

  String get todMMyyyy => format('d MMMM yyyy');

  String get toddMMyyyy => format('dd-MMMM-yyyy');

  String get toMMddyyyy => format('MM/dd/yyyy');

  String get toTimestamp => format('yyy-MM-dd HH:mm:ss');
}
