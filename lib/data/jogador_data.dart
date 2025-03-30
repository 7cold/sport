class JogadorData {
  int? id;
  String? nome;
  String? foto;
  String? posicao;
  int? numero;
  bool? ativo;
  int? gols;
  int? jogos;
  int? assistencias;
  int? partidas;
  int? cartaoAmarelo;
  int? cartaoVermelho;

  JogadorData({
    this.id,
    this.nome,
    this.foto,
    this.posicao,
    this.numero,
    this.ativo,
    this.gols,
    this.jogos,
    this.assistencias,
    this.partidas,
    this.cartaoAmarelo,
    this.cartaoVermelho,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'foto': foto,
        'posicao': posicao,
        'numero': numero,
        'ativo': ativo,
        'gols': gols,
        'jogos': jogos,
        'assistencias': assistencias,
        'cardA': cartaoAmarelo,
        'cardV': cartaoVermelho,
      };

  JogadorData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    nome = json['nome'];
    foto = json['foto'];
    posicao = json['posicao'];
    numero = json['numero'];
    ativo = json['ativo'];
    gols = json['relacionados_jogo'] == []
        ? 0
        : json['relacionados_jogo'].fold(0, (soma, item) => soma + (item['gols'] ?? 0));
    jogos = json['relacionados_jogo'] == [] ? 0 : (json['relacionados_jogo'] ?? []).length;
    assistencias = json['relacionados_jogo'] == []
        ? 0
        : json['relacionados_jogo'].fold(0, (soma, item) => soma + (item['assistencias'] ?? 0));
    cartaoAmarelo = json['cardA'];
    cartaoVermelho = json['cardV'];
  }
}
