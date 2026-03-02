import 'package:flutter/material.dart';
import 'package:miami_fit/screens_pc/view_articulos.dart';
import 'package:miami_fit/screens_pc/view_clientes.dart';
import 'package:miami_fit/screens_pc/view_planes.dart';
import 'package:miami_fit/screens_pc/view_register.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isCollapsed = false; // Estado para esconder/mostrar la barra
  int selectedIndex = 0;    // Para saber qué opción del menú está activa
  
  // Variables para el nombre del Gym
  String gymName = "Asignar nombre";
  bool isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Row(
            children: [
              // --- BARRA LATERAL (SIDEBAR) ---
              // --- DENTRO DE TU ROW EN EL BUILD ---
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut, // Animación más fluida
                width: isCollapsed ? 0 : 280,
                color: const Color.fromARGB(255, 24, 52, 109),
              // El secreto está en este ClipRect y el SingleChildScrollView
              child: ClipRect( 
                child: OverflowBox(
                  minWidth: 280, // Forzamos a que el contenido crea que siempre tiene 280
                  maxWidth: 280,
                  alignment: Alignment.centerLeft,
                  child: isCollapsed ? const SizedBox() : _buildSidebarContent(),
                ),
              ),
              ),

              // --- CONTENIDO PRINCIPAL (DERECHA) ---
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),

          // --- LA BOLITA CON FLECHA (Para esconder la barra) ---
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isCollapsed ? 10 : 265, // Se mueve según la barra
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: InkWell(
              onTap: () => setState(() => isCollapsed = !isCollapsed),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF00AEEF), // Azul cyan del logo
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
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

  // Contenido dentro de la barra lateral
  Widget _buildSidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 40),
        // SECCIÓN DEL NOMBRE EDITABLE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: isEditingName
                    ? TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: const InputDecoration(isDense: true),
                        onSubmitted: (value) {
                          setState(() {
                            gymName = value;
                            isEditingName = false;
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
                icon: Icon(isEditingName ? Icons.check : Icons.edit, color: const Color(0xFF00AEEF), size: 20),
                onPressed: () {
                  setState(() {
                    if (isEditingName) {
                      gymName = _nameController.text;
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
        
        // OPCIONES DEL MENÚ
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
      leading: Icon(icon, color: isSelected ? const Color(0xFF00AEEF) : Colors.white60),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white60)),
      selected: isSelected,
      onTap: () => setState(() => selectedIndex = index),
    );
  }

  // Lógica para cambiar lo que se ve a la derecha
  Widget _buildMainContent() {
    switch (selectedIndex) {
      case 0: return const ViewClientes();
      case 1: return const ViewRegistrar();
      case 2: return const ViewPlanes();
      case 3: return const ViewArticulos();
      default: return Container();
    }
  }
}