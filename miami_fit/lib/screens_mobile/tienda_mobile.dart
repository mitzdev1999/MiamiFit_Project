import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TiendaMobile extends StatelessWidget {
  TiendaMobile({super.key});

  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  // Lista de ejemplo (Estos datos vendrán de la misma colección que la PC)
  final List<Map<String, dynamic>> productos = [
    {"nombre": "Proteína Whey", "precio": 45.0, "foto": "assets/LOGO.jpeg", "stock": 10},
    {"nombre": "Creatina", "precio": 30.0, "foto": "assets/LOGO.jpeg", "stock": 5},
    {"nombre": "Cinturón Gym", "precio": 25.0, "foto": "assets/LOGO.jpeg", "stock": 8},
    {"nombre": "Shaker", "precio": 10.0, "foto": "assets/LOGO.jpeg", "stock": 20},
  ];

  // Función para abrir WhatsApp
  void _comprarPorWhatsApp(String producto) async {
    String telefono = "573001234567"; // <-- Reemplaza con el número del Gimnasio
    String mensaje = "Hola Miami Fit! Me interesa comprar el producto: $producto. ¿Está disponible?";
    Uri url = Uri.parse("https://wa.me/$telefono?text=${Uri.encodeComponent(mensaje)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("No se pudo abrir WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      appBar: AppBar(
        title: const Text("TIENDA MIAMI FIT", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos productos por fila
            childAspectRatio: 0.75, // Ajuste de altura de la tarjeta
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final prod = productos[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del Producto
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(prod['foto'], fit: BoxFit.cover, width: double.infinity),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prod['nombre'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "\$${prod['precio']}",
                          style: TextStyle(color: miamiCyan, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Botón de Compra
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _comprarPorWhatsApp(prod['nombre']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: miamiCyan,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("COMPRAR", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}