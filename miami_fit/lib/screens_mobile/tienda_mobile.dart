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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "TIENDA MIAMI FIT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articulos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No hay artículos en stock", 
                style: TextStyle(color: Colors.white54)),
            );
          }

          final articulos = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 0.7, 
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: articulos.length,
            itemBuilder: (context, index) {
              final art = articulos[index].data() as Map<String, dynamic>;
              return _buildProductCard(art);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> art) {
    // Tomamos el nombre del archivo de la base de datos (ej: "suplemento.png")
    final String imageFileName = art['url'] ?? art['imagen'] ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGEN DESDE ASSETS
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: imageFileName.isNotEmpty
                  ? Image.asset(
                      'assets/productos/$imageFileName', // Ruta local
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Si el archivo no existe en la carpeta assets
                        return Container(
                          color: Colors.white.withOpacity(0.05),
                          child: const Center(
                            child: Icon(Icons.image_not_supported, color: Colors.white24, size: 40)
                          ),
                        );
                      },
                    )
                  : const Center(child: Icon(Icons.fitness_center, color: Colors.white10)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  art['nombre']?.toString().toUpperCase() ?? "PRODUCTO",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${art['precio'] ?? '0.00'}",
                  style: TextStyle(color: miamiCyan, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  "STOCK: ${art['stock'] ?? '0'}",
                  style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}