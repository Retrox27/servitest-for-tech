import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.200.36.204:5000/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<LoginResponse> login(String ci, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ci': ci,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final loginResponse = LoginResponse.fromJson(data);
        await _storage.write(key: 'token', value: loginResponse.token);
        return loginResponse;
      }

      final errorBody = response.body.isNotEmpty ? response.body : 'Error ${response.statusCode}';
      throw ApiException(response.statusCode, errorBody);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, 'No se pudo conectar al servidor de login: $e');
    }
  }

  Future<String?> getToken() async {
    return _storage.read(key: 'token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
