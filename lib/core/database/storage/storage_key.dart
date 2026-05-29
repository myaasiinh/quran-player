class StorageKey {
  static const STORAGE_NAME = 'AppGetStorage';

  static const FIRST_INSTALL = 'first_install';
  static const USERS = 'users';
  static const CURRENT_LOCALE = 'current_locale';
  static const IS_DARK_THEME = 'is_dark_theme';

  static const OFFLINE_ROOM = 'offline_room';
  static const OFFLINE_MESSAGE = 'offline_message';
  static const USER_OFFLINE = 'user_offline';

  static const OFFLINE_TASKS = 'offline_tasks';

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
