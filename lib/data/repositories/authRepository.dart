import 'package:dio/dio.dart';

import '../models/request/loginRequest.dart';
import '../models/request/register_request.dart';
import '../models/response/loginResponse.dart';
import '../models/response/register_response.dart';
import '../service/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository() : _apiService = _createApiService();

  static ApiService _createApiService() {
    final dio = Dio();
    // Cấu hình thêm cho Dio nếu cần
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return ApiService(dio);
  }
  Future<LoginResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    return await _apiService.login(request);
  }
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      role: role,
    );
    return await _apiService.register(request);
  }

  void setToken(String token) {
    // _apiService.setToken(token);
  }

  void clearToken() {
    // _apiService.clearToken();
  }
}