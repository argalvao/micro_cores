import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdvancedLevel2 extends StatefulWidget {
  @override
  _AdvancedLevel2State createState() => _AdvancedLevel2State();
}

class _AdvancedLevel2State extends State<AdvancedLevel2> {
  final List<Map<String, dynamic>> _items = [
    // Animais e objetos variados
    {'icon': FontAwesomeIcons.dog, 'name': 'cachorro', 'color': Colors.brown},
    {'icon': FontAwesomeIcons.cat, 'name': 'gato', 'color': Colors.grey},
    {'icon': FontAwesomeIcons.fish, 'name': 'peixe', 'color': Colors.blue},
    {'icon': FontAwesomeIcons.horse, 'name': 'cavalo', 'color': Colors.black},
    {'icon': FontAwesomeIcons.crow, 'name': 'corvo', 'color': Colors.black87},
    {'icon': FontAwesomeIcons.spider, 'name': 'aranha', 'color': Colors.red},
    {'icon': FontAwesomeIcons.apple, 'name': 'maçã', 'color': Colors.red},
    {'icon': FontAwesomeIcons.car, 'name': 'carro', 'color': Colors.blueGrey},
    {'icon': FontAwesomeIcons.bicycle, 'name': 'bicicleta', 'color': Colors.orange},
    {'icon': FontAwesomeIcons.camera, 'name': 'câmera', 'color': Colors.purple},
    {'icon': FontAwesomeIcons.book, 'name': 'livro', 'color': Colors.green},
    {'icon': FontAwesomeIcons.chair, 'name': 'cadeira', 'color': Colors.brown},
    {'icon': FontAwesomeIcons.coffee, 'name': 'café', 'color': Colors.brown[700]!},
    {'icon': FontAwesomeIcons.plane, 'name': 'avião', 'color': Colors.blue},
    {'icon': FontAwesomeIcons.umbrella, 'name': 'guarda-chuva', 'color': Colors.deepPurple},
  ];

  final FlutterTts _flutterTts = FlutterTts();
  List<Map<String, dynamic>> _leftItems = [];
  List<Map<String, dynamic>> _rightItems = [];
  Map<int, bool> _matchedLeft = {};
  Set<int> _matchedRightIndices = {};
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _generateItems();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('pt-BR');
  }

  void _generateItems() {
    final random = Random();
    setState(() {
      _leftItems = List<Map<String, dynamic>>.from(_items..shuffle(random)).take(9).toList();
      _rightItems = List<Map<String, dynamic>>.from(_leftItems)..shuffle(random);
      _matchedLeft = {};
      _matchedRightIndices = {};
      _showSuccessMessage = false;
    });
  }

  Future<void> _speakItemName(String itemName) async {
    await _flutterTts.speak(itemName);
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
      appBar: AppBar(
        title: Text("Nível Avançado 2"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Lado Esquerdo: Objetos arrastáveis
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_leftItems.length, (index) {
              return Draggable<Map<String, dynamic>>(
                data: {'index': index, ..._leftItems[index]},
                feedback: Material(
                  child: _buildItemIcon(
                    _leftItems[index]['icon'],
                    _leftItems[index]['color'],
                    60.0,
                  ),
                ),
                childWhenDragging: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildItemIcon(
                    _leftItems[index]['icon'],
                    _matchedLeft.containsKey(index) ? Colors.green : _leftItems[index]['color'],
                    60.0,
                  ),
                ),
              );
            }),
          ),
          // Lado Direito: Alvos de arrastar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_rightItems.length, (index) {
              return DragTarget<Map<String, dynamic>>(
                onWillAccept: (data) {
                  bool isCorrect = data!['name'] == _rightItems[index]['name'];
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
                    if (_matchedLeft.length == _leftItems.length) {
                      _showSuccessMessage = true;
                    }
                  });
                  _speakItemName(data['name']); // Fala o nome do item ao soltar
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _matchedRightIndices.contains(index) ? Colors.green : Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    child: _buildItemIcon(
                      _rightItems[index]['icon'],
                      _matchedRightIndices.contains(index) ? Colors.green : Colors.grey,
                      60.0,
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
                  _generateItems();
                });
              },
              label: Text("Parabéns! Jogue novamente"),
              icon: Icon(Icons.refresh),
            )
          : null,
    );
  }

  Widget _buildItemIcon(IconData itemIcon, Color color, double size) {
    return Icon(itemIcon, color: color, size: size);
  }
}
