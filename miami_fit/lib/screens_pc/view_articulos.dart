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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("INVENTARIO MIAMI FIT", style: TextStyle(color: miamiCyan, fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("AGREGAR PRODUCTO"),
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
                      crossAxisCount: 5, 
                      childAspectRatio: 0.4, // <--- MÁS VERTICAL
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return _buildProductCard(data, docs[index].id);
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
    final String fileName = data['url'] ?? "";
    int stock = data['stock'] ?? 0;

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
              child: Image.asset(
                'assets/productos/$fileName',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white10, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(data['nombre'] ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
                Text("\$${data['precio']}", style: TextStyle(color: miamiCyan, fontSize: 16)),
                const SizedBox(height: 12),
                // CONTROL DE STOCK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _btnStock(Icons.remove, () {
                      if (stock > 0) FirebaseFirestore.instance.collection('articulos').doc(id).update({'stock': stock - 1});
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("$stock", style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    _btnStock(Icons.add, () {
                      FirebaseFirestore.instance.collection('articulos').doc(id).update({'stock': stock + 1});
                    }),
                  ],
                ),
                IconButton(
                  onPressed: () => FirebaseFirestore.instance.collection('articulos').doc(id).delete(),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _btnStock(IconData icon, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: miamiCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
        child: Icon(icon, color: miamiCyan, size: 16),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0E2246),
        title: const Text("NUEVO PRODUCTO", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _in(_nombreCtrl, "Nombre"),
            _in(_precioCtrl, "Precio"),
            _in(_stockCtrl, "Stock Inicial"),
            _in(_imgCtrl, "Nombre archivo (ej: gorra.jpeg)"),
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
                'url': _imgCtrl.text,
              });
              Navigator.pop(context);
            }, 
            child: const Text("GUARDAR")
          ),
        ],
      ),
    );
  }

  Widget _in(TextEditingController c, String h) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(controller: c, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white24))),
  );
}