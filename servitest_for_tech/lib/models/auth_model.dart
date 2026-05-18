class LoginResponse {
  final String token;
  final String role; // 'Contact Center', 'Technician', o 'Technical Manager'
  final String name;

  LoginResponse({required this.token, required this.role, required this.name});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      role: json['user']['role'],
      name: json['user']['name'],
    );
  }
}