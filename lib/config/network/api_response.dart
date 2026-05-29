class ApiResponse<T> {
  ApiResponse({
    required this.success,
    required this.message,
    required this.status,
    this.meta,
    this.error,
    this.data,
  });

  factory ApiResponse.fromJson(Map<dynamic, dynamic> json) {
    late bool isErrorNotEmpty;
    if (json['error'] is List) {
      isErrorNotEmpty = (json['error'] as List).isNotEmpty;
    } else {
      isErrorNotEmpty = json['error'] != null;
    }

    return ApiResponse(
      success: (json['success'] as bool?) ?? (json['error'] == false),
      error: (isErrorNotEmpty
          ? json['error']
          : (json['message'] ?? json['msg'])) as String?,
      data: (json['data'] != null) ? json['data'] as T : null,
      message: (json['message'] ?? json['msg'] ?? '') as String,
      status: (json['status'] as int?) ?? 0,
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
  final bool success;
  final String message;
  final int status;
  final String? error;
  final T? data;
  final Meta? meta;
}

class Meta {
  Meta({
    this.from,
    this.to,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        from: json['from'] as int?,
        to: json['to'] as int?,
        currentPage: json['current_page'] as int?,
        lastPage: json['last_page'] as int?,
        perPage: json['per_page'] as int?,
        total: json['total'] as int?,
      );
  final int? from;
  final int? to;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
      };
}
