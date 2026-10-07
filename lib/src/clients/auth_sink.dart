/// Sink receiving a fresh JWT so the owning [Mercur] facade can install
/// it on the matching Dio (customer → member → user).
typedef AuthTokenSink = void Function(String token);

/// Sink receiving the selected seller so the facade can install
/// `x-seller-id` on the seller Dio.
typedef SellerScopeSink = void Function(String sellerId);
