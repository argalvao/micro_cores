import 'package:flutter/material.dart';
import 'models/config.dart';
import 'screens/home_screen.dart';
import 'models/background_music_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/config_repository.dart';

Future<void> main() async {
  await Hive.initFlutter();

  final configuracoesRepository = ConfiguracoesRepository();
  final configuracoes = await configuracoesRepository.loadConfiguracoes();

  runApp(MicroCoresApp(configuracoes: configuracoes));
}

class MicroCoresApp extends StatefulWidget {
  final Configuracoes configuracoes;

  const MicroCoresApp({Key? key, required this.configuracoes}) : super(key: key);

  @override
  _MicroCoresAppState createState() => _MicroCoresAppState();
}

class _MicroCoresAppState extends State<MicroCoresApp> {
  late final BackgroundMusicManager _musicManager;

  @override
  void initState() {
    super.initState();

    print('Selected music styles: ${widget.configuracoes.estilosMusicais}');
    _musicManager = BackgroundMusicManager(
      selectedStyles: widget.configuracoes.estilosMusicais,
    );
    _musicManager.start();
  }

  @override
  void dispose() {
    _musicManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroCores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(configuracoes: widget.configuracoes),
    );
  }
}
