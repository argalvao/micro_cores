import 'package:flutter/material.dart';
import 'models/config.dart';
import 'models/config_repository.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  // Inicializa o Hive
  await Hive.initFlutter();

  // Carrega as configurações salvas ou cria uma nova instância com valores padrão
  final configuracoesRepository = ConfiguracoesRepository();
  final configuracoes = await configuracoesRepository.loadConfiguracoes();

  // Executa o app com as configurações carregadas
  runApp(MicroCoresApp(configuracoes: configuracoes));
}

class MicroCoresApp extends StatelessWidget {
  final Configuracoes configuracoes;

  const MicroCoresApp({Key? key, required this.configuracoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroCores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(configuracoes: configuracoes), // HomeScreen é usada aqui
    );
  }
}
