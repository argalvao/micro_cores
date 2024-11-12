import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MediumLevel2 extends StatefulWidget {
  @override
  _MediumLevel2State createState() => _MediumLevel2State();
}

class _MediumLevel2State extends State<MediumLevel2> {
  final List<Map<String, dynamic>> _animals = [
    {'animal': FontAwesomeIcons.dog, 'name': 'cachorro', 'color': Colors.brown},
    {'animal': FontAwesomeIcons.cat, 'name': 'gato', 'color': Colors.grey},
    {'animal': FontAwesomeIcons.fish, 'name': 'peixe', 'color': Colors.blue},
    {'animal': FontAwesomeIcons.horse, 'name': 'cavalo', 'color': Colors.black},
    {'animal': FontAwesomeIcons.crow, 'name': 'corvo', 'color': Colors.black87},
    {'animal': FontAwesomeIcons.dove, 'name': 'pombo', 'color': Colors.white54},
    {'animal': FontAwesomeIcons.spider, 'name': 'aranha', 'color': Colors.red},
    {'animal': FontAwesomeIcons.frog, 'name': 'sapo', 'color': Colors.green},
    {'animal': FontAwesomeIcons.hippo, 'name': 'hipopótamo', 'color': Colors.purple},
  ];

  final FlutterTts _flutterTts = FlutterTts();
  List<Map<String, dynamic>> _leftAnimals = [];
  List<Map<String, dynamic>> _rightAnimals = [];
  Map<int, bool> _matchedLeft = {};
  Set<int> _matchedRightIndices = {};
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _generateAnimals();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('pt-BR');
  }

  void _generateAnimals() {
    final random = Random();
    setState(() {
      _leftAnimals = List<Map<String, dynamic>>.from(_animals..shuffle(random)).take(3).toList();
      _rightAnimals = List<Map<String, dynamic>>.from(_leftAnimals)..shuffle(random);
      _matchedLeft = {};
      _matchedRightIndices = {};
      _showSuccessMessage = false;
    });
  }

  Future<void> _speakAnimalName(String animalName) async {
    await _flutterTts.speak(animalName);
  }

  Future<void> _speakErrorMessage() async {
    await _flutterTts.speak("Ô não!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 187, 179, 179),
      appBar: AppBar(
        title: Text("Nível Médio 2"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Lado Esquerdo: Objetos arrastáveis
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_leftAnimals.length, (index) {
              return Draggable<Map<String, dynamic>>(
                data: {'index': index, ..._leftAnimals[index]},
                feedback: Material(
                  child: _buildAnimalIcon(
                    _leftAnimals[index]['animal'],
                    _leftAnimals[index]['color'],
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
                  child: _buildAnimalIcon(
                    _leftAnimals[index]['animal'],
                    _matchedLeft.containsKey(index) ? Colors.green : _leftAnimals[index]['color'],
                    80.0,
                  ),
                ),
              );
            }),
          ),
          // Lado Direito: Alvos de arrastar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_rightAnimals.length, (index) {
              return DragTarget<Map<String, dynamic>>(
                onWillAccept: (data) {
                  bool isCorrect = data!['name'] == _rightAnimals[index]['name'];
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
                    if (_matchedLeft.length == _leftAnimals.length) {
                      _showSuccessMessage = true;
                    }
                  });
                  _speakAnimalName(data['name']); // Fala o nome do animal ao soltar
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
                    child: _buildAnimalIcon(
                      _rightAnimals[index]['animal'],
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
                  _generateAnimals();
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

  Widget _buildAnimalIcon(IconData animalIcon, Color color, double size) {
    return Icon(animalIcon, color: color, size: size);
  }
}
