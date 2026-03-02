import 'package:flutter/material.dart';
import 'package:miami_fit/screens_pc/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Definimos el color exacto del logo para que no se vea el "cuadro"
  final Color miamiFitBg = const Color(0xFF0A192F); 
  final Color miamiFitCyan = const Color(0xFF00AEEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A39), // <--- Aplicamos el color exacto aquí
      body: Center(
        child: Container(
          width: 450, // Un poco más ancho para que respire mejor
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- TU LOGO ---
              // Usamos BoxFit.contain para asegurar que se vea bien
              Image.asset(
                'assets/LOGO.jpeg', 
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),
              
              // --- CAMPO USUARIO ---
              _buildTextField("Usuario o Correo", Icons.person),
              const SizedBox(height: 25),
              
              // --- CAMPO CONTRASEÑA ---
              _buildTextField("Contraseña", Icons.lock, isPassword: true),
              const SizedBox(height: 50),
              
              // --- BOTÓN INGRESAR ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const AdminDashboard())
                    );
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: miamiFitCyan,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bordes redondeados como tu imagen
                    ),
                  ),
                  child: const Text(
                    "INGRESAR", 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: miamiFitCyan, size: 22),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05), // Fondo sutil para los inputs
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: miamiFitCyan),
        ),
      ),
    );
  }
}