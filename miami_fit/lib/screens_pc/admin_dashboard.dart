import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para guardar el nombre del gym
import 'package:miami_fit/screens_pc/view_articulos.dart';
import 'package:miami_fit/screens_pc/view_clientes.dart';
import 'package:miami_fit/screens_pc/view_planes.dart';
import 'package:miami_fit/screens_pc/view_register.dart'; // Verifica que el nombre sea correcto (registrar vs register)

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isCollapsed = false;
  int selectedIndex = 0;
  
  // Colores oficiales
  final Color miamiBlue = const Color(0xFF0A1A39);
  final Color miamiDarkBlue = const Color.fromARGB(255, 24, 52, 109);
  final Color miamiCyan = const Color(0xFF00AEEF);

  String gymName = "Miami Fit"; 
  bool isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGymName(); // Cargamos el nombre al iniciar
  }

  // Carga el nombre del gym desde Firebase
  void _loadGymName() async {
    var doc = await FirebaseFirestore.instance.collection('config').doc('gym_info').get();
    if (doc.exists) {
      setState(() => gymName = doc['nombre'] ?? "Miami Fit");
    }
  }

  // Guarda el nombre del gym en Firebase
  void _saveGymName(String name) async {
    await FirebaseFirestore.instance.collection('config').doc('gym_info').set({'nombre': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: miamiBlue, // CAMBIO: Ahora el fondo es oscuro por defecto
      body: Stack(
        children: [
          Row(
            children: [
              // --- BARRA LATERAL (SIDEBAR) ---
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isCollapsed ? 0 : 280,
                color: miamiDarkBlue,
                child: ClipRect(
                  child: OverflowBox(
                    minWidth: 280,
                    maxWidth: 280,
                    alignment: Alignment.centerLeft,
                    child: isCollapsed ? const SizedBox() : _buildSidebarContent(),
                  ),
                ),
              ),

              // --- CONTENIDO PRINCIPAL (DERECHA) ---
              Expanded(
                child: Container(
                  color: miamiBlue, // CAMBIO: Fondo oscuro para evitar destellos blancos
                  child: _buildMainContent(),
                ),
              ),
            ],
          ),

          // --- LA BOLITA CON FLECHA ---
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isCollapsed ? 10 : 265,
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: InkWell(
              onTap: () => setState(() => isCollapsed = !isCollapsed),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: miamiCyan,
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                ),
                child: Icon(
                  isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: isEditingName
                    ? TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: const InputDecoration(
                          isDense: true,
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            gymName = value;
                            isEditingName = false;
                            _saveGymName(value);
                          });
                        },
                      )
                    : Text(
                        gymName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              IconButton(
                icon: Icon(isEditingName ? Icons.check : Icons.edit, color: miamiCyan, size: 20),
                onPressed: () {
                  setState(() {
                    if (isEditingName) {
                      gymName = _nameController.text;
                      _saveGymName(gymName);
                    } else {
                      _nameController.text = gymName;
                    }
                    isEditingName = !isEditingName;
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24, height: 40),
        _menuOption(0, Icons.people, "Clientes"),
        _menuOption(1, Icons.person_add, "Registrar Cliente"),
        _menuOption(2, Icons.list_alt, "Planes"),
        _menuOption(3, Icons.shopping_bag, "Artículos")
      ],
    );
  }

  Widget _menuOption(int index, IconData icon, String title) {
    bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? miamiCyan : Colors.white60),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white60)),
      selected: isSelected,
      onTap: () => setState(() => selectedIndex = index),
    );
  }

  Widget _buildMainContent() {
    // Animación de transición suave entre vistas
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _getView(selectedIndex),
    );
  }

  Widget _getView(int index) {
    switch (index) {
      case 0: return const ViewClientes(key: ValueKey(0));
      case 1: return const ViewRegistrar(key: ValueKey(1));
      case 2: return const ViewPlanes(key: ValueKey(2));
      case 3: return const ViewArticulos(key: ValueKey(3));
      default: return const SizedBox();
    }
  }
}