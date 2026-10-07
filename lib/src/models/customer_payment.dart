// Store payment collections (`POST /store/payment-collections*`, Medusa core).
//
// Only `id` is required everywhere — partial `fields` selections fall back
// to neutral defaults (see AGENTS.md).

/// A payment session inside a collection (provider attempt).
class CustomerPaymentSession {
  const CustomerPaymentSession({
    required this.id,
    this.amount,
    this.currencyCode,
    this.providerId,
    this.status,
    this.data,
  });

  final String id;
  final int? amount;
  final String? currencyCode;
  final String? providerId;
  final String? status;
  final Map<String, dynamic>? data;

  factory CustomerPaymentSession.fromJson(Map<String, dynamic> json) {
    return CustomerPaymentSession(
      id: json['id'] as String,
      amount: (json['amount'] as num?)?.toInt(),
      currencyCode: json['currency_code'] as String?,
      providerId: json['provider_id'] as String?,
      status: json['status'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['data'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (providerId != null) 'provider_id': providerId,
      if (status != null) 'status': status,
      if (data != null) 'data': data,
    };
  }
}

/// A store payment collection (one per cart).
class CustomerPaymentCollection {
  const CustomerPaymentCollection({
    required this.id,
    this.currencyCode,
    this.amount,
    this.status,
    this.paymentSessions = const [],
  });

  final String id;
  final String? currencyCode;
  final int? amount;
  final String? status;
  final List<CustomerPaymentSession> paymentSessions;

  factory CustomerPaymentCollection.fromJson(Map<String, dynamic> json) {
    final raw = json['payment_sessions'];
    return CustomerPaymentCollection(
      id: json['id'] as String,
      currencyCode: json['currency_code'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      status: json['status'] as String?,
      paymentSessions: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerPaymentSession.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      'payment_sessions': paymentSessions.map((s) => s.toJson()).toList(),
    };
  }
}
