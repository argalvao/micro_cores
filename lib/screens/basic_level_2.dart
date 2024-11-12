import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/shape_painters.dart';

class BasicLevel2 extends StatefulWidget {
  @override
  _BasicLevel2State createState() => _BasicLevel2State();
}

class _BasicLevel2State extends State<BasicLevel2> {
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
  Map<int, bool> _matchedLeft = {}; // Armazena o estado de combinação apenas do lado esquerdo
  Set<int> _matchedRightIndices = {}; // Conjunto para armazenar os índices combinados do lado direito
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
      _matchedLeft = {};
      _matchedRightIndices = {};
      _showSuccessMessage = false;
    });
  }

  Future<void> _speakShapeName(String shapeName) async {
    await _flutterTts.speak(shapeName);
  }

  Future<void> _speakErrorMessage() async {
    await _flutterTts.speak("Ô não!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nível Básico 2"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Lado Esquerdo: Objetos arrastáveis
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_leftShapes.length, (index) {
              return Draggable<Map<String, dynamic>>(
                data: {'index': index, ..._leftShapes[index]},
                feedback: Material(
                  child: _buildShape(
                    _leftShapes[index]['shape'],
                    _leftShapes[index]['color'],
                    80.0,
                  ),
                ),
                childWhenDragging: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: _buildShape(
                    _leftShapes[index]['shape'],
                    _matchedLeft.containsKey(index) ? Colors.green : _leftShapes[index]['color'],
                    80.0,
                  ),
                ),
              );
            }),
          ),
          // Lado Direito: Alvos de arrastar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_rightShapes.length, (index) {
              return DragTarget<Map<String, dynamic>>(
                onWillAccept: (data) {
                  bool isCorrect = data!['shape'] == _rightShapes[index]['shape'];
                  if (!isCorrect) {
                    _showErrorFeedback(); // Exibe mensagem de erro se o item não corresponde
                  }
                  return isCorrect;
                },
                onAccept: (data) {
                  setState(() {
                    int leftIndex = data['index'];
                    _matchedLeft[leftIndex] = true; // Marca o objeto no lado esquerdo
                    _matchedRightIndices.add(index); // Marca o índice no lado direito
                    if (_matchedLeft.length == _leftShapes.length) {
                      _showSuccessMessage = true;
                    }
                  });
                  _speakShapeName(data['shape']); // Fala o nome do objeto ao soltar
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _matchedRightIndices.contains(index) ? Colors.green : Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    child: _buildShape(
                      _rightShapes[index]['shape'],
                      _matchedRightIndices.contains(index) ? Colors.green : Colors.grey,
                      80.0,
                    ),
                  );
                },
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

  void _showErrorFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ô não!'), backgroundColor: Colors.red),
    );
    _speakErrorMessage();
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
