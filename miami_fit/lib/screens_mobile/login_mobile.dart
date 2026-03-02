import 'package:flutter/material.dart';
import 'package:miami_fit/screens_mobile/client_dashboard.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final TextEditingController _cedulaController = TextEditingController();
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Stack(
        children: [
          // LOGO DE FONDO
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('assets/LOGO.jpeg', width: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/LOGO.jpeg', height: 120),
                const SizedBox(height: 50),
                const Text(
                  "BIENVENIDO",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Ingresa tu cédula para consultar tu plan",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 40),
                
                // CAMPO DE CÉDULA
                TextField(
                  controller: _cedulaController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 5),
                  decoration: InputDecoration(
                    hintText: "CÉDULA",
                    hintStyle: TextStyle(color: Colors.white10, letterSpacing: 2),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: miamiCyan)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
                const SizedBox(height: 60),
                
                // BOTÓN CONSULTAR
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí buscaremos en Firebase si la cédula existe
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const ClientDashboard())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: miamiCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "CONSULTAR",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}