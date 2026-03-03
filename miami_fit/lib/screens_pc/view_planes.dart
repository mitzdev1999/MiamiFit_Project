import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPlanes extends StatefulWidget {
  const ViewPlanes({super.key});

  @override
  State<ViewPlanes> createState() => _ViewPlanesState();
}

class _ViewPlanesState extends State<ViewPlanes> {
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

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
                Text("CONFIGURACIÓN DE PLANES",
                    style: TextStyle(color: miamiCyan, fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _showAddPlanDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("NUEVO PLAN"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: miamiCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // LISTA DE PLANES DESDE FIREBASE
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('planes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Error al cargar planes"));
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 planes por fila en PC
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final plan = docs[index].data() as Map<String, dynamic>;
                      final docId = docs[index].id;

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(docId, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text("${plan['dias']} DÍAS", style: TextStyle(color: miamiCyan, fontSize: 18)),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("\$${plan['precio']}", style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                                  onPressed: () => FirebaseFirestore.instance.collection('planes').doc(docId).delete(),
                                ),
                              ],
                            )
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
    );
  }

  void _showAddPlanDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController daysCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: miamiBlue,
        title: Text("Crear Nuevo Plan", style: TextStyle(color: miamiCyan)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(nameCtrl, "Nombre (ej: Mensual)", Icons.text_fields),
            const SizedBox(height: 10),
            _buildField(daysCtrl, "Días de duración", Icons.calendar_today, isNumber: true),
            const SizedBox(height: 10),
            _buildField(priceCtrl, "Precio sugerido", Icons.attach_money, isNumber: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                // El ID del documento será el nombre del plan (Mensual, Trimestral, etc.)
                await FirebaseFirestore.instance.collection('planes').doc(nameCtrl.text.trim()).set({
                  'dias': int.parse(daysCtrl.text),
                  'precio': double.parse(priceCtrl.text),
                });
                Navigator.pop(context);
              }
            },
            child: const Text("GUARDAR PLAN"),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon, {bool isNumber = false}) {
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