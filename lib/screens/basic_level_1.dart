import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/shape_painters.dart';

class BasicLevel1 extends StatefulWidget {
  @override
  _BasicLevel1State createState() => _BasicLevel1State();
}

class _BasicLevel1State extends State<BasicLevel1> {
  final List<Map<String, dynamic>> _primaryShapes = [
    {'shape': 'triângulo', 'color': Colors.red},
    {'shape': 'quadrado', 'color': Colors.blue},
    {'shape': 'círculo', 'color': Colors.yellow},
    {'shape': 'pentágono', 'color': Colors.green},
    {'shape': 'hexágono', 'color': Colors.orange},
    {'shape': 'estrela', 'color': Colors.purple},
    {'shape': 'cruz', 'color': Colors.pink},
    {'shape': 'losango', 'color': Colors.cyan},
    {'shape': 'trapézio', 'color': Colors.teal},
  ];

  final FlutterTts _flutterTts = FlutterTts();
  List<Map<String, dynamic>> _leftShapes = [];
  List<Map<String, dynamic>> _rightShapes = [];
  int? _selectedLeftIndex;
  Map<int, bool> _matched = {};
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _generateShapes();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('pt-BR');
  }

  void _generateShapes() {
    final random = Random();
    setState(() {
      _leftShapes = List<Map<String, dynamic>>.from(
          _primaryShapes..shuffle(random)).take(3).toList();
      _rightShapes = List<Map<String, dynamic>>.from(_leftShapes)..shuffle(random);
      _selectedLeftIndex = null;
      _matched = {};
      _showSuccessMessage = false;
    });
  }

  void _onLeftShapeTap(int leftIndex) {
    setState(() {
      _selectedLeftIndex = leftIndex;
    });
  }

  void _onRightShapeTap(int rightIndex) async {
    if (_selectedLeftIndex != null &&
        _leftShapes[_selectedLeftIndex!] == _rightShapes[rightIndex]) {
      // Caso de acerto: marcar correto e falar o nome do objeto
      setState(() {
        _matched[rightIndex] = true;
        _selectedLeftIndex = null;
        if (_matched.length == _leftShapes.length) {
          _showSuccessMessage = true;
        }
      });
      await _speakShapeName(_rightShapes[rightIndex]['shape']); // Fala o nome do objeto correto
    } else if (_selectedLeftIndex != null) {
      // Caso de erro: mostrar feedback de erro e falar "Ô não!"
      _showErrorFeedback();
    }
  }

  Future<void> _speakShapeName(String shapeName) async {
    await _flutterTts.speak(shapeName);
  }

  Future<void> _speakErrorMessage() async {
    await _flutterTts.speak("Ô não!");
  }

  void _showErrorFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ô não!'), backgroundColor: Colors.red),
    );
    _speakErrorMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 187, 179, 179),
      appBar: AppBar(
        title: Text("Nível Básico 1"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_leftShapes.length, (index) {
              return GestureDetector(
                onTap: () => _onLeftShapeTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    border: _selectedLeftIndex == index
                        ? Border.all(color: Colors.blueAccent, width: 3.0)
                        : null,
                  ),
                  child: _buildShape(
                    _leftShapes[index]['shape'],
                    _leftShapes[index]['color'],
                    80.0,
                  ),
                ),
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_rightShapes.length, (index) {
              return GestureDetector(
                onTap: _matched.containsKey(index)
                    ? null
                    : () => _onRightShapeTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _matched.containsKey(index)
                          ? Colors.green
                          : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  child: _buildShape(
                    _rightShapes[index]['shape'],
                    _matched.containsKey(index) ? Colors.green : Colors.grey,
                    80.0,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: _showSuccessMessage
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _generateShapes();
                });
              },
              label: Text("Parabéns! Jogue novamente"),
              icon: Icon(Icons.refresh),
            )
          : null,
    );
  }

  Widget _buildShape(String shape, Color color, double size) {
    switch (shape) {
      case 'triângulo':
        return CustomPaint(
          painter: TrianglePainter(color),
          child: Container(width: size, height: size),
        );
      case 'quadrado':
        return Container(width: size, height: size, color: color);
      case 'círculo':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        );
      case 'pentágono':
        return CustomPaint(
          painter: PentagonPainter(color),
          child: Container(width: size, height: size),
        );
      case 'hexágono':
        return CustomPaint(
          painter: HexagonPainter(color),
          child: Container(width: size, height: size),
        );
      case 'estrela':
        return CustomPaint(
          painter: StarPainter(color),
          child: Container(width: size, height: size),
        );
      case 'cruz':
        return CustomPaint(
          painter: CrossPainter(color),
          child: Container(width: size, height: size),
        );
      case 'losango':
        return CustomPaint(
          painter: DiamondPainter(color),
          child: Container(width: size, height: size),
        );
      case 'trapézio':
        return CustomPaint(
          painter: TrapezoidPainter(color),
          child: Container(width: size, height: size),
        );
      default:
        return Container();
    }
  }
}
