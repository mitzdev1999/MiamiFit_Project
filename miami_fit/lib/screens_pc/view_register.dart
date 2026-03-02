import 'package:flutter/material.dart';

class ViewRegistrar extends StatefulWidget {
  const ViewRegistrar({super.key});

  @override
  State<ViewRegistrar> createState() => _ViewRegistrarState();
}

class _ViewRegistrarState extends State<ViewRegistrar> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar el texto
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  
  String? _planSeleccionado;
  
  // Lista temporal de planes (Luego vendrá de Firebase)
  final List<String> _planesDisponibles = ['Mensual', 'Quincenal', 'Anual', 'Día'];

  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Stack(
        children: [
          // MARCA DE AGUA AL FONDO
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('assets/LOGO.jpeg', width: 400),
            ),
          ),
          
          // FORMULARIO
          Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NUEVO CLIENTE",
                        style: TextStyle(color: miamiCyan, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      
                      _buildLabel("Número de Cédula"),
                      _buildTextField(_cedulaController, "Ej: 10203040", Icons.badge),
                      
                      const SizedBox(height: 20),
                      
                      _buildLabel("Nombre Completo"),
                      _buildTextField(_nombreController, "Ej: Juan Pérez", Icons.person),
                      
                      const SizedBox(height: 20),
                      
                      _buildLabel("Seleccionar Plan"),
                      _buildDropdown(),
                      
                      const SizedBox(height: 40),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _guardarCliente,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: miamiCyan,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("REGISTRAR CLIENTE", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: miamiCyan, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.black26,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: miamiCyan)),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _planSeleccionado,
          hint: const Text("Elige un plan", style: TextStyle(color: Colors.white24)),
          dropdownColor: miamiBlue,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: miamiCyan),
          items: _planesDisponibles.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() { _planSeleccionado = newValue; });
          },
        ),
      ),
    );
  }

  void _guardarCliente() {
    if (_formKey.currentState!.validate() && _planSeleccionado != null) {
      // Aquí irá la lógica para enviar a Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Guardando en la base de datos...")),
      );
    }
  }
}