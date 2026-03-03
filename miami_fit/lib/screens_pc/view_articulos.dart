import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewArticulos extends StatefulWidget {
  const ViewArticulos({super.key});

  @override
  State<ViewArticulos> createState() => _ViewArticulosState();
}

class _ViewArticulosState extends State<ViewArticulos> {
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  // Controladores para agregar nuevo producto
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();
  final TextEditingController _imgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("INVENTARIO DE ARTÍCULOS",
                    style: TextStyle(color: miamiCyan, fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("NUEVO ARTÍCULO"),
                  style: ElevatedButton.styleFrom(backgroundColor: miamiCyan, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('articulos').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  
                  final docs = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 columnas en PC
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final id = docs[index].id;
                      return _buildProductCard(data, id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data, String id) {
    // IMPORTANTE: Aquí es donde corregimos para que lea de ASSETS
    final String fileName = data['url'] ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: fileName.isNotEmpty
                  ? Image.asset(
                      'assets/productos/$fileName',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => 
                        const Center(child: Icon(Icons.broken_image, color: Colors.white24, size: 50)),
                    )
                  : const Icon(Icons.image, color: Colors.white10, size: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(data['nombre'] ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("\$${data['precio']}", style: TextStyle(color: miamiCyan)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                      onPressed: () => FirebaseFirestore.instance.collection('articulos').doc(id).delete(),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0E2246),
        title: const Text("AGREGAR PRODUCTO", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nombreCtrl, "Nombre del producto"),
            _buildTextField(_precioCtrl, "Precio (ej: 25.00)"),
            _buildTextField(_stockCtrl, "Stock inicial"),
            _buildTextField(_imgCtrl, "Nombre del archivo (ej: gorra_blanca.jpeg)"),
            const SizedBox(height: 10),
            const Text(
              "Nota: El archivo debe estar en assets/productos/",
              style: TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('articulos').add({
                'nombre': _nombreCtrl.text,
                'precio': _precioCtrl.text,
                'stock': int.tryParse(_stockCtrl.text) ?? 0,
                'url': _imgCtrl.text, // Aquí guardamos el nombre del archivo
              });
              _nombreCtrl.clear(); _precioCtrl.clear(); _stockCtrl.clear(); _imgCtrl.clear();
              Navigator.pop(context);
            },
            child: const Text("GUARDAR"),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}