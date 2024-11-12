import 'dart:ui';
import 'dart:math';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import '../models/config.dart';

class ColorParticle extends Particle {
  final double size;
  Color color;

  ColorParticle(this.color)
      : size = 10.0,
        super();

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(0, 0), size / 2, paint);
  }

  @override
  void update(double time) {}
}

class SettingsScreen extends StatefulWidget {
  final Configuracoes configuracoes;

  const SettingsScreen({Key? key, required this.configuracoes}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late String _corPreferida;
  late bool _musicaCalma;
  late String _capacidadeMotora;
  late bool _fala;
  late List<String> _estilosMusicais;
  late List<String> _objetosPreferidos;

  @override
  void initState() {
    super.initState();
    _corPreferida = widget.configuracoes.corPreferida;
    _musicaCalma = widget.configuracoes.musicaCalma;
    _capacidadeMotora = ''; // Inicializa como string vazia
    _fala = widget.configuracoes.fala;
    _estilosMusicais = List.from(widget.configuracoes.estilosMusicais);
    _objetosPreferidos = List.from(widget.configuracoes.objetosPreferidos);
  }

  void _salvarConfiguracoes() {
    widget.configuracoes.corPreferida = _corPreferida;
    widget.configuracoes.musicaCalma = _musicaCalma;
    widget.configuracoes.capacidadeMotora = _capacidadeMotora;
    widget.configuracoes.fala = _fala;
    widget.configuracoes.estilosMusicais = List.from(_estilosMusicais);
    widget.configuracoes.objetosPreferidos = List.from(_objetosPreferidos);

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

  final List<Color> _rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  Color _generateRandomRainbowColor() {
    return _rainbowColors[Random().nextInt(_rainbowColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 187, 179, 179),
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
            baseColor: _generateRandomRainbowColor(),
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
              // Capacidade Motora
              Text("Capacidade Motora:", style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: _capacidadeMotora.isEmpty ? null : _capacidadeMotora,
                hint: Text("Selecione a capacidade motora"),
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
                  ),
                  ElevatedButton(
                    onPressed: _salvarConfiguracoes,
                    child: Text("Salvar"),
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
