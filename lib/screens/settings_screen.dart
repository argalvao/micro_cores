import 'dart:ui';
import 'dart:math';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import '../models/config.dart';

// Classe ColorParticle para partículas coloridas
class ColorParticle extends Particle {
  final double size;
  Color color;

  ColorParticle(this.color)
      : size = 10.0, // Tamanho da partícula
        super();

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(0, 0), size / 2, paint);
  }

  @override
  void update(double time) {
    
  }
}

class SettingsScreen extends StatefulWidget {
  final Configuracoes configuracoes;

  const SettingsScreen({Key? key, required this.configuracoes}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late double _nivelDificuldade;
  late String _corPreferida;
  late bool _musicaCalma;
  late String _capacidadeMotora;
  late bool _fala;
  late double _capacidadeVisao;
  late List<String> _estilosMusicais;
  late List<String> _objetosPreferidos;

  @override
  void initState() {
    super.initState();
    _nivelDificuldade = widget.configuracoes.nivelDificuldade;
    _corPreferida = widget.configuracoes.corPreferida;
    _musicaCalma = widget.configuracoes.musicaCalma;
    _capacidadeMotora = widget.configuracoes.capacidadeMotora;
    _fala = widget.configuracoes.fala;
    _capacidadeVisao = widget.configuracoes.capacidadeVisao;
    _estilosMusicais = List.from(widget.configuracoes.estilosMusicais);
    _objetosPreferidos = List.from(widget.configuracoes.objetosPreferidos);
  }

  void _salvarConfiguracoes() {
    widget.configuracoes.nivelDificuldade = _nivelDificuldade;
    widget.configuracoes.corPreferida = _corPreferida;
    widget.configuracoes.musicaCalma = _musicaCalma;
    widget.configuracoes.capacidadeMotora = _capacidadeMotora;
    widget.configuracoes.fala = _fala;
    widget.configuracoes.capacidadeVisao = _capacidadeVisao;
    widget.configuracoes.estilosMusicais = List.from(_estilosMusicais);
    widget.configuracoes.objetosPreferidos = List.from(_objetosPreferidos);
    
    // Mostra um snackbar de feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Configurações salvas com sucesso!")),
    );

    Navigator.pop(context);
  }

  void _toggleEstiloMusical(String estilo) {
    setState(() {
      if (_estilosMusicais.contains(estilo)) {
        _estilosMusicais.remove(estilo);
      } else {
        _estilosMusicais.add(estilo);
      }
    });
  }

  void _toggleObjetoPreferido(String objeto) {
    setState(() {
      if (_objetosPreferidos.contains(objeto)) {
        _objetosPreferidos.remove(objeto);
      } else {
        _objetosPreferidos.add(objeto);
      }
    });
  }

  // Define as cores do arco-íris
  final List<Color> _rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo, // Anil
    Colors.purple, // Violeta
  ];

  // Gera uma cor aleatória do arco-íris
  Color _generateRandomRainbowColor() {
    return _rainbowColors[Random().nextInt(_rainbowColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            baseColor: _generateRandomRainbowColor(), // Usa uma cor aleatória do arco-íris
            spawnMinSpeed: 10,
            spawnMaxSpeed: 100,
            spawnMinRadius: 5,
            spawnMaxRadius: 15,
            particleCount: 30,
          ),
        ),
        vsync: this,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nível de dificuldade:", style: TextStyle(fontSize: 18)),
              Slider(
                value: _nivelDificuldade,
                onChanged: (newValue) {
                  setState(() {
                    _nivelDificuldade = newValue;
                  });
                },
                min: 0,
                max: 1,
                divisions: 5,
                label: _nivelDificuldade < 0.3
                    ? "Fácil"
                    : _nivelDificuldade < 0.7
                        ? "Médio"
                        : "Difícil",
              ),
              SizedBox(height: 20),

              // Capacidade Motora
              Text("Capacidade Motora:", style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: _capacidadeMotora,
                onChanged: (String? newValue) {
                  setState(() {
                    _capacidadeMotora = newValue!;
                  });
                },
                items: <String>['Boa', 'Moderada', 'Limitada']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Fala
              Text("A criança fala?", style: TextStyle(fontSize: 18)),
              Switch(
                value: _fala,
                onChanged: (bool value) {
                  setState(() {
                    _fala = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Capacidade de Visão
              Text("Capacidade de Visão:", style: TextStyle(fontSize: 18)),
              Slider(
                value: _capacidadeVisao,
                onChanged: (newValue) {
                  setState(() {
                    _capacidadeVisao = newValue;
                  });
                },
                min: 0,
                max: 1,
                divisions: 5,
                label: _capacidadeVisao < 0.3
                    ? "Baixa"
                    : _capacidadeVisao < 0.7
                        ? "Moderada"
                        : "Boa",
              ),
              SizedBox(height: 20),

              // Estilos Musicais Preferidos
              Text("Estilos Musicais Preferidos:", style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 10,
                children: [
                  'Infantil', 'Calmo', 'Animado', 'Instrumental'
                ].map((estilo) => CheckboxListTile(
                      title: Text(estilo),
                      value: _estilosMusicais.contains(estilo),
                      onChanged: (_) => _toggleEstiloMusical(estilo),
                    )).toList(),
              ),
              SizedBox(height: 20),

              // Tipos de objetos preferidos
              Text("Tipos de objetos preferidos:", style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 10,
                children: [
                  'Cachorro', 'Gato', 'Pássaro', 'Peixe',
                  'Círculo', 'Quadrado', 'Triângulo', 'Estrela',
                  'Bola', 'Carro', 'Flor', 'Sol', 'Lua', 'Nuvem',
                  'Balão', 'Borboleta', 'Arco-íris', 'Pipa', 'Avião',
                  'Maçã', 'Banana', 'Laranja', 'Morango'
                ].map((objeto) => CheckboxListTile(
                      title: Text(objeto),
                      value: _objetosPreferidos.contains(objeto),
                      onChanged: (_) => _toggleObjetoPreferido(objeto),
                    )).toList(),
              ),
              SizedBox(height: 30),

              // Botões de Voltar e Salvar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Voltar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _salvarConfiguracoes,
                    child: Text("Salvar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
