import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MediumLevel1 extends StatefulWidget {
  @override
  _MediumLevel1State createState() => _MediumLevel1State();
}

class _MediumLevel1State extends State<MediumLevel1> {
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
  int? _selectedLeftIndex;
  Map<int, bool> _matched = {};
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
      _selectedLeftIndex = null;
      _matched = {};
      _showSuccessMessage = false;
    });
  }

  void _onLeftAnimalTap(int leftIndex) {
    setState(() {
      _selectedLeftIndex = leftIndex;
    });
  }

  void _onRightAnimalTap(int rightIndex) async {
    if (_selectedLeftIndex != null && _leftAnimals[_selectedLeftIndex!]['name'] == _rightAnimals[rightIndex]['name']) {
      // Caso de acerto: marca o animal correto e fala o nome
      setState(() {
        _matched[rightIndex] = true;
        _selectedLeftIndex = null;
        if (_matched.length == _leftAnimals.length) {
          _showSuccessMessage = true;
        }
      });
      await _speakAnimalName(_rightAnimals[rightIndex]['name']);
    } else if (_selectedLeftIndex != null) {
      // Caso de erro: feedback de erro e fala "Ô não!"
      _showErrorFeedback();
    }
  }

  Future<void> _speakAnimalName(String animalName) async {
    await _flutterTts.speak(animalName);
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
        title: Text("Nível Médio 1"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_leftAnimals.length, (index) {
              return GestureDetector(
                onTap: () => _onLeftAnimalTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    border: _selectedLeftIndex == index
                        ? Border.all(color: Colors.blueAccent, width: 3.0)
                        : null,
                  ),
                  child: _buildAnimalIcon(
                    _leftAnimals[index]['animal'],
                    _leftAnimals[index]['color'],
                    80.0,
                  ),
                ),
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_rightAnimals.length, (index) {
              return GestureDetector(
                onTap: _matched.containsKey(index) ? null : () => _onRightAnimalTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _matched.containsKey(index) ? Colors.green : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  child: _buildAnimalIcon(
                    _rightAnimals[index]['animal'],
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
                  _generateAnimals();
                });
              },
              label: Text("Parabéns! Jogue novamente"),
              icon: Icon(Icons.refresh),
            )
          : null,
    );
  }

  Widget _buildAnimalIcon(IconData animalIcon, Color color, double size) {
    return Icon(animalIcon, color: color, size: size);
  }
}
