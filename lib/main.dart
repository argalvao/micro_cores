import 'package:flutter/material.dart';
import 'models/config.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MicroCoresApp());
}

class MicroCoresApp extends StatelessWidget {
  final Configuracoes configuracoes = Configuracoes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroCores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(configuracoes: configuracoes),
    );
  }
}
