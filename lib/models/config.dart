class Configuracoes {
  double nivelDificuldade;
  String corPreferida;
  bool musicaCalma;
  String capacidadeMotora;
  bool fala;
  double capacidadeVisao;
  List<String> estilosMusicais;
  List<String> objetosPreferidos;

  Configuracoes({
    this.nivelDificuldade = 0.5,
    this.corPreferida = 'Azul',
    this.musicaCalma = true,
    this.capacidadeMotora = 'Boa',
    this.fala = true,
    this.capacidadeVisao = 1.0,
    this.estilosMusicais = const ['Infantil'],
    this.objetosPreferidos = const ['Cachorro'],
  });

  // Função para verificar se as configurações essenciais estão completas
  bool isComplete() {
    // Verifica se a capacidade motora foi definida e se há pelo menos um objeto preferido selecionado
    return capacidadeMotora.isNotEmpty && objetosPreferidos.isNotEmpty;
  }
}
