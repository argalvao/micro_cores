import 'package:flutter/material.dart';
import '../models/config.dart';
import 'basic_level_1.dart';
import 'basic_level_2.dart';
import 'medium_level_1.dart';
import 'medium_level_2.dart';
import 'avanced_level_1.dart';
import 'avanced_level_2.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Configuracoes configuracoes;

  LevelSelectionScreen({required this.configuracoes});

  // Função para determinar o nível habilitado com base nas configurações
  String determinarNivel() {
    if (configuracoes.capacidadeMotora == 'Limitada') {
      return configuracoes.objetosPreferidos.length <= 10 ? 'Básico 1' : 'Básico 2';
    } else if (configuracoes.capacidadeMotora == 'Moderada') {
      return configuracoes.objetosPreferidos.length <= 10 ? 'Médio 1' : 'Médio 2';
    } else if (configuracoes.capacidadeMotora == 'Boa') {
      return configuracoes.objetosPreferidos.length <= 10 ? 'Avançado 1' : 'Avançado 2';
    }
    return 'Básico 1'; // Padrão para evitar erros
  }

  @override
  Widget build(BuildContext context) {
    String nivelHabilitado = determinarNivel();

    return Scaffold(
      appBar: AppBar(
        title: Text('Seleção de Nível'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
          childAspectRatio: 1.0,
          children: [
            _buildLevelButton(context, 'Básico 1', nivelHabilitado == 'Básico 1'),
            _buildLevelButton(context, 'Básico 2', nivelHabilitado == 'Básico 2'),
            _buildLevelButton(context, 'Médio 1', nivelHabilitado == 'Médio 1'),
            _buildLevelButton(context, 'Médio 2', nivelHabilitado == 'Médio 2'),
            _buildLevelButton(context, 'Avançado 1', nivelHabilitado == 'Avançado 1'),
            _buildLevelButton(context, 'Avançado 2', nivelHabilitado == 'Avançado 2'),
          ],
        ),
      ),
    );
  }

  // Função para construir os botões de nível
  Widget _buildLevelButton(BuildContext context, String nivel, bool isEnabled) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10.0), backgroundColor: isEnabled
            ? Color.fromARGB(255, 218, 191, 191)
            : Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: isEnabled
          ? () {
              if (nivel == 'Básico 1') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicLevel1(),
                  ),
                );
              }else if(nivel == 'Básico 2'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicLevel2(),
                  ),
                );
              }else if(nivel == 'Médio 1'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediumLevel1(),
                  ),
                );
              }else if(nivel == 'Médio 2'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediumLevel2(),
                  ),
                );
              }else if(nivel == 'Avançado 1'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdvancedLevel1(),
                  ),
                );
              }else if(nivel == 'Avançado 2'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdvancedLevel2(),
                  ),
                );
              }
            }
          : null,
      child: Text(
        nivel,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isEnabled ? Colors.black87 : Colors.white70,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
