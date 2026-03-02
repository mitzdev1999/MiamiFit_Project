import 'package:flutter/material.dart';

class ViewPlanes extends StatefulWidget {
  const ViewPlanes({super.key});

  @override
  State<ViewPlanes> createState() => _ViewPlanesState();
}

class _ViewPlanesState extends State<ViewPlanes> {
  // Colores Miami Fit
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  // Lista temporal (Luego vendrá de la colección 'planes' en Firestore)
  List<Map<String, dynamic>> planes = [
    {"nombre": "Mensual", "dias": 30},
    {"nombre": "Quincenal", "dias": 15},
    {"nombre": "Anual", "dias": 365},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Stack(
        children: [
          // MARCA DE AGUA
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
                    Text(
                      "PLANES DEL GIMNASIO",
                      style: TextStyle(color: miamiCyan, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddPlanDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("AGREGAR PLAN"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: miamiCyan,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // MINI LISTA DE PLANES
                Expanded(
                  child: ListView.builder(
                    itemCount: planes.length,
                    itemBuilder: (context, index) {
                      final plan = planes[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.calendar_today, color: miamiCyan),
                          title: Text(plan['nombre'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text("${plan['dias']} días de duración", style: const TextStyle(color: Colors.white70)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              setState(() { planes.removeAt(index); });
                            },
                          ),
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

  // VENTANA EMERGENTE PARA AGREGAR PLAN
  void _showAddPlanDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController daysCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: miamiBlue,
        title: Text("Nuevo Plan", style: TextStyle(color: miamiCyan)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(nameCtrl, "Nombre del Plan (ej: Mensual)", Icons.text_fields),
            const SizedBox(height: 15),
            _buildDialogField(daysCtrl, "Días de duración", Icons.timer, isNumber: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: miamiCyan),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && daysCtrl.text.isNotEmpty) {
                setState(() {
                  planes.add({
                    "nombre": nameCtrl.text,
                    "dias": int.parse(daysCtrl.text),
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("GUARDAR", style: TextStyle(color: Colors.white)),
          ),
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
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: miamiCyan)),
      ),
    );
  }
}