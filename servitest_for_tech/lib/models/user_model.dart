class User {
  final String ci;
  final String name;
  final String role;
  final String lastName;

  User({required this.name, required this.lastName, required this.ci, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      lastName: json['lastname'] as String,
      ci: json['ci'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ci': ci,
      'name': name,
      'lastName': lastName,
      'role': role,
    };
  }
}

class UserRole {
  static const String technician = 'Técnico';
  static const String contactCenter = 'Operador de Contact Center';
  static const String contactCenterManager = 'Supervisor de Contact Center';
  static const String technicianManager = 'Jefe de Servicio Técnico';
  static const String admin = 'Administrador';

  static const List<String> all = [
    technician,
    contactCenter,
    contactCenterManager,
    technicianManager,
    admin,
  ];

  static String toBackendRole(String uiRole) {
    switch (uiRole.toUpperCase()) {
      case 'técnico':
      case 'tecnico':
        return 'TECHNICIAN';
      case 'operador':
        return 'CONTACT_CENTER';
      case 'supervisor':
        return 'CONTACT_CENTER_MANAGER';
      case 'jefe':
        return 'TECHNICIAN_MANAGER';
      case 'administrador':
        return 'ADMIN';
      default:
        return uiRole.toUpperCase();
    }
  }

  static String fromBackendRole(String backendRole) {
    switch (backendRole.toLowerCase()) {
      case 'TECHNICIAN':
      case 'tech':
        return technician;
      case 'operator':
        return contactCenter;
      case 'contact_center_manager':
        return contactCenterManager;
      case 'manager':
      case 'jefe':
        return technicianManager;
      case 'admin':
      case 'administrator':
        return admin;
      default:
        return backendRole;
    }
  }
}
