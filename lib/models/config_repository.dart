import 'package:hive/hive.dart';
import 'config.dart';

class ConfiguracoesRepository {
  static const String boxName = 'configuracoesBox';

  Future<void> saveConfiguracoes(Configuracoes config) async {
    final box = await Hive.openBox(boxName);
    await box.put('configuracoes', config.toMap());
    await box.close();
  }

  Future<Configuracoes> loadConfiguracoes() async {
    final box = await Hive.openBox(boxName);

    // Corrige o tipo retornado para garantir que seja Map<String, dynamic>
    final dynamic data = box.get('configuracoes');
    await box.close();

    if (data == null) {
      return Configuracoes(); // Retorna valores padrão se não houver nada salvo
    }

    if (data is Map<dynamic, dynamic>) {
      // Converte explicitamente para Map<String, dynamic>
      return Configuracoes.fromMap(Map<String, dynamic>.from(data));
    } else {
      throw Exception("Dados salvos não são do tipo esperado.");
    }
  }
}
