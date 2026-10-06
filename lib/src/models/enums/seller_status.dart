/// Seller lifecycle statuses (verified against Mercur lifecycle docs).
enum SellerStatus {
  pendingApproval,
  open,
  suspended,
  terminated;

  static SellerStatus fromWire(String raw) {
    return switch (raw) {
      'pending_approval' => SellerStatus.pendingApproval,
      'open' => SellerStatus.open,
      'suspended' => SellerStatus.suspended,
      'terminated' => SellerStatus.terminated,
      _ => throw ArgumentError('Unknown SellerStatus: $raw'),
    };
  }

  String toWire() {
    return switch (this) {
      SellerStatus.pendingApproval => 'pending_approval',
      SellerStatus.open => 'open',
      SellerStatus.suspended => 'suspended',
      SellerStatus.terminated => 'terminated',
    };
  }
}
