import 'package:flutter/material.dart';
import 'package:miami_fit/screens_mobile/tienda_mobile.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("MIAMI FIT", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Hola, Carlos Perez", style: TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 40),
          
          // CÍRCULO DE DÍAS RESTANTES
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: miamiCyan, width: 8),
                boxShadow: [
                  BoxShadow(color: miamiCyan.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Te quedan", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text("15", style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold)),
                  Text("DÍAS", style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // BOTÓN DE COMPRA (ACCESO AL CATÁLOGO)
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TiendaMobile())
                );
              },
              child: Container( 
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [miamiCyan, Colors.blue.shade900]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                    SizedBox(width: 15),
                    Text("VER TIENDA / COMPRAS", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}