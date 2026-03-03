import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Este archivo se crea al ejecutar 'flutterfire configure'
import 'package:flutter/foundation.dart'; // Para kIsWeb

// Importaciones de tus pantallas
import 'package:miami_fit/screens_mobile/login_mobile.dart';
import 'package:miami_fit/screens_pc/login_screens.dart';

void main() async {
  // Aseguramos que Flutter esté listo antes de iniciar Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Firebase con las opciones generadas
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Error inicializando Firebase: $e");
  }

  runApp(const MiamiFitApp());
}

class MiamiFitApp extends StatelessWidget {
  const MiamiFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miami Fit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00AEEF),
        scaffoldBackgroundColor: const Color(0xFF0A1A39), // Color oficial Miami Fit
      ),
      // Lógica para decidir qué login mostrar
      home: const PlatformViewSelector(),
    );
  }
}

// Este pequeño widget decide si mostrar la versión móvil o PC
class PlatformViewSelector extends StatelessWidget {
  const PlatformViewSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Si estamos en Web o si el ancho de pantalla es mayor a 900px (PC)
    if (kIsWeb || MediaQuery.of(context).size.width > 900) {
      return const LoginScreen(); // Pantalla Admin
    } else {
      return const LoginMobile(); // Pantalla Público
    }
  }
}