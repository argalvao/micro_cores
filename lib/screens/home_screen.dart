// home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/pixel_art_painter.dart';
import 'settings_screen.dart';
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

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    // Animate clouds and rain
    _controller.addListener(() {
      setState(() {
        cloudOffsetX = (cloudOffsetX + 1) % 400; // 400 can be adjusted for speed
        rainOffsetX = (rainOffsetX + 2) % 400; // Adjust rain speed
      });
    });
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
                  _buildButton(context, 'JOGAR', Icons.play_arrow, () {
                    // Adicione a ação do botão "Jogar" aqui
                  }),
                  _buildButton(context, 'CONFIGURAÇÕES', Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(configuracoes: widget.configuracoes),
                      ),
                    );
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

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
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
            backgroundColor: Color.fromARGB(255, 218, 191, 191), // Cor neutra para os botões
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black87), // Ícone com cor escura
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
