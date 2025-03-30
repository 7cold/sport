import 'package:get/get.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/data/jogos_data.dart';

import '../controller/controller.dart';

class SubstituicoesData {
  final Controller c = Get.put(Controller());

  int? id;
  JogadorData? idJogadorSai;
  JogadorData? idJogadorEntra;
  int? jogosData;

  SubstituicoesData({
    this.id,
    this.idJogadorSai,
    this.idJogadorEntra,
    this.jogosData,
  });

  SubstituicoesData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;

    jogosData = json['id_partida'] ?? 0;

    idJogadorSai = c.jogadores.where((element) => element.id == json['id_jogador_sai']).firstOrNull;
    idJogadorEntra =
        c.jogadores.where((element) => element.id == json['id_jogador_entra']).firstOrNull;
  }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'id_jogador': idJogador,
  //       'id_jogo': idJogo,
  //       'gols': gols,
  //       'assistencias': assistencias,
  //       'cardA': cardA,
  //       'cardV': cardV,
  //     };
}
