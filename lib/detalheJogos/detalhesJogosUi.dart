import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/data/substituicoes_data.dart';
import 'package:sport/detalheJogos/core.dart';
import 'package:sport/resumoPartida.dart';

class DetalhesJogosUi extends StatefulWidget {
  @override
  State<DetalhesJogosUi> createState() => _DetalhesJogosUiState();
}

class _DetalhesJogosUiState extends State<DetalhesJogosUi> {
  Rx<TextEditingController> placarLocal = TextEditingController().obs;
  Rx<TextEditingController> placarAdversario = TextEditingController().obs;
  RxInt uniforme = (0).obs;
  final ScrollController scrollController = ScrollController();
  bool isDragging = false;
  JogosData jogosData = Get.arguments;
  final Controller c = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void autoScroll(Offset position) {
    final screenHeight = MediaQuery.of(context).size.height;
    const scrollThreshold = 100.0;
    const scrollSpeed = 20.0;
    if (position.dy < scrollThreshold && scrollController.offset > 0) {
      scrollController.jumpTo(
        (scrollController.offset - scrollSpeed).clamp(
          0.0,
          scrollController.position.maxScrollExtent,
        ),
      );
    } else if (position.dy > screenHeight - scrollThreshold &&
        scrollController.offset < scrollController.position.maxScrollExtent) {
      scrollController.jumpTo(
        (scrollController.offset + scrollSpeed).clamp(
          0.0,
          scrollController.position.maxScrollExtent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    placarLocal.value.text = jogosData.placarLocal.toString();
    placarAdversario.value.text = jogosData.placarAdversario.toString();
    uniforme.value = jogosData.uniforme ?? 0;
    escalacao = jogosData.escalacao?.obs ?? <String, int>{}.obs;

    return Obx(() {
      return FScaffold(
        header: FHeader.nested(
          titleAlignment: Alignment.centerLeft,
          prefixes: [
            FHeaderAction.back(onPress: () {
              Get.back();
            })
          ],
          title: Text('Detalhes do Jogo'),
          suffixes: [
            FHeaderAction(
              icon: Icon(FIcons.x),
              onPress: jogosData.isCancelado == true
                  ? null
                  : () {
                      cancelarDialog(context, jogosData, c);
                    },
            ),
            FHeaderAction(
              icon: Icon(FIcons.pencil),
              onPress: () {
                editPartida(context, jogosData, c);
              },
            ),
            FHeaderAction(
              icon: Icon(FIcons.share),
              onPress: () {
                Get.to(() => ResumoPartidaUi(
                      jogosData: jogosData,
                    ));
              },
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            spacing: 20,
            children: [
              Responsive(
                children: [
                  Div(
                    divison: Division(
                      colL: 3,
                      colXL: 3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 260,
                        child: FCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(jogosData.tipoJogo ?? "",
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              Text(
                                  c.dateFormatterSimple2.format(DateTime(
                                      jogosData.data!.year,
                                      jogosData.data!.month,
                                      jogosData.data!.day,
                                      jogosData.hora!.hour,
                                      jogosData.hora!.minute)),
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                              Text(jogosData.local ?? "",
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Div(
                    divison: Division(
                      colL: 3,
                      colXL: 3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 260,
                        child: FCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FSelectTileGroup<int>(
                                onChange: (newSelection) async {
                                  jogosData.uniforme = newSelection.first;
                                  await c.changeUniforme(jogosData);
                                  uniforme.value = newSelection.first;
                                },
                                selectController: FMultiValueNotifier.radio(
                                  uniforme.value,
                                ),
                                label: const Text('Uniforme'),
                                description: const Text('Selecione um uniforme para o jogo.'),
                                children: const [
                                  FSelectTile<int>(
                                    value: 1,
                                    title: Text('Casa'),
                                  ),
                                  FSelectTile<int>(
                                    value: 2,
                                    title: Text('Fora'),
                                  ),
                                  FSelectTile<int>(
                                    value: 3,
                                    title: Text('3º'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Div(
                    divison: Division(
                      colL: 6,
                      colXL: 4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 260,
                        child: FCard(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Placar Sport"),
                                SizedBox(
                                  width: 150,
                                  child: FTextField(
                                    controller: placarLocal.value,
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    prefixBuilder: (context, style, states) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FButton.icon(
                                            onPress: () async {
                                              if (jogosData.placarLocal == 0) {
                                                return;
                                              } else {
                                                jogosData.placarLocal = jogosData.placarLocal! - 1;
                                                placarLocal.value.text =
                                                    jogosData.placarLocal.toString();
                                                await c.changePlacar(jogosData);
                                              }
                                            },
                                            child: Icon(Icons.remove_circle_outline_sharp)),
                                      );
                                    },
                                    suffixBuilder: (context, style, states) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FButton.icon(
                                            onPress: () async {
                                              jogosData.placarLocal = jogosData.placarLocal! + 1;
                                              placarLocal.value.text =
                                                  jogosData.placarLocal.toString();
                                              await c.changePlacar(jogosData);
                                            },
                                            child: Icon(Icons.add_circle)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Placar ${jogosData.adversario}",
                                ),
                                SizedBox(
                                  width: 150,
                                  child: FTextField(
                                    controller: placarAdversario.value,
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    prefixBuilder: (context, style, states) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FButton.icon(
                                            onPress: () async {
                                              if (jogosData.placarAdversario == 0) {
                                                return;
                                              } else {
                                                jogosData.placarAdversario =
                                                    jogosData.placarAdversario! - 1;
                                                placarAdversario.value.text =
                                                    jogosData.placarAdversario.toString();
                                                await c.changePlacar(jogosData);
                                              }
                                            },
                                            child: Icon(Icons.remove_circle_outline_sharp)),
                                      );
                                    },
                                    suffixBuilder: (context, style, states) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FButton.icon(
                                            onPress: () async {
                                              jogosData.placarAdversario =
                                                  jogosData.placarAdversario! + 1;
                                              placarAdversario.value.text =
                                                  jogosData.placarAdversario.toString();
                                              await c.changePlacar(jogosData);
                                            },
                                            child: Icon(Icons.add_circle)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Responsive(
                children: [
                  Div(
                    divison: Division(
                      colL: 3,
                      colXL: 3,
                    ),
                    child: FButton(
                        onPress: () {
                          relacionados(context, c, jogosData);
                        },
                        child: Text("Escalar")),
                  ),
                ],
              ),
              Material(child: escalacao442(jogosData, context, c)),
              Div(
                divison: Division(
                  colL: 6,
                  colXL: 4,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Listener(
                    onPointerMove: (details) {
                      if (isDragging) {
                        autoScroll(details.position);
                      }
                    },
                    child: Column(
                      spacing: 10,
                      children: c.jogadores
                          .where((element) => c.relJogo
                              .where((e) => e.idJogador == element.id)
                              .where((e) => e.idJogo == jogosData.id)
                              .isNotEmpty)
                          .map((e) {
                        return Draggable(
                          onDragStarted: () {
                            setState(() {
                              isDragging = true;
                            });
                          },
                          onDragEnd: (_) {
                            setState(() {
                              isDragging = false;
                            });
                          },
                          data: e,
                          feedback: Material(
                              color: Colors.transparent,
                              child: UiJogadorMapa(jogadorData: e, jogosData: jogosData)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: FCard(
                              title: Row(
                                children: [
                                  Text(e.nome ?? ""),
                                  bonecoRelacionados(jogosData, e),
                                  Spacer(),
                                  Wrap(
                                    spacing: 10,
                                    children: [
                                      Row(
                                        children: List.generate(
                                          c.getNumGols(e.id ?? 1, jogosData.id ?? 1).toInt(),
                                          (index) => const HugeIcon(
                                            icon: HugeIcons.strokeRoundedFootball,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          c
                                              .getNumAssistencias(e.id ?? 1, jogosData.id ?? 1)
                                              .toInt(),
                                          (index) => const HugeIcon(
                                            icon: HugeIcons.strokeRoundedHighHeels01,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          c.getNumCV(e.id ?? 1, jogosData.id ?? 1).toInt(),
                                          (index) => const HugeIcon(
                                            icon: HugeIcons.strokeRoundedCards01,
                                            size: 28,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          c.getNumCA(e.id ?? 1, jogosData.id ?? 1).toInt(),
                                          (index) => const HugeIcon(
                                            icon: HugeIcons.strokeRoundedCards01,
                                            size: 28,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Text(e.posicao ?? ""),
                              child: FAccordion(
                                children: [
                                  FAccordionItem(
                                    title: Text("Opções"),
                                    child: Wrap(
                                      runSpacing: 10,
                                      spacing: 10,
                                      children: [
                                        Flex(
                                          spacing: 10,
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: () {
                                                  incrementGol(jogosData, e, placarLocal.value);
                                                },
                                                child: Text("Add. Gol"),
                                              ),
                                            ),
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: c
                                                            .getNumGols(
                                                                e.id ?? 1, jogosData.id ?? 1)
                                                            .toInt() ==
                                                        0
                                                    ? null
                                                    : () {
                                                        decrementGol(
                                                            jogosData, e, placarLocal.value);
                                                      },
                                                child: Text("Del. Gol"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flex(
                                          spacing: 10,
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: () {
                                                  incrementAssist(jogosData, e);
                                                },
                                                child: Text("Add. Assitencia"),
                                              ),
                                            ),
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: c
                                                            .getNumAssistencias(
                                                                e.id ?? 1, jogosData.id ?? 1)
                                                            .toInt() ==
                                                        0
                                                    ? null
                                                    : () {
                                                        deincrementAssist(jogosData, e);
                                                      },
                                                child: Text("Del. Assitencia"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flex(
                                          spacing: 10,
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: c
                                                            .getNumCV(e.id ?? 1, jogosData.id ?? 1)
                                                            .toInt() ==
                                                        1
                                                    ? null
                                                    : () {
                                                        incrementCV(jogosData, e);
                                                      },
                                                child: Text("Add. CV"),
                                              ),
                                            ),
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: c
                                                            .getNumCV(e.id ?? 1, jogosData.id ?? 1)
                                                            .toInt() ==
                                                        0
                                                    ? null
                                                    : () {
                                                        deincrementCV(jogosData, e);
                                                      },
                                                child: Text("Del. CV"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flex(
                                          spacing: 10,
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: c
                                                            .getNumCA(e.id ?? 1, jogosData.id ?? 1)
                                                            .toInt() ==
                                                        2
                                                    ? null
                                                    : () {
                                                        incrementCA(jogosData, e);
                                                      },
                                                child: Text("Add. CA"),
                                              ),
                                            ),
                                            Flexible(
                                              child: FButton(
                                                style: FButtonStyle.outline(),
                                                onPress: c
                                                            .getNumCA(e.id ?? 1, jogosData.id ?? 1)
                                                            .toInt() ==
                                                        0
                                                    ? null
                                                    : () {
                                                        deincrementCA(jogosData, e);
                                                      },
                                                child: Text("Del. CA"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget escalacao442(JogosData jData, context, Controller c) {
  return Stack(
    alignment: Alignment.center,
    children: [
      RotatedBox(
        quarterTurns: 1,
        child: Image.asset(
          "assets/images/campo.png",
          scale: 1.6,
        ),
      ),
      Positioned(
        bottom: 32,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["GOL"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) async {
            JogadorData j = details.data;

            escalacao["GOL"] = j.id ?? 0;
            jData.escalacao = escalacao;
            await c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 150,
        right: 20,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["LD"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["LD"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 150,
        left: 20,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["LE"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["LE"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 90,
        right: 100,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["DEFD"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["DEFD"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 90,
        left: 100,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["DEFE"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["DEFE"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 220,
        right: 110,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["VOLD"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["VOLD"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 220,
        left: 110,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["VOLE"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["VOLE"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 320,
        right: 70,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["MEID"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["MEID"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 320,
        left: 70,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["MEIE"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["MEIE"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 430,
        right: 70,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["ATAD"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["ATAD"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
      Positioned(
        bottom: 430,
        left: 70,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["ATAE"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) {
            JogadorData j = details.data;
            escalacao["ATAE"] = j.id ?? 0;
            jData.escalacao = escalacao;
            c.editEscalacao(jData);
          },
        ),
      ),
    ],
  );
}

class UiJogadorMapa extends StatelessWidget {
  final JogadorData jogadorData;
  final JogosData jogosData;

  const UiJogadorMapa({super.key, required this.jogadorData, required this.jogosData});
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    SubstituicoesData quemSai = c.substituicoes
            .where((element) =>
                element.idJogadorSai?.id == jogadorData.id && element.jogosData == jogosData.id)
            .firstOrNull ??
        SubstituicoesData();

    return Column(
      children: [
        Badge(
          isLabelVisible: quemSai.idJogadorEntra?.nome == null ? false : true,
          backgroundColor: Colors.transparent,
          alignment: Alignment.centerRight,
          label: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 10,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_upward_sharp,
                    color: Colors.green.shade800,
                    size: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2, left: 2),
                    child: Text(
                      quemSai.idJogadorEntra?.nome ?? "",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: Badge(
            largeSize: 10,
            padding: EdgeInsets.all(2),
            isLabelVisible:
                c.getNumGols(jogadorData.id ?? 0, jogosData.id ?? 0) == 0 ? false : true,
            label: Text(
              c.getNumGols(jogadorData.id ?? 0, jogosData.id ?? 0).toString(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            child: InkWell(
              onDoubleTap: c.supabase.auth.currentUser == null
                  ? null
                  : () {
                      substituicoesDialog(context, jogosData, jogadorData);
                    },
              child: Image.asset(
                jogosData.uniforme == 1
                    ? 'assets/images/mini1.png'
                    : jogosData.uniforme == 2
                        ? 'assets/images/mini2.png'
                        : 'assets/images/mini3.png',
                scale: 7,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Row(
              children: [
                quemSai.idJogadorEntra?.nome == null
                    ? Container()
                    : Icon(
                        Icons.arrow_downward_sharp,
                        color: Colors.red.shade800,
                        size: 16,
                      ),
                Text(
                  jogadorData.nome ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
