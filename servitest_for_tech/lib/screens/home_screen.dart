import 'dart:ui';

import 'package:flutter/material.dart';

enum UserManagementMode { register, changePassword }

class HomeScreen extends StatefulWidget {
  final String? username;
  final String? role;

  const HomeScreen({Key? key, this.username, this.role}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showUserManagement = false;
  UserManagementMode _managementMode = UserManagementMode.register;

  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _selectedRole = 'Técnico';

  bool get _canManageUsers {
    final role = widget.role?.toLowerCase() ?? '';
    return role.contains('jefe') ||
        role.contains('supervisor') ||
        role.contains('admin') ||
        role.contains('administrador') ||
        role.contains('manager');
  }

  bool get _canChangeRole => _canManageUsers;

  @override
  void dispose() {
    _ciController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleManagementPanel(UserManagementMode mode) {
    setState(() {
      // If the logged user cannot manage users, force changePassword mode
      if (!_canManageUsers && mode == UserManagementMode.register) {
        _managementMode = UserManagementMode.changePassword;
      } else {
        _managementMode = mode;
      }
      _showUserManagement = true;
      _ciController.clear();
      _nameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedRole = 'Técnico';
    });
  }

  void _closeManagementPanel() {
    setState(() {
      _showUserManagement = false;
    });
  }

  void _submitUserForm() {
    final ci = _ciController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (ci.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_managementMode == UserManagementMode.register
            ? 'Usuario registrado (demo)'
            : 'Contraseña actualizada (demo)'),
      ),
    );

    _closeManagementPanel();
  }

  Widget _panelContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1524),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: 2),
      ),
      child: child,
    );
  }

  Widget _buildUserManagementPanel() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Material(
          color: const Color(0xFF11263D),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gestión de usuario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: _closeManagementPanel,
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_canManageUsers)
                  ToggleButtons(
                    isSelected: [
                      _managementMode == UserManagementMode.register,
                      _managementMode == UserManagementMode.changePassword,
                    ],
                    onPressed: (index) {
                      setState(() {
                        _managementMode = UserManagementMode.values[index];
                        _ciController.clear();
                        _nameController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    fillColor: const Color(0xFF1E88E5),
                    selectedBorderColor: const Color(0xFF1E88E5),
                    selectedColor: Colors.white,
                    children: const [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Text('Registrar usuario')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Text('Cambiar contraseña')),
                    ],
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Solo puedes cambiar tu contraseña.', style: TextStyle(color: Colors.white70)),
                  ),
                const SizedBox(height: 24),
                TextField(
                  controller: _ciController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'CI del usuario',
                    hintText: 'Ingrese la cédula',
                  ),
                ),
                const SizedBox(height: 14),
                if (_managementMode == UserManagementMode.register) ...[
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      hintText: 'Ingrese el nombre del usuario',
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _managementMode == UserManagementMode.register
                        ? 'Contraseña inicial'
                        : 'Nueva contraseña',
                    hintText: 'Ingrese la contraseña',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña',
                    hintText: 'Vuelve a escribir la contraseña',
                  ),
                ),
                const SizedBox(height: 18),
                if (_managementMode == UserManagementMode.register && _canManageUsers) ...[
                  const Text('Rol asignado', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    dropdownColor: const Color(0xFF0B1524),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF0F1930),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Técnico', child: Text('Técnico')),
                      DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
                      DropdownMenuItem(value: 'Jefe', child: Text('Jefe')),
                      DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedRole = value);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                ],
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitUserForm,
                        child: Text(_managementMode == UserManagementMode.register
                            ? 'Registrar usuario'
                            : 'Actualizar contraseña'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _closeManagementPanel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ServiTEST'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _panelContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('18 de Mayo - 6:27 p.m.', style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 6),
                          Text('ServiTEST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('Casos pendientes: 0', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('Casos en espera: 0', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('Casos siendo atendidos: 0', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('Casos atendidos en el turno: 0', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _panelContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('En línea', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('> Técnicos', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text('- Luis Ávila - Disponible'),
                              Text('- Gabriel Lameda - Atendiendo'),
                              Text('- Enrique Martinez - Ocupado'),
                              Text('- José Buenaño - Atendiendo'),
                              SizedBox(height: 12),
                              Text('> Operadores', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text('- Webon 1 - En línea'),
                              Text('- Webon 2 - En llamada'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: _panelContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Casos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Card(
                                color: const Color(0xFF0F1930),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white12)),
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Monitor presenta problemas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 6),
                                      Text('Ubicación: Bloque G    -    Extensión: 7880'),
                                      SizedBox(height: 6),
                                      Text('Subido por: Webon 2    -    Estado: Pendiente'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Card(
                                color: Color(0xFF0F1930),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white12)),
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Monitor presenta problemas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 6),
                                      Text('Ubicación: Bloque G    -    Extensión: 7880'),
                                      SizedBox(height: 6),
                                      Text('Subido por: Webon 2    -    Estado: Pendiente'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _panelContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 36)),
                              const SizedBox(height: 8),
                              Text(widget.username ?? 'Técnico', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(widget.role ?? 'Técnico', style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 12),
                              const Divider(color: Colors.white12),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _toggleManagementPanel(UserManagementMode.register),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E88E5),
                                  minimumSize: const Size.fromHeight(44),
                                ),
                                child: const Text('Gestionar usuarios'),
                              ),
                              const SizedBox(height: 16),
                              const Align(alignment: Alignment.centerLeft, child: Text('- Lista de casos extendida')),
                              const Align(alignment: Alignment.centerLeft, child: Text('- Casos asignados')),
                              const Align(alignment: Alignment.centerLeft, child: Text('- Inventario')),
                              const Align(alignment: Alignment.centerLeft, child: Text('- Directorio telefónico')),
                              const Align(alignment: Alignment.centerLeft, child: Text('- Transferencia de equipos')),
                              const Align(alignment: Alignment.centerLeft, child: Text('- Configuración de la cuenta')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showUserManagement)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeManagementPanel,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.35),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {},
                      child: _buildUserManagementPanel(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
