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
}