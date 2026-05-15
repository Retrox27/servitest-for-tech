class LoginResponse {
  final String token;
  final String username;

  LoginResponse({required this.token, required this.username});

  // Convierte el JSON del backend en un objeto de Dart
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['access_token'], // Ajustado según el estándar de tu openapi.yaml
      username: json['username'] ?? '',
    );
  }
}