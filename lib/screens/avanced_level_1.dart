import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdvancedLevel1 extends StatefulWidget {
  @override
  _AdvancedLevel1State createState() => _AdvancedLevel1State();
}

class _AdvancedLevel1State extends State<AdvancedLevel1> {
  final List<Map<String, dynamic>> _items = [
    // Animais
    {'icon': FontAwesomeIcons.dog, 'name': 'cachorro', 'color': Colors.brown},
    {'icon': FontAwesomeIcons.cat, 'name': 'gato', 'color': Colors.grey},
    {'icon': FontAwesomeIcons.fish, 'name': 'peixe', 'color': Colors.blue},
    {'icon': FontAwesomeIcons.horse, 'name': 'cavalo', 'color': Colors.black},
    {'icon': FontAwesomeIcons.crow, 'name': 'corvo', 'color': Colors.black87},
    {'icon': FontAwesomeIcons.spider, 'name': 'aranha', 'color': Colors.red},
    // Objetos variados
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
  int? _selectedLeftIndex;
  Map<int, bool> _matched = {};
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
      _leftItems = List<Map<String, dynamic>>.from(_items..shuffle(random)).take(6).toList();
      _rightItems = List<Map<String, dynamic>>.from(_leftItems)..shuffle(random);
      _selectedLeftIndex = null;
      _matched = {};
      _showSuccessMessage = false;
    });
  }

  void _onLeftItemTap(int leftIndex) {
    setState(() {
      _selectedLeftIndex = leftIndex;
    });
  }

  void _onRightItemTap(int rightIndex) async {
    if (_selectedLeftIndex != null && _leftItems[_selectedLeftIndex!]['name'] == _rightItems[rightIndex]['name']) {
      // Caso de acerto: marca o item correto e fala o nome
      setState(() {
        _matched[rightIndex] = true;
        _selectedLeftIndex = null;
        if (_matched.length == _leftItems.length) {
          _showSuccessMessage = true;
        }
      });
      await _speakItemName(_rightItems[rightIndex]['name']);
    } else if (_selectedLeftIndex != null) {
      // Caso de erro: feedback de erro e fala "Ô não!"
      _showErrorFeedback();
    }
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
      backgroundColor: Color.fromARGB(255, 187, 179, 179),
      appBar: AppBar(
        title: Text("Nível Avançado 1"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_leftItems.length, (index) {
              return GestureDetector(
                onTap: () => _onLeftItemTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    border: _selectedLeftIndex == index
                        ? Border.all(color: Colors.blueAccent, width: 3.0)
                        : null,
                  ),
                  child: _buildItemIcon(
                    _leftItems[index]['icon'],
                    _leftItems[index]['color'],
                    60.0,
                  ),
                ),
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_rightItems.length, (index) {
              return GestureDetector(
                onTap: _matched.containsKey(index) ? null : () => _onRightItemTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _matched.containsKey(index) ? Colors.green : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  child: _buildItemIcon(
                    _rightItems[index]['icon'],
                    _matched.containsKey(index) ? Colors.green : Colors.grey,
                    60.0,
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
