import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sport/HomeVisitante.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/data/relacionadosJogo_data.dart';
import 'package:sport/data/substituicoes_data.dart';
import 'package:sport/root.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class Controller extends GetxController {
  @override
  onInit() async {
    await loadData();
    super.onInit();
  }

  SupabaseClient supabase = Supabase.instance.client;

  RxBool loading = false.obs;

  DateFormat dateFormatterSimple = DateFormat('dd/MM/yyyy', 'pt_br');
  DateFormat dateFormatterSimple2 = DateFormat('dd/MM/yyyy - HH:mm', 'pt_br');
  DateFormat dateFormatterDiaSemana = DateFormat('EEEE', 'pt_br');
  DateFormat dateFormatterHora = DateFormat('HH:mm', 'pt_br');
  DateFormat dateFormatterAgenda = DateFormat('dd MMM y', 'pt_br');
  NumberFormat real = NumberFormat("#,##0.00", "pt_BR");

  RxList<JogosData> jogos = <JogosData>[].obs;
  RxList<SubstituicoesData> substituicoes = <SubstituicoesData>[].obs;
  RxList<JogadorData> jogadores = <JogadorData>[].obs;
  RxList<RelacionadosjogoData> relJogo = <RelacionadosjogoData>[].obs;
  List<String> tipoJogos = ["Amistoso", "Torneio", "Campeonato Municipal", "Campeonato Regional"];

  RxList<JogadorData> artilheiros = <JogadorData>[].obs;

  Future getJogos() async {
    loading.value = true;
    jogos.value = [];
    final data = await supabase.from('jogos').select();
    for (var x in data) {
      JogosData jogosData = JogosData.fromJson(x);
      jogos.add(jogosData);
    }
    sortJogos();
    loading.value = false;
  }

  Future getSubst() async {
    loading.value = true;
    substituicoes.value = [];
    final data = await supabase.from('substituicoes').select();
    for (var x in data) {
      SubstituicoesData subs = SubstituicoesData.fromJson(x);
      substituicoes.add(subs);
    }
    loading.value = false;
  }

  Future getJogadores() async {
    loading.value = true;

    jogadores.clear();
    final data = await supabase.from('plantel').select('*, relacionados_jogo(*)');
    for (var x in data) {
      JogadorData jogadorData = JogadorData.fromJson(x);
      jogadores.add(jogadorData);
    }

    sortJogadores();
    sortPosicao();

    loading.value = false;
  }

  JogosData proximoJogo() {
    return jogos
            .where((element) => element.data!.isAfter(DateTime.now().subtract(Duration(days: 1))))
            .firstOrNull ??
        JogosData();
  }

  JogosData ultimoJogo() {
    return jogos
            .where((element) => DateTime(element.data!.year, element.data!.month, element.data!.day)
                .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)))
            .firstOrNull ??
        JogosData();
  }

  getArtilheiro() {
    loading.value = true;
    artilheiros.value = [];

    for (var element in jogadores) {
      if (element.ativo == true) {
        artilheiros.add(element);
      }
    }

    artilheiros.sort((a, b) => b.gols!.compareTo(a.gols!));
    artilheiros.refresh();

    loading.value = false;
  }

  Future getRelacionadosJogo() async {
    loading.value = true;
    final data = await supabase.from('relacionados_jogo').select();

    for (var x in data) {
      RelacionadosjogoData relacionadosjogoData = RelacionadosjogoData.fromJson(x);
      relJogo.add(relacionadosjogoData);
    }

    loading.value = false;
  }

  JogadorData searchJogador(int id) {
    if (id == 0) return JogadorData(nome: "-");

    return jogadores.where((element) => element.id == id).first;
  }

  num getNumGols(int idJogador, int idJogo) {
    num gols = 0;

    relJogo
        .where((element) => element.idJogador == idJogador)
        .where((element) => element.idJogo == idJogo)
        .forEach((element) => gols = gols + (element.gols ?? 0));

    return gols;
  }

  num getNumCV(int idJogador, int idJogo) {
    num cv = 0;

    relJogo
        .where((element) => element.idJogador == idJogador)
        .where((element) => element.idJogo == idJogo)
        .forEach((element) => cv = cv + (element.cardV ?? 0));

    return cv;
  }

  num getNumCA(int idJogador, int idJogo) {
    num ca = 0;

    relJogo
        .where((element) => element.idJogador == idJogador)
        .where((element) => element.idJogo == idJogo)
        .forEach((element) => ca = ca + (element.cardA ?? 0));

    return ca;
  }

  List<JogadorData> getJogadoresMarcaram(JogosData jogo) {
    List<JogadorData> list = [];

    relJogo
        .where((p0) => p0.idJogo == jogo.id)
        .where((element) => element.gols != 0)
        .forEach((element) => list.add(searchJogador(element.idJogador ?? 0)));

    return list;
  }

  List getSubstituicoes(JogosData jogo) {
    List list = [];

    substituicoes.where((p0) => p0.jogosData == jogo.id).forEach((element) {
      list.add(element);
    });

    return list;
  }

  num getNumJogos(int idJogador) {
    return relJogo.where((element) => element.idJogador == idJogador).length;
  }

  num getNumAssistencias(int idJogador, int idJogo) {
    num assistencias = 0;

    relJogo
        .where((element) => element.idJogador == idJogador)
        .where((element) => element.idJogo == idJogo)
        .forEach((element) => assistencias = assistencias + (element.assistencias ?? 0));

    return assistencias;
  }

  bool searchJogadorInEscalacao(int id, Map<String, dynamic> escalacao) {
    bool test = false;

    if (id == 0) return false;

    escalacao.forEach((key, value) {
      if (value == id) {
        test = true;
      }
    });

    return test;
  }

  Future deleteRelJogo(RelacionadosjogoData r) async {
    loading.value = true;
    await supabase.from('relacionados_jogo').delete().eq('id', r.id ?? 0);
    relJogo.removeWhere((element) => element.id == r.id);
    loading.value = false;
  }

  Future deleteJogo(JogosData jData) async {
    loading.value = true;
    await supabase.from('jogos').delete().eq('id', jData.id ?? 0);
    jogos.removeWhere((element) => element.id == jData.id);
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Deletado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    loading.value = false;
  }

  Future deleteJogador(JogadorData jData) async {
    loading.value = true;
    await supabase.from('plantel').delete().eq('id', jData.id ?? 0);
    jogadores.removeWhere((element) => element.id == jData.id);
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Deletado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    loading.value = false;
  }

  Future createJogo(JogosData jogosData) async {
    loading.value = true;
    var data = await supabase.from('jogos').insert({
      "data": jogosData.data!.toIso8601String(),
      "hora": dateFormatterHora.format(
        DateTime(
          2024,
          1,
          1,
          jogosData.hora!.hour,
          jogosData.hora!.minute,
        ),
      ),
      "adversario": jogosData.adversario,
      "local": jogosData.local,
      "tipoJogo": jogosData.tipoJogo,
      "placarLocal": 0,
      "placarAdversario": 0,
      "emCasa": jogosData.emCasa,
      "uniforme": jogosData.uniforme,
      "isCancelado": jogosData.isCancelado,
      "escalacao": {
        "GOL": null,
        "LD": null,
        "LE": null,
        "DEFD": null,
        "DEFE": null,
        "VOLD": null,
        "VOLE": null,
        "MEID": null,
        "MEIE": null,
        "ATAD": null,
        "ATAE": null
      },
    }).select();
    jogosData.id = data[0]['id'];
    jogos.add(jogosData);
    sortJogos();
    loading.value = false;
    Get.forceAppUpdate();
    Get.back();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createSubst(SubstituicoesData subs) async {
    loading.value = true;
    var data = await supabase.from('substituicoes').insert({
      "id_jogador_sai": subs.idJogadorSai!.id,
      "id_jogador_entra": subs.idJogadorEntra!.id,
      "id_partida": subs.jogosData,
    }).select();
    subs.id = data[0]['id'];
    substituicoes.add(subs);
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createRelJogo(RelacionadosjogoData r) async {
    loading.value = true;
    var data = await supabase.from('relacionados_jogo').insert({
      "id_jogador": r.idJogador,
      "id_jogo": r.idJogo,
      "gols": r.gols,
      "assistencias": r.assistencias,
      "cardA": r.cardA,
      "cardV": r.cardV,
    }).select();
    r.id = data[0]['id'];
    relJogo.add(r);
    loading.value = false;
  }

  Future createJogador(JogadorData jogadorData) async {
    loading.value = true;

    var data = await supabase.from('plantel').insert({
      "nome": jogadorData.nome,
      "numero": jogadorData.numero,
      "posicao": jogadorData.posicao,
      "ativo": true,
      "foto": jogadorData.foto,
    }).select();

    jogadorData.id = data[0]['id'];
    jogadores.add(jogadorData);

    sortJogadores();
    sortPosicao();

    Get.back();

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    loading.value = false;
  }

  Future editEscalacao(JogosData jData) async {
    loading.value = true;
    await supabase
        .from('jogos')
        .update({
          "escalacao": jData.escalacao,
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogos.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });

    loading.value = false;
  }

  Future cancelarJogo(JogosData jData) async {
    loading.value = true;

    await supabase
        .from('jogos')
        .update({
          "isCancelado": jData.isCancelado,
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogos.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });

    jogos.refresh();
    Get.forceAppUpdate();
    loading.value = false;
  }

  changeUniforme(JogosData jData) async {
    loading.value = true;
    await supabase
        .from('jogos')
        .update({
          "uniforme": jData.uniforme,
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogos.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });
    jogos.refresh();
    loading.value = false;
  }

  changePlacar(JogosData jData) async {
    loading.value = true;
    await supabase
        .from('jogos')
        .update({
          "placarLocal": jData.placarLocal,
          "placarAdversario": jData.placarAdversario,
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogos.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });
    jogos.refresh();
    loading.value = false;
  }

  incrementGolsJogador(RelacionadosjogoData r) async {
    loading.value = true;

    await supabase
        .from('relacionados_jogo')
        .update({"gols": r.gols})
        .eq('id', r.id ?? 0)
        .then((value) {
          relJogo.where((p0) => p0.id == r.id).forEach((e) => e = r);
        });

    await getArtilheiro();

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Alterado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  incrementAssistJogador(RelacionadosjogoData r) async {
    loading.value = true;

    await supabase
        .from('relacionados_jogo')
        .update({"assistencias": r.assistencias})
        .eq('id', r.id ?? 0)
        .then((value) {
          relJogo.where((p0) => p0.id == r.id).forEach((e) => e = r);
        });

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Editado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  incrementCV(RelacionadosjogoData r) async {
    loading.value = true;

    await supabase
        .from('relacionados_jogo')
        .update({"cardV": r.cardV})
        .eq('id', r.id ?? 0)
        .then((value) {
          relJogo.where((p0) => p0.id == r.id).forEach((e) => e = r);
        });

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Editado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  incrementCA(RelacionadosjogoData r) async {
    loading.value = true;

    await supabase
        .from('relacionados_jogo')
        .update({"cardA": r.cardA})
        .eq('id', r.id ?? 0)
        .then((value) {
          relJogo.where((p0) => p0.id == r.id).forEach((e) => e = r);
        });

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Editado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  sortJogadores() {
    jogadores.sort((a, b) => a.numero!.compareTo(b.numero ?? 0));
  }

  sortPosicao() {
    const ordemPosicoes = {
      'GOL': 0,
      'LD': 1,
      'LE': 2,
      'DEF': 3,
      'VOL': 4,
      'MEI': 5,
      'ATA': 6,
    };

    // Ordenando pela ordem personalizada
    jogadores.sort((a, b) {
      int prioridadeA = ordemPosicoes[a.posicao] ?? double.maxFinite.toInt();
      int prioridadeB = ordemPosicoes[b.posicao] ?? double.maxFinite.toInt();
      return prioridadeA.compareTo(prioridadeB);
    });
  }

  Future editJogador(JogadorData jData) async {
    loading.value = true;
    await supabase
        .from('plantel')
        .update({
          "nome": jData.nome,
          "numero": jData.numero,
          "posicao": jData.posicao,
          "foto": jData.foto,
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogadores.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });

    sortJogadores();
    sortPosicao();

    Get.back();

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Editado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  Future editPartida(JogosData jData) async {
    loading.value = true;
    await supabase
        .from('jogos')
        .update({
          "adversario": jData.adversario,
          "local": jData.local,
          "data": jData.data!.toIso8601String(),
          "hora": dateFormatterHora.format(
            DateTime(
              2024,
              1,
              1,
              jData.hora!.hour,
              jData.hora!.minute,
            ),
          ),
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogos.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });
    Get.forceAppUpdate();
    jogos.refresh();

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Editado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  sortJogos() {
    jogos.sort((a, b) => b.data!.compareTo(a.data!));
  }

  Future inativarJogador(JogadorData jData) async {
    loading.value = true;
    await supabase
        .from('plantel')
        .update({
          "ativo": jData.ativo,
        })
        .eq('id', jData.id ?? 0)
        .then((value) {
          jogadores.where((p0) => p0.id == jData.id).forEach((e) => e = jData);
        });

    sortJogadores();
    sortPosicao();

    Get.back();

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Jogador Alterado!"),
      autoCloseDuration: const Duration(seconds: 5),
    );

    loading.value = false;
  }

  login(String userx, String pass) async {
    try {
      await supabase.auth.signInWithPassword(
        email: userx,
        password: pass,
      );

      Get.offAll(const Root());
    } on AuthException catch (e) {
      if (e.statusCode == "400") {
        Get.snackbar("Error", "E-mail ou Senhas Icorretos!", backgroundColor: Colors.amber);
      }
    }
  }

  logout() async {
    loading.value = true;
    await supabase.auth.signOut();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Logout efetuado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    Get.offAll(const HomeVisitante());
    loading.value = false;
  }

  loadData() async {
    await getJogos();
    await getJogadores();
    await getRelacionadosJogo();
    await getArtilheiro();
    await getSubst();
  }
}
