import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:flutter/foundation.dart'; 

// Importaciones de tus pantallas
import 'package:miami_fit/screens_mobile/login_mobile.dart';
import 'package:miami_fit/screens_pc/login_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        scaffoldBackgroundColor: const Color(0xFF0A1A39), 
      ),
      home: const PlatformViewSelector(),
    );
  }
}

class PlatformViewSelector extends StatelessWidget {
  const PlatformViewSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Comentamos la validación de plataforma para forzar la vista móvil en la Web
    /*
    if (kIsWeb || MediaQuery.of(context).size.width > 900) {
      return const LoginScreen(); // Pantalla Admin
    } else {
      return const LoginMobile(); // Pantalla Público
    }
    */

    // Enlace directo a la versión móvil (clientes) para el despliegue Web
    return const LoginMobile(); 
  }
}