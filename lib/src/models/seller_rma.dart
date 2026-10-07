// RMA entities (order edits, returns, claims, exchanges).
//
// Only `id` is required everywhere. Shapes re-probed live on a real
// RMA flow (Oct 2026) — see commit history for wire quirks.

/// A staged order edit (`order_change` payloads).
class SellerOrderEdit {
  const SellerOrderEdit({
    required this.id,
    this.orderId,
    this.status,
    this.changeType,
  });

  final String id;
  final String? orderId;
  final String? status;
  final String? changeType;

  factory SellerOrderEdit.fromJson(Map<String, dynamic> json) {
    return SellerOrderEdit(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      status: json['status'] as String?,
      changeType: json['change_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (orderId != null) 'order_id': orderId,
      if (status != null) 'status': status,
      if (changeType != null) 'change_type': changeType,
    };
  }
}

/// A return (`return` payloads).
class SellerReturn {
  const SellerReturn({
    required this.id,
    this.orderId,
    this.status,
    this.locationId,
    this.displayId,
  });

  final String id;
  final String? orderId;
  final String? status;
  final String? locationId;
  final int? displayId;

  factory SellerReturn.fromJson(Map<String, dynamic> json) {
    return SellerReturn(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      status: json['status'] as String?,
      locationId: json['location_id'] as String?,
      displayId: (json['display_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (orderId != null) 'order_id': orderId,
      if (status != null) 'status': status,
      if (locationId != null) 'location_id': locationId,
      if (displayId != null) 'display_id': displayId,
    };
  }
}

/// A claim (`claim` payloads; live keys include `display_id`,
/// `claim_items`, `additional_items` — no `status` field).
class SellerClaim {
  const SellerClaim({
    required this.id,
    this.orderId,
    this.type,
    this.status,
    this.displayId,
  });

  final String id;
  final String? orderId;
  final String? type;
  final String? status;
  final int? displayId;

  factory SellerClaim.fromJson(Map<String, dynamic> json) {
    return SellerClaim(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      displayId: (json['display_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (orderId != null) 'order_id': orderId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (displayId != null) 'display_id': displayId,
    };
  }
}

/// An exchange (`exchange` payloads; live keys include `display_id`,
/// `difference_due` — ids carry an `oexc_` prefix).
class SellerExchange {
  const SellerExchange({
    required this.id,
    this.orderId,
    this.status,
    this.displayId,
    this.differenceDue,
  });

  final String id;
  final String? orderId;
  final String? status;
  final int? displayId;
  final int? differenceDue;

  factory SellerExchange.fromJson(Map<String, dynamic> json) {
    return SellerExchange(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      status: json['status'] as String?,
      displayId: (json['display_id'] as num?)?.toInt(),
      differenceDue: (json['difference_due'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (orderId != null) 'order_id': orderId,
      if (status != null) 'status': status,
      if (displayId != null) 'display_id': displayId,
      if (differenceDue != null) 'difference_due': differenceDue,
    };
  }
}

/// Id-only ref (claim/exchange creates return `{claim: {id}}`).
class RmaIdRef {
  const RmaIdRef({required this.id});

  final String id;

  factory RmaIdRef.fromJson(Map<String, dynamic> json) {
    return RmaIdRef(id: json['id'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id};
}
