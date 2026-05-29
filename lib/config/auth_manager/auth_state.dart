class AuthState {
  const AuthState({this.appStatus = AppType.INITIAL});
  final AppType appStatus;
}

enum AppType {
  INITIAL,
  FIRST_INSTALL,
  AUTHENTICATED,
  UNAUTHENTICATED,
}
