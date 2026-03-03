import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TiendaMobile extends StatefulWidget {
  const TiendaMobile({super.key});

  @override
  State<TiendaMobile> createState() => _TiendaMobileState();
}

class _TiendaMobileState extends State<TiendaMobile> {
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("TIENDA MIAMI FIT", 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Escuchamos la colección 'productos' (asegúrate de que se llame así en tu PC)
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No hay productos disponibles aún", 
                style: TextStyle(color: Colors.white54)),
            );
          }

          final productos = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos columnas
              childAspectRatio: 0.75, // Proporción de la tarjeta
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final prod = productos[index].data() as Map<String, dynamic>;
              
              return _buildProductCard(prod);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> prod) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGEN DEL PRODUCTO
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: prod['url'] != null && prod['url'].toString().isNotEmpty
                  ? Image.network(
                      prod['url'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Imagen de carga mientras descarga de internet
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: Icon(Icons.image, color: Colors.white10));
                      },
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.broken_image, color: Colors.white24),
                    )
                  : const Center(child: Icon(Icons.fitness_center, color: Colors.white10, size: 50)),
            ),
          ),

          // INFO DEL PRODUCTO
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prod['nombre'] ?? "Sin nombre",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${prod['precio']}",
                  style: TextStyle(color: miamiCyan, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                // STOCK
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 12, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text(
                      "Stock: ${prod['stock'] ?? '0'}",
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}