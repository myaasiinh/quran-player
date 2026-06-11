/// Kelas konstanta yang menyimpan semua kunci (key) yang digunakan dalam penyimpanan lokal (local storage).
class StorageKey {
  /// Nama utama untuk penyimpanan yang digunakan oleh [GetStorage].
  static const STORAGE_NAME = 'AppGetStorage';

  /// Kunci untuk menandai apakah aplikasi baru pertama kali diinstal.
  static const FIRST_INSTALL = 'first_install';
  
  /// Kunci untuk menyimpan data pengguna.
  static const USERS = 'users';
  
  /// Kunci untuk menyimpan preferensi bahasa (locale) saat ini.
  static const CURRENT_LOCALE = 'current_locale';
  
  /// Kunci untuk menyimpan preferensi tema gelap.
  static const IS_DARK_THEME = 'is_dark_theme';

  /// Kunci untuk menyimpan data ruang obrolan saat offline.
  static const OFFLINE_ROOM = 'offline_room';
  
  /// Kunci untuk menyimpan data pesan saat offline.
  static const OFFLINE_MESSAGE = 'offline_message';
  
  /// Kunci untuk menyimpan status pengguna offline.
  static const USER_OFFLINE = 'user_offline';

  /// Kunci untuk menyimpan tugas-tugas (tasks) secara offline.
  static const OFFLINE_TASKS = 'offline_tasks';

  /// Daftar kunci yang dianggap permanen dan tidak boleh dihapus
  /// saat melakukan pembersihan data penyimpanan secara umum.
  static List<String> permanentKeys = [
    StorageKey.STORAGE_NAME,
    StorageKey.FIRST_INSTALL,
    StorageKey.CURRENT_LOCALE,
    StorageKey.IS_DARK_THEME,
    StorageKey.OFFLINE_ROOM,
    StorageKey.OFFLINE_MESSAGE,
    StorageKey.USER_OFFLINE,
    StorageKey.OFFLINE_TASKS,
  ];
}
