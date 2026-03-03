import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewClientes extends StatefulWidget {
  const ViewClientes({super.key});

  @override
  State<ViewClientes> createState() => _ViewClientesState();
}

class _ViewClientesState extends State<ViewClientes> {
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiCyan = const Color(0xFF00AEEF);
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue,
      body: Stack(
        children: [
          // --- 1. MARCA DE AGUA ---
          Center(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'assets/LOGO.jpeg',
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // --- 2. CONTENIDO ---
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("GESTIÓN DE CLIENTES",
                    style: TextStyle(color: miamiCyan, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildTableHeader(),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('clientes').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No hay clientes", style: TextStyle(color: Colors.white54)));
                      }

                      final docs = snapshot.data!.docs.where((doc) {
                        final nombre = doc['nombre'].toString().toLowerCase();
                        final cedula = doc['cedula'].toString().toLowerCase();
                        return nombre.contains(_searchQuery) || cedula.contains(_searchQuery);
                      }).toList();

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final docId = docs[index].id;
                          
                          int diasRestantes = 0;
                          final dynamic fFinRaw = data['fechaFin'];
                          if (fFinRaw is Timestamp) {
                            final int msFin = fFinRaw.millisecondsSinceEpoch;
                            final int msAhora = DateTime.now().millisecondsSinceEpoch;
                            diasRestantes = ((msFin - msAhora) / 86400000).ceil();
                          }
                          if (diasRestantes < 0) diasRestantes = 0;

                          return _buildClientRow(data, diasRestantes, docId);
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

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: miamiCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text("NOMBRE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("CÉDULA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("PLAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("DÍAS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          SizedBox(width: 80, child: Text("ESTADO", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          SizedBox(width: 110, child: Text("ACCIONES", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildClientRow(Map<String, dynamic> data, int dias, String id) {
    final bool estaActivo = dias > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data['nombre'] ?? '', style: const TextStyle(color: Colors.white))),
          Expanded(flex: 1, child: Text(data['cedula'] ?? '', style: const TextStyle(color: Colors.white70))),
          Expanded(flex: 1, child: Text(data['plan'] ?? '', style: TextStyle(color: miamiCyan))),
          Expanded(flex: 1, child: Text("$dias d", style: TextStyle(color: dias < 5 ? Colors.orangeAccent : Colors.white))),
          
          // Estado
          SizedBox(
            width: 80,
            child: Icon(
              estaActivo ? Icons.check_circle : Icons.error,
              color: estaActivo ? Colors.greenAccent : Colors.redAccent,
              size: 20,
            ),
          ),

          // --- BOTONES DE ACCIÓN ---
          SizedBox(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // BOTÓN DE RENOVAR (+)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
                  tooltip: "Renovar Plan",
                  onPressed: () => _showRenovarDialog(id, data['nombre']),
                ),
                // BOTÓN DE ELIMINAR
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white24),
                  onPressed: () => _confirmarEliminar(id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DIÁLOGO PARA RENOVAR PLAN
  void _showRenovarDialog(String docId, String nombreCliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A1A39),
        title: Text("Renovar Plan: $nombreCliente", style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 300,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('planes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: snapshot.data!.docs.map((planDoc) {
                  final planData = planDoc.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(planDoc.id, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${planData['dias']} días", style: const TextStyle(color: Colors.white54)),
                    trailing: Icon(Icons.add, color: miamiCyan),
                    onTap: () async {
                      // Calcular nueva fecha: Hoy + días del plan
                      DateTime nuevaFecha = DateTime.now().add(Duration(days: planData['dias']));
                      await FirebaseFirestore.instance.collection('clientes').doc(docId).update({
                        'plan': planDoc.id,
                        'fechaFin': Timestamp.fromDate(nuevaFecha),
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("¡Plan renovado con éxito!")),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Buscar...",
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(Icons.search, color: miamiCyan),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  void _confirmarEliminar(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: miamiBlue,
        title: const Text("Eliminar", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('clientes').doc(id).delete();
              Navigator.pop(context);
            },
            child: const Text("ELIMINAR", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}