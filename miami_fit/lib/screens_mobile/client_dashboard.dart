import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miami_fit/screens_mobile/tienda_mobile.dart';

class ClientDashboard extends StatelessWidget {
  final Map<String, dynamic> userData;
  const ClientDashboard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final Color miamiBlue = const Color(0xFF0A1A39);
    final Color miamiCyan = const Color(0xFF00AEEF);

    // Lógica de días (mantenemos la que no traba la app)
    int diasRestantes = 0;
    final dynamic fFinRaw = userData['fechaFin'];
    if (fFinRaw is Timestamp) {
      final int msFin = fFinRaw.millisecondsSinceEpoch;
      final int msAhora = DateTime.now().millisecondsSinceEpoch;
      diasRestantes = ((msFin - msAhora) / 86400000).ceil();
    }
    if (diasRestantes < 0) diasRestantes = 0;

    Color statusColor = diasRestantes <= 3 ? Colors.redAccent : miamiCyan;

    return Scaffold(
      backgroundColor: miamiBlue,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [miamiBlue, const Color(0xFF162A4E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior corregida
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/LOGO.jpeg', height: 40),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white24),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // SECCIÓN NOMBRE CENTRADA CON PADDING
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      "¡HOLA,",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: miamiCyan, fontSize: 14, letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userData['nombre'].toString().toUpperCase(),
                      textAlign: TextAlign.center, // Centrado horizontal
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 26, // Un poco más grande para que destaque
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Cédula: ${userData['cedula']}",
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ANILLO DE PROGRESO
              
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: diasRestantes / 30,
                      strokeWidth: 15,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$diasRestantes",
                        style: TextStyle(color: statusColor, fontSize: 80, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "DÍAS",
                        style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 4),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // TARJETA DE PLAN
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoTile("PLAN", userData['plan'] ?? "N/A", miamiCyan),
                    _buildInfoTile("ESTADO", diasRestantes > 0 ? "ACTIVO" : "VENCIDO", statusColor),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // BOTÓN TIENDA
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TiendaMobile()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: miamiCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "VER TIENDA MIAMI FIT", 
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}