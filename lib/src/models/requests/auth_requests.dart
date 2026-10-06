/// Email/password credentials for all three login endpoints
/// (`/auth/user|member|customer/emailpass`).
class LoginReq {
  const LoginReq({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  factory LoginReq.fromJson(Map<String, dynamic> json) {
    return LoginReq(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}

/// Single public request for customer registration.
///
/// Executes the verified 3-step flow as one call:
/// `POST /auth/customer/emailpass/register` → token ⇒
/// `POST /store/customers` (with that Bearer) ⇒ login.
class RegisterCustomerReq {
  const RegisterCustomerReq({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.companyName,
  });

  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? companyName;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phone != null) 'phone': phone,
      if (companyName != null) 'company_name': companyName,
    };
  }

  factory RegisterCustomerReq.fromJson(Map<String, dynamic> json) {
    return RegisterCustomerReq(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      companyName: json['company_name'] as String?,
    );
  }
}
