import 'package:dio/dio.dart';

import '../api_error.dart';

/// Maps Medusa/Mercur `{type, message}` error envelopes to [ApiError].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: response,
          type: err.type,
          error: ApiError.fromJson(data, statusCode: response?.statusCode),
        ),
      );
      return;
    }
    handler.next(err);
  }
}

/// Extracts the [ApiError] from a caught [DioException], if present.
ApiError? asApiError(Object error) {
  if (error is DioException && error.error is ApiError) {
    return error.error as ApiError;
  }
  return null;
}
