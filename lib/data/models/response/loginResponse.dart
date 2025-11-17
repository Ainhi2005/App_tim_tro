import '../user_model.dart';

class LoginResponse {
  final String status;
  final String token;
  final User user;

  LoginResponse({
    required this.status,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      token: json['token'],
      user: User.fromJson(json['data']['user']),
    );
  }
}