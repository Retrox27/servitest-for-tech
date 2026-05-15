import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import '../models/case_model.dart'; // El modelo que definimos antes
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // La IP que ya comprobaste
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.200.36.204:5000/api';

  Future<Map<String, dynamic>> login(String ci, String password) async {
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
        //COLOCAR AQUI LOGICA PARA GUARDAR TOKEN
        return jsonDecode(response.body); // Retorna el JSON con el Token      
      } else {
        throw "Error: ${response.statusCode}";
      }
    } catch (e) {
      throw "No se pudo conectar al servidor de login: $e";
    }
  }
}
