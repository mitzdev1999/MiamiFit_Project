import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TiendaMobile extends StatelessWidget {
  const TiendaMobile({super.key});

  // Función para intentar abrir WhatsApp directamente
  void _intentarWhatsApp(BuildContext context, String nombreProducto) async {
    const String telefono = "573042083976";
    final String mensaje = "Hola Miami Fit! Me interesa el producto: $nombreProducto.";
    final Uri whatsappUrl = Uri.parse("https://wa.me/$telefono?text=${Uri.encodeComponent(mensaje)}");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        // Si falla por permisos del celular, mostramos el aviso manual
        _mostrarAvisoContacto(context);
      }
    } catch (e) {
      _mostrarAvisoContacto(context);
    }
  }

  // Ventana emergente con el número y contacto
  void _mostrarAvisoContacto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0E2246),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("CONTACTO MIAMI FIT", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.perm_contact_calendar_outlined, color: Colors.greenAccent, size: 60),
            const SizedBox(height: 15),
            const Text("Número de contacto:", 
              style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 5),
            const Text("+57 304 2083976", 
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Escríbenos para concretar tu compra.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CERRAR", style: TextStyle(color: Color(0xFF00AEEF))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              final Uri telUrl = Uri.parse("tel:+573042083976");
              if (await canLaunchUrl(telUrl)) await launchUrl(telUrl);
            },
            child: const Text("LLAMAR AHORA"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color miamiBlue = Color(0xFF0A1A39);
    const Color miamiCyan = Color(0xFF00AEEF);

    return Scaffold(
      backgroundColor: miamiBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("TIENDA MIAMI FIT"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articulos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final articulos = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58, // Ajustado para el botón
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: articulos.length,
            itemBuilder: (context, index) {
              final art = articulos[index].data() as Map<String, dynamic>;
              final String nombre = art['nombre'] ?? "Producto";

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          'assets/productos/${art['url']}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.fitness_center, color: Colors.white10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombre.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1),
                          Text("\$${art['precio']}", style: const TextStyle(color: miamiCyan, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: miamiCyan),
                              onPressed: () => _mostrarAvisoContacto(context), // <--- Abre la ventana emergente
                              child: const Text("COMPRAR", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}