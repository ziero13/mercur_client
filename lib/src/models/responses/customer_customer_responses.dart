import '../customer_address.dart';

/// Response of address retrieve/create/update (`{address}`).
class CustomerAddressRes {
  const CustomerAddressRes({required this.address});

  final CustomerAddress address;

  factory CustomerAddressRes.fromJson(Map<String, dynamic> json) {
    return CustomerAddressRes(
      address:
          CustomerAddress.fromJson(json['address'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'address': address.toJson()};
}

/// Response of `GET /store/customers/me/addresses`.
class CustomerAddressListRes {
  const CustomerAddressListRes({
    required this.addresses,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<CustomerAddress> addresses;
  final int count;
  final int offset;
  final int limit;

  factory CustomerAddressListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['addresses'];
    return CustomerAddressListRes(
      addresses: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerAddress.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresses': addresses.map((a) => a.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response of `DELETE /store/customers/me/addresses/:address_id`.
class CustomerAddressDeleteRes {
  const CustomerAddressDeleteRes({required this.id, required this.deleted});

  final String id;
  final bool deleted;

  factory CustomerAddressDeleteRes.fromJson(Map<String, dynamic> json) {
    return CustomerAddressDeleteRes(
      id: json['id'] as String,
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'deleted': deleted};
}
