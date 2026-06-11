/// Kelas [AuthState] digunakan untuk menyimpan status aplikasi saat ini 
/// berkaitan dengan autentikasi atau instalasi.
class AuthState {
  /// Konstruktor untuk [AuthState]. Secara default, [appStatus] diisi dengan [AppType.INITIAL].
  const AuthState({this.appStatus = AppType.INITIAL});
  
  /// Variabel yang menyimpan status dari aplikasi menggunakan enum [AppType].
  final AppType appStatus;
}

/// Enum [AppType] merepresentasikan berbagai kemungkinan status berjalannya aplikasi.
enum AppType {
  /// Status awal (inisialisasi) ketika aplikasi pertama kali dibuka.
  INITIAL,
  
  /// Status yang menandakan bahwa aplikasi ini merupakan instalasi pertama.
  FIRST_INSTALL,
  
  /// Status yang menandakan bahwa pengguna telah berhasil login (terautentikasi).
  AUTHENTICATED,
  
  /// Status yang menandakan bahwa pengguna belum login (tidak terautentikasi).
  UNAUTHENTICATED,
}
