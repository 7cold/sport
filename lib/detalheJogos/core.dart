import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/relacionadosJogo_data.dart';
import 'package:sport/plantel/core.dart';
import '../data/jogador_data.dart';
import '../data/jogos_data.dart';
import '../data/substituicoes_data.dart';

RxMap<String, dynamic> escalacao = {
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
  "ATAE": null,
}.obs;

substituicoesDialog(BuildContext context, JogosData jogosData, JogadorData jogadorData) {
  Rxn<JogadorData> sai = Rxn<JogadorData>(jogadorData);
  final Controller c = Get.find();
  Rxn<JogadorData> entra = c.substituicoes
              .where((element) =>
                  element.idJogadorSai?.id == jogadorData.id && element.jogosData == jogosData.id)
              .firstOrNull
              ?.idJogadorEntra
              ?.nome ==
          null
      ? Rxn<JogadorData>()
      : Rxn<JogadorData>(c.substituicoes
          .where((element) =>
              element.idJogadorSai?.id == jogadorData.id && element.jogosData == jogosData.id)
          .firstOrNull
          ?.idJogadorEntra);

  return showFDialog<void>(
    context: context,
    builder: (context, _, __) {
      return FDialog(
        title: const Text("Substituições"),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                FSelect<JogadorData>.searchBuilder(
                  enabled: false,
                  hint: sai.value!.nome ?? "",
                  format: (jogador) => jogador.nome ?? "",
                  filter: (query) {
                    final lista = c.jogadores.where((j) => j.ativo == true);
                    if (query.isEmpty) return lista;
                    return lista.where(
                      (j) => j.nome.toString().toLowerCase().contains(query.toLowerCase()),
                    );
                  },
                  contentBuilder: (context, controller, jogadoresFiltrados) => [
                    for (final jogador in jogadoresFiltrados)
                      FSelectItem<JogadorData>(
                        value: jogador,
                        title: Text(jogador.nome ?? ""),
                        subtitle: Text("${jogador.posicao}"),
                      ),
                  ],
                  onChange: (jogadorSelecionado) {
                    sai.value = jogadorSelecionado;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FSelect<JogadorData>.searchBuilder(
                    hint: "Entra",
                    format: (jogador) => jogador.nome ?? "",
                    filter: (query) {
                      final relacionados = c.jogadores.where((element) => c.relJogo
                          .where((e) => e.idJogador == element.id)
                          .where((e) => e.idJogo == jogosData.id)
                          .isNotEmpty);
                      if (query.isEmpty) return relacionados;
                      return relacionados.where(
                        (j) => j.nome.toString().toLowerCase().contains(query.toLowerCase()),
                      );
                    },
                    contentBuilder: (context, controller, jogadoresFiltrados) => [
                      for (final jogador in jogadoresFiltrados)
                        FSelectItem<JogadorData>(
                          value: jogador,
                          title: Text(jogador.nome ?? ""),
                          subtitle: Text("${jogador.posicao}"),
                        ),
                    ],
                    onChange: (jogadorSelecionado) {
                      entra.value = jogadorSelecionado;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Sair"),
          ),
          FButton(
            onPress: () async {
              await c.createSubst(SubstituicoesData(
                idJogadorEntra: entra.value,
                idJogadorSai: sai.value,
                jogosData: jogosData.id,
              ));
              Get.back();
            },
            child: const Text("Salvar"),
          ),
        ],
      );
    },
  );
}

editPartida(BuildContext context, JogosData jData, Controller c) {
  TextEditingController adversario = TextEditingController(text: jData.adversario);
  TextEditingController local = TextEditingController(text: jData.local);
  TimeOfDay? hora =
      jData.hora != null ? TimeOfDay(hour: jData.hora!.hour, minute: jData.hora!.minute) : null;
  DateTime? date = jData.data;

  return showFDialog<void>(
    context: context,
    builder: (context, _, __) {
      return FDialog(
        title: const Text("Editar"),
        body: SingleChildScrollView(
          child: SizedBox(
            width: context.isPhone ? Get.width : context.width / 3,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FTextField(
                    controller: adversario,
                    label: Text("Adversario"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FTextField(
                    controller: local,
                    label: Text("Local"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FDateField(
                    label: Text('Data'),
                    initialDate: jData.data ?? DateTime.now(),
                    onChange: (pickedDate) {
                      if (pickedDate != null) {
                        date = pickedDate;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FTimeField(
                    initialTime: FTime(hora!.hour, hora!.minute),
                    hour24: true,
                    label: Text('Hora'),
                    onChange: (pickedDate) {
                      if (pickedDate != null) {
                        hora = TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          FButton(
            onPress: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"),
          ),
          FButton(
            onPress: () {
              jData.adversario = adversario.text;
              jData.local = local.text;
              jData.data = date;
              jData.hora = DateTime(0, 0, 0, hora!.hour, hora!.minute);
              c.editPartida(jData);
              Navigator.of(context).pop();
            },
            child: const Text("Salvar"),
          ),
        ],
      );
    },
  );
}

cancelarDialog(BuildContext context, JogosData jData, Controller c) {
  return showFDialog<void>(
    context: context,
    builder: (context, _, __) {
      return FDialog(
        title: const Text("Cancelar Partida?"),
        actions: [
          FButton(
            style: FButtonStyle.ghost(),
            onPress: () {
              Navigator.of(context).pop();
            },
            child: const Text("Voltar"),
          ),
          FButton(
            onPress: () async {
              jData.isCancelado = true;
              await c.cancelarJogo(jData);
              Get.back();
            },
            child: const Text("Sim"),
          ),
        ],
      );
    },
  );
}

relacionados(BuildContext context, Controller c, JogosData jogosData) {
  RxBool ativos = true.obs;
  return showFDialog(
    context: context,
    builder: (context, _, __) {
      return Obx(
        () => FDialog(
          actions: [],
          body: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FSwitch(
                          label: Text("Ativos"),
                          value: ativos.value,
                          onChange: (_) {
                            ativos.value = !ativos.value;
                          }),
                    ),
                    FButton(
                        onPress: () {
                          cadastroJogador(context);
                        },
                        child: Text("Criar Jogador"))
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: c.jogadores.where((element) => element.ativo == ativos.value).map((e) {
                    RxBool select = c.relJogo
                        .where((element) => element.idJogador == e.id)
                        .where((element) => element.idJogo == jogosData.id)
                        .isNotEmpty
                        .obs;

                    return SizedBox(
                      width: double.infinity,
                      child: FCard(
                        image: FAvatar(image: NetworkImage(e.foto ?? "")),
                        title: Row(
                          children: [
                            Text(e.nome ?? ""),
                            Spacer(),
                            Transform.scale(
                                scale: 0.70,
                                child: FSwitch(
                                    value: select.value,
                                    onChange: c.loading.value == true
                                        ? null
                                        : (_) async {
                                            if (select.value) {
                                              if (c.searchJogadorInEscalacao(
                                                      e.id ?? 0, escalacao) ==
                                                  true) {
                                                for (var element in escalacao.keys) {
                                                  if (escalacao[element] == e.id) {
                                                    escalacao[element] = 0;
                                                  }
                                                }
                                              }

                                              await c.deleteRelJogo(
                                                RelacionadosjogoData.fromJson({
                                                  "id": c.relJogo
                                                      .where((element) => element.idJogador == e.id)
                                                      .where((element) =>
                                                          element.idJogo == jogosData.id)
                                                      .first
                                                      .id,
                                                  "id_jogador": e.id,
                                                  "id_jogo": jogosData.id,
                                                  "gols": e.gols,
                                                  "assistencias": e.assistencias,
                                                  "cardA": e.cartaoAmarelo,
                                                  "cardV": e.cartaoVermelho,
                                                }),
                                              );
                                            } else {
                                              await c.createRelJogo(RelacionadosjogoData.fromJson({
                                                "id_jogo": jogosData.id,
                                                "id_jogador": e.id,
                                                "gols": 0,
                                                "assistencias": 0,
                                                "cardA": 0,
                                                "cardV": 0,
                                              }));
                                            }
                                          })),
                          ],
                        ),
                        subtitle: Text("${e.posicao}"),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

showModalOpcoes(context, JogadorData e, JogosData jogosData, TextEditingController placarLocal) {
  final Controller c = Get.find();

  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton.icon(
                        onPressed: c.getNumGols(e.id ?? 0, jogosData.id ?? 0) == 0
                            ? null
                            : () async {
                                jogosData.placarLocal = jogosData.placarLocal! - 1;
                                placarLocal.text = jogosData.placarLocal.toString();

                                await c.changePlacar(jogosData);

                                RelacionadosjogoData relacionadosjogoData = c.relJogo
                                    .where((p0) => p0.idJogador == e.id)
                                    .where((p0) => p0.idJogo == jogosData.id)
                                    .first;

                                relacionadosjogoData.gols = relacionadosjogoData.gols! - 1;

                                e.gols = e.gols! - 1;

                                c.jogadores.refresh();
                                c.relJogo.refresh();

                                await c.incrementGolsJogador(relacionadosjogoData);

                                Get.back();
                              },
                        label: Text("- 1 Gol"),
                        icon: Icon(Icons.sports_soccer_rounded)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton.icon(
                        onPressed: c.getNumAssistencias(e.id ?? 0, jogosData.id ?? 0) == 0
                            ? null
                            : () async {
                                RelacionadosjogoData relacionadosjogoData = c.relJogo
                                    .where((p0) => p0.idJogador == e.id)
                                    .where((p0) => p0.idJogo == jogosData.id)
                                    .first;

                                relacionadosjogoData.assistencias =
                                    relacionadosjogoData.assistencias! - 1;

                                e.assistencias = e.assistencias! - 1;

                                c.jogadores.refresh();
                                c.relJogo.refresh();

                                await c.incrementAssistJogador(relacionadosjogoData);

                                Get.back();
                              },
                        label: Text("- 1 Assistência"),
                        icon: Icon(Icons.text_decrease)),
                  ),
                ],
              ),
            );
          },
        );
      });
}

incrementGol(JogosData jogosData, JogadorData e, TextEditingController placarLocal) async {
  final Controller c = Get.find();
  jogosData.placarLocal = jogosData.placarLocal! + 1;
  placarLocal.text = jogosData.placarLocal.toString();
  await c.changePlacar(jogosData);

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.gols = relacionadosjogoData.gols! + 1;

  e.gols = e.gols! + 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementGolsJogador(relacionadosjogoData);
}

decrementGol(JogosData jogosData, JogadorData e, TextEditingController placarLocal) async {
  final Controller c = Get.find();
  jogosData.placarLocal = jogosData.placarLocal! - 1;
  placarLocal.text = jogosData.placarLocal.toString();
  await c.changePlacar(jogosData);

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.gols = relacionadosjogoData.gols! - 1;

  e.gols = e.gols! - 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementGolsJogador(relacionadosjogoData);
}

incrementAssist(
  JogosData jogosData,
  JogadorData e,
) async {
  final Controller c = Get.find();

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.assistencias = relacionadosjogoData.assistencias! + 1;

  e.assistencias = e.assistencias! + 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementAssistJogador(relacionadosjogoData);
}

deincrementAssist(
  JogosData jogosData,
  JogadorData e,
) async {
  final Controller c = Get.find();

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.assistencias = relacionadosjogoData.assistencias! - 1;

  e.assistencias = e.assistencias! - 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementAssistJogador(relacionadosjogoData);
}

deincrementCV(
  JogosData jogosData,
  JogadorData e,
) async {
  final Controller c = Get.find();

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.cardV = relacionadosjogoData.cardV! - 1;

  e.cartaoVermelho = e.cartaoVermelho! - 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementCV(relacionadosjogoData);
}

incrementCV(
  JogosData jogosData,
  JogadorData e,
) async {
  final Controller c = Get.find();

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.cardV = relacionadosjogoData.cardV! + 1;

  e.cartaoVermelho = e.cartaoVermelho! + 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementCV(relacionadosjogoData);
}

deincrementCA(
  JogosData jogosData,
  JogadorData e,
) async {
  final Controller c = Get.find();

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.cardA = relacionadosjogoData.cardA! - 1;

  e.cartaoAmarelo = e.cartaoAmarelo! - 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementCA(relacionadosjogoData);
}

incrementCA(
  JogosData jogosData,
  JogadorData e,
) async {
  final Controller c = Get.find();

  RelacionadosjogoData relacionadosjogoData =
      c.relJogo.where((p0) => p0.idJogador == e.id).where((p0) => p0.idJogo == jogosData.id).first;

  relacionadosjogoData.cardA = relacionadosjogoData.cardA! + 1;

  e.cartaoAmarelo = e.cartaoAmarelo! + 1;
  c.relJogo.refresh();
  c.jogadores.refresh();

  await c.incrementCA(relacionadosjogoData);
}

bonecoRelacionados(JogosData jogosData, JogadorData e) {
  final Controller c = Get.find();
  return Padding(
    padding: const EdgeInsets.only(top: 6, left: 10),
    child: Tooltip(
      message: c.substituicoes
                  .where((element) =>
                      element.idJogadorEntra?.id == e.id && element.jogosData == jogosData.id)
                  .firstOrNull
                  ?.idJogadorSai
                  ?.nome ==
              null
          ? ""
          : "Sai: ${c.substituicoes.where((element) => element.idJogadorEntra?.id == e.id && element.jogosData == jogosData.id).firstOrNull?.idJogadorSai?.nome}",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Badge(
            isLabelVisible: c.substituicoes
                        .where((element) =>
                            element.idJogadorEntra?.id == e.id && element.jogosData == jogosData.id)
                        .firstOrNull
                        ?.idJogadorEntra
                        ?.nome ==
                    null
                ? false
                : true,
            backgroundColor: Colors.transparent,
            alignment: Alignment.centerRight,
            label: Icon(
              Icons.arrow_upward,
              color: Colors.green.shade800,
              size: 16,
            ),
            child: Badge(
              largeSize: 10,
              padding: EdgeInsets.all(2),
              isLabelVisible: c.getNumGols(e.id ?? 0, jogosData.id ?? 0) == 0 ? false : true,
              label: Text(
                c.getNumGols(e.id ?? 0, jogosData.id ?? 0).toString(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              child: Image.asset(
                jogosData.uniforme == 1
                    ? 'assets/images/mini1.png'
                    : jogosData.uniforme == 2
                        ? 'assets/images/mini2.png'
                        : 'assets/images/mini3.png',
                scale: 9,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
