class RelacionadosjogoData {
  int? id;
  int? idJogador;
  int? idJogo;
  int? gols;
  int? assistencias;
  int? cardA;
  int? cardV;

  RelacionadosjogoData({
    this.id,
    this.idJogador,
    this.idJogo,
    this.gols,
    this.assistencias,
    this.cardA,
    this.cardV,
  });

  RelacionadosjogoData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    idJogador = json['id_jogador'];
    idJogo = json['id_jogo'];
    gols = json['gols'];
    assistencias = json['assistencias'];
    cardA = json['cardA'];
    cardV = json['cardV'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_jogador': idJogador,
        'id_jogo': idJogo,
        'gols': gols,
        'assistencias': assistencias,
        'cardA': cardA,
        'cardV': cardV,
      };
}
