class Configuracoes {
  String corPreferida;
  bool musicaCalma;
  String capacidadeMotora;
  bool fala;
  List<String> estilosMusicais;
  List<String> objetosPreferidos;

  Configuracoes({
    this.corPreferida = 'Azul',
    this.musicaCalma = true,
    this.capacidadeMotora = 'Boa',
    this.fala = true,
    this.estilosMusicais = const ['Infantil'],
    this.objetosPreferidos = const ['Cachorro'],
  });

  Map<String, dynamic> toMap() {
    return {
      'corPreferida': corPreferida,
      'musicaCalma': musicaCalma,
      'capacidadeMotora': capacidadeMotora,
      'fala': fala,
      'estilosMusicais': estilosMusicais,
      'objetosPreferidos': objetosPreferidos,
    };
  }

  factory Configuracoes.fromMap(Map<String, dynamic> map) {
    return Configuracoes(
      corPreferida: map['corPreferida'] ?? 'Azul',
      musicaCalma: map['musicaCalma'] ?? true,
      capacidadeMotora: map['capacidadeMotora'] ?? 'Boa',
      fala: map['fala'] ?? true,
      estilosMusicais: List<String>.from(map['estilosMusicais'] ?? ['Infantil']),
      objetosPreferidos: List<String>.from(map['objetosPreferidos'] ?? ['Cachorro']),
    );
  }

  // Método para verificar se as configurações essenciais estão completas
  bool isComplete() {
    return capacidadeMotora.isNotEmpty && objetosPreferidos.isNotEmpty;
  }
}
