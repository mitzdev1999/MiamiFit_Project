import 'package:flutter/material.dart';

class ViewArticulos extends StatefulWidget {
  const ViewArticulos({super.key});

  @override
  State<ViewArticulos> createState() => _ViewArticulosState();
}

class _ViewArticulosState extends State<ViewArticulos> {
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  // Lista temporal de productos
  List<Map<String, dynamic>> productos = [
    {"nombre": "Proteína Whey", "precio": 45.00, "cantidad": 10, "foto": "assets/LOGO.jpeg"},
    {"nombre": "Creatina", "precio": 30.00, "cantidad": 5, "foto": "assets/LOGO.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Stack(
        children: [
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
                      style: ElevatedButton.styleFrom(backgroundColor: miamiCyan, foregroundColor: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final item = productos[index];
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
                            // Foto del producto
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(item['foto'], width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 20),
                            // Información
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['nombre'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text("\$${item['precio']}", style: TextStyle(color: miamiCyan, fontSize: 16)),
                                ],
                              ),
                            ),
                            // Control de stock
                            Row(
                              children: [
                                const Text("Stock: ", style: TextStyle(color: Colors.white70)),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      if (item['cantidad'] > 0) item['cantidad']--;
                                    });
                                  },
                                ),
                                Text("${item['cantidad']}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
                                  onPressed: () => setState(() => item['cantidad']++),
                                ),
                              ],
                            ),
                          ],
                        ),
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


  void _showAddProductDialog() {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();
  final TextEditingController photoCtrl = TextEditingController(); // Temporalmente como texto

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: miamiBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white10)),
      title: Text("NUEVO ARTÍCULO", style: TextStyle(color: miamiCyan, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(nameCtrl, "Nombre del producto", Icons.shopping_bag),
            const SizedBox(height: 15),
            _buildDialogField(priceCtrl, "Precio (Ej: 45.00)", Icons.attach_money, isNumber: true),
            const SizedBox(height: 15),
            _buildDialogField(stockCtrl, "Cantidad inicial", Icons.inventory_2, isNumber: true),
            const SizedBox(height: 15),
            _buildDialogField(photoCtrl, "Nombre del archivo de imagen (ej: protein.jpg)", Icons.image),
            const SizedBox(height: 10),
            const Text(
              "Nota: Por ahora, asegúrate de que la imagen esté en tu carpeta assets.",
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCELAR", style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: miamiCyan,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
              setState(() {
                productos.add({
                  "nombre": nameCtrl.text,
                  "precio": double.parse(priceCtrl.text),
                  "cantidad": int.parse(stockCtrl.text),
                  "foto": "assets/LOGO.jpeg", // Usamos el logo por defecto si no hay ruta
                });
              });
              Navigator.pop(context);
            }
          },
          child: const Text("GUARDAR PRODUCTO", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

// Widget auxiliar para los campos del diálogo
Widget _buildDialogField(TextEditingController ctrl, String hint, IconData icon, {bool isNumber = false}) {
  return TextField(
    controller: ctrl,
    keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: miamiCyan, size: 20),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: miamiCyan)),
    ),
  );
}
}