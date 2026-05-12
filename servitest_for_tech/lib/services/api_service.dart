import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/case_model.dart'; // El modelo que definimos antes

class ApiService {
  // La IP que ya comprobaste
  final String baseUrl = 'http://10.200.36.204:5000/api';

  Future<List<Case>> fetchOpenCases() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cases/open'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        // Convertimos la lista de JSON a una lista de objetos Case
        return body.map((dynamic item) => Case.fromJson(item)).toList();
      } else {
        throw "No se pudieron cargar los casos";
      }
    } catch (e) {
      throw "Error de conexión: $e";
    }
  }
}