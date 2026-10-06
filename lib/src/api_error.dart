/// Error types returned by the Mercur API (`{type, message}` envelope).
///
/// Common mapping: `invalid_data` (400), `unauthorized` (401),
/// `not_allowed` (403), `not_found` (404).
enum ApiErrorType {
  invalidData,
  unauthorized,
  notAllowed,
  notFound,
  unknown;

  static ApiErrorType fromWire(String? raw) {
    return switch (raw) {
      'invalid_data' => ApiErrorType.invalidData,
      'unauthorized' => ApiErrorType.unauthorized,
      'not_allowed' => ApiErrorType.notAllowed,
      'not_found' => ApiErrorType.notFound,
      _ => ApiErrorType.unknown,
    };
  }

  String toWire() {
    return switch (this) {
      ApiErrorType.invalidData => 'invalid_data',
      ApiErrorType.unauthorized => 'unauthorized',
      ApiErrorType.notAllowed => 'not_allowed',
      ApiErrorType.notFound => 'not_found',
      ApiErrorType.unknown => 'unknown',
    };
  }
}

/// Typed API failure thrown by [ErrorInterceptor].
class ApiError implements Exception {
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
  });

  final ApiErrorType type;
  final String message;
  final int? statusCode;

  factory ApiError.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    return ApiError(
      type: ApiErrorType.fromWire(json['type'] as String?),
      message: json['message'] as String? ?? 'Unknown error',
      statusCode: statusCode ?? (json['status_code'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toWire(),
      'message': message,
      if (statusCode != null) 'status_code': statusCode,
    };
  }

  @override
  String toString() => 'ApiError(${type.toWire()}, status: $statusCode): $message';
}
