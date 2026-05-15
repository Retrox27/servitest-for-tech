import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

// Esto va antes de tu función main()
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreen({super.key});
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  // 1. Create the controllers
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _userController, // 2. Attach it here
              decoration: InputDecoration(labelText: 'CI'),
            ),
            TextField(
              controller: _passwordController, // 2. Attach it here
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            
          ],
        ),
      ),
    );
  }
}
