/// Enum [RequestState] mendefinisikan berbagai kondisi/status dari sebuah request.
enum RequestState { initial, empty, loading, success, error, shimmering }

/// Ekstensi [RequestStateExt] memberikan properti kemudahan untuk memeriksa nilai dari [RequestState].
extension RequestStateExt on RequestState {
  /// Mengembalikan true jika statusnya adalah [RequestState.initial].
  bool get isInitial => this == RequestState.initial;

  /// Mengembalikan true jika statusnya adalah [RequestState.empty] (tidak ada data).
  bool get isEmpty => this == RequestState.empty;

  /// Mengembalikan true jika statusnya adalah [RequestState.loading] (sedang memuat).
  bool get isLoading => this == RequestState.loading;

  /// Mengembalikan true jika statusnya adalah [RequestState.success] (berhasil).
  bool get isSuccess => this == RequestState.success;

  /// Mengembalikan true jika statusnya adalah [RequestState.error] (terjadi kesalahan).
  bool get isError => this == RequestState.error;

  /// Mengembalikan true jika statusnya adalah [RequestState.shimmering] (tampilan rangka/skeleton loading).
  bool get isShimmering => this == RequestState.shimmering;
}
