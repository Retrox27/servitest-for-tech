import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Recuerda tener el paquete 'intl' en tu pubspec.yaml

class RelojDigital extends StatefulWidget {
  const RelojDigital({super.key});

  @override
  State<RelojDigital> createState() => _RelojDigitalState();
}

class _RelojDigitalState extends State<RelojDigital> {
  late String _horaActual;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 1. Inicializamos con la hora del sistema de una vez
    _horaActual = _formatearHora(DateTime.now());

    // 2. Creamos el temporizador que corre cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _actualizarHora();
    });
  }

  @override
  void dispose() {
    // CRÍTICO: Cancelamos el timer cuando el widget se destruye 
    // para evitar fugas de memoria (memory leaks).
    _timer?.cancel();
    super.dispose();
  }

  void _actualizarHora() {
    final DateTime ahora = DateTime.now();
    final String horaFormateada = _formatearHora(ahora);
    
    // Cambiamos el estado para que Flutter vuelva a renderizar el texto
    if (mounted) {
      setState(() {
        _horaActual = horaFormateada;
      });
    }
  }

  String _formatearHora(DateTime tiempo) {
    // Formato de 12 horas con AM/PM (Ej: 07:15:23 PM)
    // Si prefieres formato de 24 horas, usa 'HH:mm:ss'
    return DateFormat('hh:mm:ss a').format(tiempo);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _horaActual,
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace', // Evita que los números "bailen" al cambiar de ancho
        color: Colors.white,
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  final String? username;

  const HomeScreen({Key? key, this.username}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ServiTEST'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Top summary bar
            _panelContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('18 de Mayo -', style: TextStyle(color: Colors.white70)),
                      RelojDigital(),
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
            // Main content
            Expanded(
              child: Row(
                children: [
                  // Left column - En línea
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
                  // Center column - Casos
                  Expanded(
                    flex: 4,
                    child: _panelContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Casos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          // Example case card
                          Card(
                            color: const Color(0xFF0F1930),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
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
                            color: const Color(0xFF0F1930),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
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
                  // Right column - Perfil
                  Expanded(
                    flex: 2,
                    child: _panelContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 36)),
                          const SizedBox(height: 8),
                          Text(username ?? 'Técnico', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Técnico', style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 8),
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
    );
  }
}
