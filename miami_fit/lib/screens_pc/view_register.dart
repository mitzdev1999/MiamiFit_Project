import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRegistrar extends StatefulWidget {
  const ViewRegistrar({super.key});

  @override
  State<ViewRegistrar> createState() => _ViewRegistrarState();
}

class _ViewRegistrarState extends State<ViewRegistrar> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar el texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  
  String? _planSeleccionado;
  int _diasDelPlan = 0; // Para calcular la fecha de vencimiento

  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  // Función principal para guardar en Firebase
  void _registrarEnFirebase() async {
    if (_formKey.currentState!.validate() && _planSeleccionado != null) {
      try {
        // 1. Calculamos la fecha de inicio (hoy) y fin
        DateTime fechaHoy = DateTime.now();
        DateTime fechaVencimiento = fechaHoy.add(Duration(days: _diasDelPlan));

        // 2. Guardamos en la colección 'clientes' usando la CÉDULA como ID del documento
        // Esto evita que un mismo cliente se registre dos veces
        await FirebaseFirestore.instance.collection('clientes').doc(_cedulaController.text.trim()).set({
          'nombre': _nombreController.text.trim(),
          'cedula': _cedulaController.text.trim(),
          'plan': _planSeleccionado,
          'fechaInicio': fechaHoy,
          'fechaFin': fechaVencimiento,
          'registro': DateTime.now(),
        });

        // 3. Feedback visual de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("¡Cliente ${_nombreController.text} registrado con éxito!"),
          ),
        );

        // 4. Limpiar formulario
        _nombreController.clear();
        _cedulaController.clear();
        setState(() {
          _planSeleccionado = null;
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text("Error al registrar: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor rellena todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Center(
        child: Container(
          width: 500, // Ancho fijo para que se vea como un formulario centrado en PC
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("REGISTRAR NUEVO MIEMBRO", 
                  style: TextStyle(color: miamiCyan, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                _buildTextField("Nombre Completo", Icons.person, _nombreController),
                const SizedBox(height: 20),
                
                _buildTextField("Cédula / ID", Icons.badge, _cedulaController, isNumber: true),
                const SizedBox(height: 20),

                // DROPDOWN DINÁMICO DESDE FIREBASE
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('planes').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const LinearProgressIndicator();
                    
                    var planesDocs = snapshot.data!.docs;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: miamiBlue,
                          hint: const Text("Selecciona un Plan", style: TextStyle(color: Colors.white24)),
                          value: _planSeleccionado,
                          isExpanded: true,
                          items: planesDocs.map((doc) {
                            return DropdownMenuItem<String>(
                              value: doc.id,
                              onTap: () => _diasDelPlan = doc['dias'], // Guardamos los días para el cálculo
                              child: Text(doc.id, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _planSeleccionado = val),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _registrarEnFirebase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: miamiCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("FINALIZAR REGISTRO", 
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: miamiCyan),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: miamiCyan)),
      ),
    );
  }
}