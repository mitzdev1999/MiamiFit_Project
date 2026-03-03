import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- ESTA IMPORTACIÓN ES VITAL

class ViewArticulos extends StatefulWidget {
  const ViewArticulos({super.key});

  @override
  State<ViewArticulos> createState() => _ViewArticulosState();
}

class _ViewArticulosState extends State<ViewArticulos> {
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
              child: Image.asset('assets/LOGO.jpeg', width: 400),
            ),
          ),
          Padding(
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
                      onPressed: _showAddProductDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("AGREGAR PRODUCTO"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: miamiCyan, 
                        foregroundColor: Colors.white
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // --- LISTA EN TIEMPO REAL DESDE FIREBASE ---
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('articulos').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const Center(child: Text("Error al cargar datos", style: TextStyle(color: Colors.red)));
                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final item = docs[index].data() as Map<String, dynamic>;
                          final docId = docs[index].id;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                // Foto desde URL
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item['fotoUrl'] ?? '', 
                                    width: 60, height: 60, fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: miamiCyan),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['nombre'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text("\$${item['precio']}", style: TextStyle(color: miamiCyan, fontSize: 16)),
                                    ],
                                  ),
                                ),
                                // Control de Stock
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                      onPressed: () => _updateStock(docId, item['cantidad'] - 1),
                                    ),
                                    Text("${item['cantidad']}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
                                      onPressed: () => _updateStock(docId, item['cantidad'] + 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- FUNCIÓN PARA ACTUALIZAR STOCK EN FIREBASE ---
  void _updateStock(String id, int nuevoValor) {
    if (nuevoValor >= 0) {
      FirebaseFirestore.instance.collection('articulos').doc(id).update({'cantidad': nuevoValor});
    }
  }

  // --- DIÁLOGO PARA AGREGAR PRODUCTO CON URL ---
  void _showAddProductDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();
    final TextEditingController stockCtrl = TextEditingController();
    final TextEditingController urlCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: miamiBlue,
        title: Text("NUEVO PRODUCTO", style: TextStyle(color: miamiCyan)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(nameCtrl, "Nombre", Icons.shopping_bag),
            const SizedBox(height: 10),
            _buildDialogField(priceCtrl, "Precio", Icons.attach_money, isNumber: true),
            const SizedBox(height: 10),
            _buildDialogField(stockCtrl, "Stock Inicial", Icons.inventory, isNumber: true),
            const SizedBox(height: 10),
            _buildDialogField(urlCtrl, "URL de la foto (.jpg o .png)", Icons.link),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('articulos').add({
                  'nombre': nameCtrl.text,
                  'precio': double.tryParse(priceCtrl.text) ?? 0.0,
                  'cantidad': int.tryParse(stockCtrl.text) ?? 0,
                  'fotoUrl': urlCtrl.text,
                });
                Navigator.pop(context);
              }
            },
            child: const Text("GUARDAR"),
          )
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String hint, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: miamiCyan),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}