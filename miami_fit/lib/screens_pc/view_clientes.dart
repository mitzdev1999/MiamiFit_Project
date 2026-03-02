import 'dart:async';
import 'package:flutter/material.dart';

class ViewClientes extends StatefulWidget {
  const ViewClientes({super.key});

  @override
  State<ViewClientes> createState() => _ViewClientesState();
}

class _ViewClientesState extends State<ViewClientes> {
  Timer? _debounce;
  String searchQuery = "";
  
  // Colores del tema Miami Fit
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      setState(() { searchQuery = query; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Stack(
        children: [
          // --- CAPA 1: EL LOGO COMO MARCA DE AGUA ---
          Center(
            child: Opacity(
              opacity: 0.1, // Muy bajito para que no moleste la lectura
              child: Image.asset(
                'assets/LOGO.jpeg',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // --- CAPA 2: EL CONTENIDO DE LA LISTA ---
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // BUSCADOR ESTILIZADO
                TextField(
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Buscar cliente por nombre o cédula...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: Icon(Icons.search, color: miamiCyan),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: miamiCyan),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // TABLA EXCEL
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.white10, // Líneas divisorias sutiles
                    ),
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingTextStyle: TextStyle(color: miamiCyan, fontWeight: FontWeight.bold, fontSize: 16),
                        dataTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
                        columns: const [
                          DataColumn(label: Text('Cédula')),
                          DataColumn(label: Text('Nombre Completo')),
                          DataColumn(label: Text('Plan')),
                          DataColumn(label: Text('Días Restantes')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: _buildRows(), // Aquí llamarías a tu lógica de filtrado
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildRows() {
    // Ejemplo rápido de una fila
    return [
      DataRow(cells: [
        const DataCell(Text("12345678")),
        const DataCell(Text("Usuario de Prueba")),
        const DataCell(Text("Plan Premium")),
        const DataCell(Text("15 días")),
        DataCell(Icon(Icons.add_circle, color: miamiCyan)),
      ]),
    ];
  }
}