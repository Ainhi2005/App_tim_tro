class RegisterRequest {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String role;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'phone': phone,
      'role': role,
    };
  }
}