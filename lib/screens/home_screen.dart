// home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/pixel_art_painter.dart';
import 'settings_screen.dart';
import 'level_selection_screen.dart'; // Import da tela de seleção de nível
import '../models/config.dart';

class HomeScreen extends StatefulWidget {
  final Configuracoes configuracoes;

  HomeScreen({required this.configuracoes});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  double cloudOffsetX = 0.0;
  double rainOffsetX = 0.0;
  bool isConfigComplete = false; // Variável para monitorar a completude das configurações

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    // Verifique se as configurações estão completas
    _checkConfigCompletion();

    // Animação das nuvens e chuva
    _controller.addListener(() {
      setState(() {
        cloudOffsetX = (cloudOffsetX + 1) % 400;
        rainOffsetX = (rainOffsetX + 2) % 400;
      });
    });
  }

  void _checkConfigCompletion() {
    setState(() {
      isConfigComplete = widget.configuracoes.isComplete();
    });
  }

  // Abre a tela de seleção de nível
  void _openLevelSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelSelectionScreen(configuracoes: widget.configuracoes),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PixelArtPainter(cloudOffsetX: cloudOffsetX, rainOffsetX: rainOffsetX),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MicroCores - Sons e Movimentos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Comic Sans MS',
                    ),
                  ),
                  SizedBox(height: 30),
                  // Botão JOGAR que depende de isConfigComplete
                  _buildButton(context, 'JOGAR', Icons.play_arrow, isConfigComplete ? _openLevelSelection : null),
                  _buildButton(context, 'CONFIGURAÇÕES', Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(configuracoes: widget.configuracoes),
                      ),
                    ).then((_) => _checkConfigCompletion()); // Verifica novamente após a configuração
                  }),
                  _buildButton(context, 'AJUDA', Icons.help, () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Color.fromARGB(255, 218, 191, 191),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black87),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(color: Colors.black87, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
