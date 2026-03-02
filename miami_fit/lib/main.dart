import 'package:flutter/material.dart';
import 'package:miami_fit/screens_mobile/login_mobile.dart';
import 'package:miami_fit/screens_pc/login_screens.dart';

void main() {
  runApp(const MiamiFitApp());
}

class MiamiFitApp extends StatelessWidget {
  const MiamiFitApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miami Fit Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00AEEF),
      ),
      home: const LoginMobile(),
    );
  }
}