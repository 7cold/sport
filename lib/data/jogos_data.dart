class JogosData {
  int? id;
  DateTime? data;
  DateTime? hora;
  String? adversario;
  String? local;
  String? tipoJogo;
  int? placarLocal;
  int? placarAdversario;
  Map<String, dynamic>? escalacao;
  bool? emCasa;
  bool? isCancelado;
  int? uniforme;

  JogosData({
    this.id,
    this.data,
    this.hora,
    this.adversario,
    this.local,
    this.tipoJogo,
    this.placarLocal,
    this.placarAdversario,
    this.escalacao,
    this.isCancelado,
    this.emCasa,
    this.uniforme,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'hora': hora,
        'adversario': adversario,
        'local': local,
        'tipoJogo': tipoJogo,
        'placarLocal': placarLocal,
        'placarAdversario': placarAdversario,
        'escalacao': escalacao,
        'emCasa': emCasa,
        'isCancelado': isCancelado,
        'uniforme': uniforme
      };

  JogosData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    data = DateTime.parse(json['data']);
    hora = DateTime(0, 0, 0, int.parse(json['hora'].toString().substring(0, 2)),
        int.parse(json['hora'].toString().substring(3, 5)));
    adversario = json['adversario'];
    local = json['local'];
    tipoJogo = json['tipoJogo'];
    placarLocal = json['placarLocal'];
    placarAdversario = json['placarAdversario'];
    escalacao = json['escalacao'];
    emCasa = json['emCasa'];
    isCancelado = json['isCancelado'];
    uniforme = json['uniforme'];
  }
}
