class TipojogosData {
  int? id;
  String? tipoJogo;

  TipojogosData({
    this.id,
    this.tipoJogo,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipoJogo': tipoJogo,
      };

  TipojogosData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    tipoJogo = json['tipoJogo'];
  }
}
