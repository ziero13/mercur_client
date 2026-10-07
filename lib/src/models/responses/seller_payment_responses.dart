import '../seller_payment.dart';

/// Response of `GET /vendor/payments`.
class SellerPaymentListRes {
  const SellerPaymentListRes({
    required this.payments,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerPayment> payments;
  final int count;
  final int offset;
  final int limit;

  factory SellerPaymentListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['payments'];
    return SellerPaymentListRes(
      payments: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerPayment.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((p) => p.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `payment` (retrieve / capture / refund).
class SellerPaymentRes {
  const SellerPaymentRes({required this.payment});

  final SellerPayment payment;

  factory SellerPaymentRes.fromJson(Map<String, dynamic> json) {
    return SellerPaymentRes(
      payment:
          SellerPayment.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'payment': payment.toJson()};
}

/// Response of `GET /vendor/payments/payment-providers`.
class SellerPaymentProviderListRes {
  const SellerPaymentProviderListRes({required this.providers});

  final List<SellerPaymentProvider> providers;

  factory SellerPaymentProviderListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['payment_providers'];
    return SellerPaymentProviderListRes(
      providers: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerPaymentProvider.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'payment_providers': providers.map((p) => p.toJson()).toList(),
      };
}

/// Response of `GET /vendor/payouts`.
class SellerPayoutListRes {
  const SellerPayoutListRes({
    required this.payouts,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerPayout> payouts;
  final int count;
  final int offset;
  final int limit;

  factory SellerPayoutListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['payouts'];
    return SellerPayoutListRes(
      payouts: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerPayout.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payouts': payouts.map((p) => p.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `payout`.
class SellerPayoutRes {
  const SellerPayoutRes({required this.payout});

  final SellerPayout payout;

  factory SellerPayoutRes.fromJson(Map<String, dynamic> json) {
    return SellerPayoutRes(
      payout: SellerPayout.fromJson(json['payout'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'payout': payout.toJson()};
}

/// Response of `GET /vendor/payout-accounts` (list).
class SellerPayoutAccountListRes {
  const SellerPayoutAccountListRes({
    required this.accounts,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerPayoutAccount> accounts;
  final int count;
  final int offset;
  final int limit;

  factory SellerPayoutAccountListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['payout_accounts'];
    return SellerPayoutAccountListRes(
      accounts: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerPayoutAccount.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payout_accounts': accounts.map((a) => a.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `payout_account`.
class SellerPayoutAccountRes {
  const SellerPayoutAccountRes({required this.account});

  final SellerPayoutAccount account;

  factory SellerPayoutAccountRes.fromJson(Map<String, dynamic> json) {
    return SellerPayoutAccountRes(
      account: SellerPayoutAccount.fromJson(
          json['payout_account'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'payout_account': account.toJson()};
}

/// Response wrapping one `onboarding`.
class SellerOnboardingRes {
  const SellerOnboardingRes({required this.onboarding});

  final SellerOnboarding onboarding;

  factory SellerOnboardingRes.fromJson(Map<String, dynamic> json) {
    return SellerOnboardingRes(
      onboarding: SellerOnboarding.fromJson(
          json['onboarding'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'onboarding': onboarding.toJson()};
}
