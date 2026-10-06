/// Sink receiving a fresh JWT so the owning [Mercur] facade can install
/// it on the matching Dio (customer → member → user).
typedef AuthTokenSink = void Function(String token);
