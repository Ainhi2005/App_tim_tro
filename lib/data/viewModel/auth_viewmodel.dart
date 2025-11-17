// auth_viewmodel.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../repositories/authRepository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _user != null;

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);

      _token = response.token;
      _user = response.user;

      print('Token: $_token');
      print('User: ${_user?.toJson()}');

      _authRepository.setToken(_token!);

      await _saveToken(_token!);
      await _saveUser(_user!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');

      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register method
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    String role = 'tenant',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fullName = '$firstName $lastName';

      final response = await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
      );

      // Đăng ký thành công, có thể tự động đăng nhập hoặc chuyển sang màn hình đăng nhập
      print('Register success: ${response.message}');
      print('User created: ${response.data.user.toJson()}');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      print('Register error: $e');
      print('Stack trace: $stackTrace');

      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _token = null;
    _user = null;
    _authRepository.clearToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    notifyListeners();
  }

  // Save token to SharedPreferences
  Future<void> _saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = user.toJson();
      await prefs.setString('user', json.encode(userJson));
    } catch (e) {
      print('Error saving user to SharedPreferences: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } catch (e) {
      print('Error saving token to SharedPreferences: $e');
    }
  }

  // Load saved credentials
  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      _authRepository.setToken(_token!);
    }
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}