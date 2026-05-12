// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.200.36.204:5000/api';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'), // Ajusta la ruta según el backend de tu amigo
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Aquí podrías guardar el token usando el paquete 'shared_preferences'
        print("Login exitoso");
        return true;
      } else {
        print("Fallo en login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de red: $e");
      return false;
    }
  }
}