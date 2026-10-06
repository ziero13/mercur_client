/// Customer account (Store surface shape; shared entity).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults (see AGENTS.md).
class Customer {
  const Customer({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.companyName,
  });

  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? companyName;

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      companyName: json['company_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (companyName != null) 'company_name': companyName,
    };
  }
}
