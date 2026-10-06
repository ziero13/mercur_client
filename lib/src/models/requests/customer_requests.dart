/// Body of `POST /store/customers` (step 2 of registration).
///
/// Anonymous calls are 401 by design — this body is always sent with the
/// unregistered-identity Bearer from the register step.
class CustomerCreateReq {
  const CustomerCreateReq({
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.companyName,
  });

  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? companyName;

  Map<String, dynamic> toJson() {
    return {
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (companyName != null) 'company_name': companyName,
    };
  }

  factory CustomerCreateReq.fromJson(Map<String, dynamic> json) {
    return CustomerCreateReq(
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      companyName: json['company_name'] as String?,
    );
  }
}
