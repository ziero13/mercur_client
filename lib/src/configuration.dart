/// Client-side configuration for the Mercur marketplace API.
///
/// All secrets stay in this object — never in code — and flow into Dio
/// through typed interceptors (see `interceptors/`).
class Configuration {
  const Configuration({
    required this.baseUrl,
    required this.publishableKey,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  /// Base URL of the Mercur backend, e.g. `http://localhost:9000`.
  final String baseUrl;

  /// Publishable API key (`pk_...`), sent as `x-publishable-api-key`
  /// on every Store (`/store/*`) call.
  final String publishableKey;

  /// Dio connect timeout.
  final Duration connectTimeout;

  /// Dio receive timeout.
  final Duration receiveTimeout;

  Configuration copyWith({
    String? baseUrl,
    String? publishableKey,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    return Configuration(
      baseUrl: baseUrl ?? this.baseUrl,
      publishableKey: publishableKey ?? this.publishableKey,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_url': baseUrl,
      // Never serialise the publishable key: it is a secret.
      'connect_timeout_ms': connectTimeout.inMilliseconds,
      'receive_timeout_ms': receiveTimeout.inMilliseconds,
    };
  }

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      baseUrl: json['base_url'] as String,
      // fromJson is for non-secret shape round-trips (tests, caches);
      // the key itself never travels in JSON.
      publishableKey: json['publishable_key'] as String? ?? '',
      connectTimeout:
          Duration(milliseconds: (json['connect_timeout_ms'] as num?)?.toInt() ?? 10000),
      receiveTimeout:
          Duration(milliseconds: (json['receive_timeout_ms'] as num?)?.toInt() ?? 30000),
    );
  }
}
