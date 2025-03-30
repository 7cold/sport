import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/data/relacionadosJogo_data.dart';
import 'package:sport/data/substituicoes_data.dart';

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

substituicoesDialog(
    BuildContext context, JogosData jogosData, Controller c, JogadorData jogadorData) {
  Rxn<JogadorData> sai = Rxn<JogadorData>(jogadorData);
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

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Substituições"),
        content: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropDownSearchField(
                    textFieldConfiguration: TextFieldConfiguration(
                      enabled: false,
                      controller: TextEditingController(text: sai.value!.nome ?? ""),
                      decoration: const InputDecoration(
                          enabled: false,
                          hintText: "Sai",
                          filled: true,
                          prefixIcon: Icon(
                            Icons.arrow_downward_sharp,
                            color: Colors.red,
                          )),
                    ),
                    suggestionsCallback: (pattern) async {
                      return c.jogadores
                          .where((p0) => p0.ativo == true)
                          .where((JogadorData option) {
                        return option.nome.toString().toLowerCase().contains(pattern.toLowerCase());
                      });
                    },
                    itemBuilder: (context, data) {
                      return ListTile(
                        title: Text(data.nome ?? ""),
                        subtitle: Text("${data.posicao} - ${data.numero}"),
                      );
                    },
                    onSuggestionSelected: (data) {
                      sai.value = data;
                    },
                    displayAllSuggestionWhenTap: true,
                    isMultiSelectDropdown: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropDownSearchField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: TextEditingController(text: entra.value?.nome ?? ""),
                      decoration: const InputDecoration(
                          hintText: "Entra",
                          filled: true,
                          prefixIcon: Icon(
                            Icons.arrow_upward_sharp,
                            color: Colors.green,
                          )),
                    ),
                    suggestionsCallback: (pattern) async {
                      return c.jogadores
                          .where((element) => c.relJogo
                              .where((e) => e.idJogador == element.id)
                              .where((e) => e.idJogo == jogosData.id)
                              .isNotEmpty)
                          .where((JogadorData option) {
                        return option.nome.toString().toLowerCase().contains(pattern.toLowerCase());
                      });
                    },
                    itemBuilder: (context, data) {
                      return ListTile(
                        title: Text(data.nome ?? ""),
                        subtitle: Text("${data.posicao} - ${data.numero}"),
                      );
                    },
                    onSuggestionSelected: (data) {
                      entra.value = data;
                    },
                    displayAllSuggestionWhenTap: true,
                    isMultiSelectDropdown: false,
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
          FilledButton.tonal(
            onPressed: () async {
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

class DetalhesJogosUi extends StatefulWidget {
  @override
  State<DetalhesJogosUi> createState() => _DetalhesJogosUiState();
}

class _DetalhesJogosUiState extends State<DetalhesJogosUi> {
  Rx<TextEditingController> placarLocal = TextEditingController().obs;
  Rx<TextEditingController> placarAdversario = TextEditingController().obs;
  RxInt uniforme = (0).obs;

  @override
  void initState() {
    super.initState();
  }

  final ScrollController scrollController = ScrollController();
  bool isDragging = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void autoScroll(Offset position) {
    final screenHeight = MediaQuery.of(context).size.height;
    const scrollThreshold = 100.0; // Margem para ativar o scroll
    const scrollSpeed = 20.0; // Velocidade de scroll (pixels)
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

  editPartida(BuildContext context, JogosData jData, Controller c) {
    TextEditingController adversario = TextEditingController(text: jData.adversario);
    TextEditingController local = TextEditingController(text: jData.local);
    TimeOfDay? time =
        jData.hora != null ? TimeOfDay(hour: jData.hora!.hour, minute: jData.hora!.minute) : null;
    DateTime? date = jData.data;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: context.isPhone ? Get.width : context.width / 3,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: adversario,
                      decoration: const InputDecoration(labelText: "Adversario", filled: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: local,
                      decoration: const InputDecoration(labelText: "Local", filled: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: TextEditingController(
                          text: c.dateFormatterSimple.format(date ?? DateTime.now())),
                      decoration: const InputDecoration(labelText: "Data", filled: true),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: jData.data ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          date = pickedDate;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                      controller: TextEditingController(
                          text: c.dateFormatterHora
                              .format(DateTime(0, 0, 0, time!.hour, time!.minute))),
                      decoration: const InputDecoration(labelText: "Hora", filled: true),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        TimeOfDay? pickedDate = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedDate != null) {
                          time = pickedDate;
                        }
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
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                jData.adversario = adversario.text;
                jData.local = local.text;
                jData.data = date;
                jData.hora = DateTime(0, 0, 0, time!.hour, time!.minute);
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
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancelar Partida?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Sair"),
            ),
            FilledButton.tonal(
              onPressed: () async {
                jData.isCancelado = true;
                await c.cancelarJogo(jData);
                Get.back();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  relacionados(BuildContext context, Controller c, JogosData jogosData) {
    return showGeneralDialog(
      context: context,

      barrierDismissible: true, // Fecha ao tocar fora
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Obx(
          () => Scaffold(
            appBar: AppBar(
              title: Text('Relacionados'),
            ),
            body: SingleChildScrollView(
              child: Wrap(
                children: [
                  Wrap(
                    children: c.jogadores.where((element) => element.ativo == true).map((e) {
                      RxBool select = c.relJogo
                          .where((element) => element.idJogador == e.id)
                          .where((element) => element.idJogo == jogosData.id)
                          .isNotEmpty
                          .obs;

                      return Card(
                        child: ListTile(
                          leading: e.foto == null
                              ? CircleAvatar(
                                  radius: 30,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(e.foto ?? ""),
                                  radius: 30.0,
                                ),
                          title: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.spaceEvenly,
                            children: [
                              Text(e.nome ?? ""),
                              Transform.scale(
                                  scale: 0.70,
                                  child: Switch(
                                      value: select.value,
                                      onChanged: c.loading.value == true
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
                                                        .where(
                                                            (element) => element.idJogador == e.id)
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
                                                await c
                                                    .createRelJogo(RelacionadosjogoData.fromJson({
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
                          subtitle: Wrap(
                            children: [
                              Text("${e.numero} / ${e.posicao}"),
                            ],
                          ),
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

  JogosData jogosData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    placarLocal.value.text = jogosData.placarLocal.toString();
    placarAdversario.value.text = jogosData.placarAdversario.toString();
    uniforme.value = jogosData.uniforme ?? 0;
    escalacao = jogosData.escalacao?.obs ?? <String, int>{}.obs;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalhes do Jogo"),
          actions: c.supabase.auth.currentUser == null
              ? []
              : [
                  Tooltip(
                    message:
                        jogosData.isCancelado == true ? "Jogo esta cancelado" : "Cancelar Jogo",
                    child: IconButton(
                        onPressed: jogosData.isCancelado == true
                            ? null
                            : () {
                                cancelarDialog(context, jogosData, c);
                              },
                        icon: Icon(Icons.cancel_outlined)),
                  ),
                  IconButton(
                      onPressed: () {
                        editPartida(context, jogosData, c);
                      },
                      icon: Icon(Icons.edit_outlined)),
                ],
        ),
        body: Listener(
          onPointerMove: (details) {
            if (isDragging) {
              autoScroll(details.position);
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.theme.primaryColor.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Placar Sport",
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  )),
                            ),
                            c.supabase.auth.currentUser == null
                                ? Expanded(
                                    child: Text(
                                    placarLocal.value.text,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  ))
                                : Expanded(
                                    child: TextFormField(
                                      controller: placarLocal.value,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        filled: true,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Placar ${jogosData.adversario}",
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  )),
                            ),
                            c.supabase.auth.currentUser == null
                                ? Expanded(
                                    child: Text(
                                    placarAdversario.value.text,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  ))
                                : Expanded(
                                    child: TextFormField(
                                      controller: placarAdversario.value,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                            onPressed: () async {
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
                                            icon: Icon(Icons.remove_circle_outline_sharp)),
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              jogosData.placarAdversario =
                                                  jogosData.placarAdversario! + 1;
                                              placarAdversario.value.text =
                                                  jogosData.placarAdversario.toString();
                                              await c.changePlacar(jogosData);
                                            },
                                            icon: Icon(Icons.add_circle)),
                                        filled: true,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(jogosData.tipoJogo ?? "",
                                style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                            Text(
                                c.dateFormatterSimple2.format(DateTime(
                                    jogosData.data!.year,
                                    jogosData.data!.month,
                                    jogosData.data!.day,
                                    jogosData.hora!.hour,
                                    jogosData.hora!.minute)),
                                style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                            Text(jogosData.local ?? "",
                                style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                c.supabase.auth.currentUser == null ? SizedBox(height: 20) : SizedBox(),
                c.supabase.auth.currentUser == null
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                  onPressed: () {
                                    relacionados(context, c, jogosData);
                                  },
                                  child: Text("Relacionados")),
                            )),
                          ],
                        ),
                      ),
                escalacao442(jogosData, context, c),
                c.supabase.auth.currentUser == null
                    ? SizedBox()
                    : Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Get.theme.primaryColor.withOpacity(0.1),
                        ),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Uniforme",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SegmentedButton(
                                multiSelectionEnabled: false,
                                emptySelectionAllowed: false,
                                segments: const <ButtonSegment>[
                                  ButtonSegment(
                                    value: 1,
                                    label: Text('Casa'),
                                    icon: Icon(Icons.home),
                                  ),
                                  ButtonSegment(
                                      value: 2,
                                      label: Text('Fora'),
                                      icon: Icon(Icons.airplanemode_active_rounded)),
                                  ButtonSegment(
                                      value: 3,
                                      label: Text('3º'),
                                      icon: Icon(Icons.label_important_outline_sharp)),
                                ],
                                selected: {uniforme.value},
                                onSelectionChanged: (newSelection) async {
                                  jogosData.uniforme = newSelection.first;
                                  await c.changeUniforme(jogosData);
                                  uniforme.value = newSelection.first;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                c.supabase.auth.currentUser == null ? SizedBox(height: 20) : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Get.theme.primaryColor.withOpacity(0.1),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Relacionados",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                          ),
                          IgnorePointer(
                            ignoring: c.supabase.auth.currentUser == null ? true : false,
                            child: Column(
                              children: c.jogadores
                                  .where((element) => c.relJogo
                                      .where((e) => e.idJogador == element.id)
                                      .where((e) => e.idJogo == jogosData.id)
                                      .isNotEmpty)
                                  .map((e) {
                                return Draggable(
                                  onDragStarted: c.supabase.auth.currentUser == null
                                      ? null
                                      : () {
                                          setState(() {
                                            isDragging = true;
                                          });
                                        },
                                  onDragEnd: c.supabase.auth.currentUser == null
                                      ? null
                                      : (_) {
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
                                    child: Card(
                                        child: InkWell(
                                      borderRadius: BorderRadius.circular(10.0),
                                      onTap: c.supabase.auth.currentUser == null
                                          ? null
                                          : () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return BottomSheet(
                                                      onClosing: () {},
                                                      builder: (BuildContext context) {
                                                        return SizedBox(
                                                          height: 200,
                                                          child: Wrap(
                                                            alignment: WrapAlignment.center,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment.center,
                                                            runAlignment: WrapAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: FilledButton.icon(
                                                                    onPressed: c.getNumGols(
                                                                                e.id ?? 0,
                                                                                jogosData.id ??
                                                                                    0) ==
                                                                            0
                                                                        ? null
                                                                        : () async {
                                                                            jogosData.placarLocal =
                                                                                jogosData
                                                                                        .placarLocal! -
                                                                                    1;
                                                                            placarLocal.value.text =
                                                                                jogosData
                                                                                    .placarLocal
                                                                                    .toString();

                                                                            await c.changePlacar(
                                                                                jogosData);

                                                                            RelacionadosjogoData
                                                                                relacionadosjogoData =
                                                                                c.relJogo
                                                                                    .where((p0) =>
                                                                                        p0.idJogador ==
                                                                                        e.id)
                                                                                    .where((p0) =>
                                                                                        p0.idJogo ==
                                                                                        jogosData
                                                                                            .id)
                                                                                    .first;

                                                                            relacionadosjogoData
                                                                                    .gols =
                                                                                relacionadosjogoData
                                                                                        .gols! -
                                                                                    1;

                                                                            e.gols = e.gols! - 1;

                                                                            c.jogadores.refresh();
                                                                            c.relJogo.refresh();

                                                                            await c.incrementGolsJogador(
                                                                                relacionadosjogoData);

                                                                            Get.back();
                                                                          },
                                                                    label: Text("- 1 Gol"),
                                                                    icon: Icon(Icons
                                                                        .sports_soccer_rounded)),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: FilledButton.icon(
                                                                    onPressed: c.getNumAssistencias(
                                                                                e.id ?? 0,
                                                                                jogosData.id ??
                                                                                    0) ==
                                                                            0
                                                                        ? null
                                                                        : () async {
                                                                            RelacionadosjogoData
                                                                                relacionadosjogoData =
                                                                                c.relJogo
                                                                                    .where((p0) =>
                                                                                        p0.idJogador ==
                                                                                        e.id)
                                                                                    .where((p0) =>
                                                                                        p0.idJogo ==
                                                                                        jogosData
                                                                                            .id)
                                                                                    .first;

                                                                            relacionadosjogoData
                                                                                    .assistencias =
                                                                                relacionadosjogoData
                                                                                        .assistencias! -
                                                                                    1;

                                                                            e.assistencias =
                                                                                e.assistencias! - 1;

                                                                            c.jogadores.refresh();
                                                                            c.relJogo.refresh();

                                                                            await c.incrementAssistJogador(
                                                                                relacionadosjogoData);

                                                                            Get.back();
                                                                          },
                                                                    label: Text("- 1 Assistência"),
                                                                    icon:
                                                                        Icon(Icons.text_decrease)),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                            },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        width: context.width,
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Wrap(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6, left: 10),
                                                  child: Tooltip(
                                                    message: c.substituicoes
                                                                .where((element) =>
                                                                    element.idJogadorEntra?.id ==
                                                                        e.id &&
                                                                    element.jogosData ==
                                                                        jogosData.id)
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
                                                                          element.idJogadorEntra
                                                                                  ?.id ==
                                                                              e.id &&
                                                                          element.jogosData ==
                                                                              jogosData.id)
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
                                                            isLabelVisible: c.getNumGols(e.id ?? 0,
                                                                        jogosData.id ?? 0) ==
                                                                    0
                                                                ? false
                                                                : true,
                                                            label: Text(
                                                              c
                                                                  .getNumGols(
                                                                      e.id ?? 0, jogosData.id ?? 0)
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold),
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
                                                ),
                                                SizedBox(width: 24),
                                                Wrap(
                                                  direction: Axis.vertical,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(e.nome ?? ""),
                                                        for (int i = 0;
                                                            i <
                                                                c.getNumAssistencias(
                                                                    e.id ?? 0, jogosData.id ?? 0);
                                                            i++)
                                                          Padding(
                                                              padding: EdgeInsets.only(left: 5),
                                                              child: Icon(
                                                                  Icons.format_color_text_rounded,
                                                                  size: 15,
                                                                  color: Colors.black54)),
                                                      ],
                                                    ),
                                                    Text(e.posicao ?? ""),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            c.supabase.auth.currentUser == null
                                                ? SizedBox()
                                                : Wrap(
                                                    children: [
                                                      // Tooltip(
                                                      //   message: "Substituição",
                                                      //   child: IconButton(
                                                      //       onPressed: () async {
                                                      //         substituicoesDialog(
                                                      //             context, jogosData, c, e);
                                                      //       },
                                                      //       icon: Icon(
                                                      //           Icons.compare_arrows_outlined)),
                                                      // ),
                                                      Tooltip(
                                                        message: "Gols",
                                                        child: IconButton(
                                                            onPressed: () async {
                                                              jogosData.placarLocal =
                                                                  jogosData.placarLocal! + 1;
                                                              placarLocal.value.text =
                                                                  jogosData.placarLocal.toString();
                                                              await c.changePlacar(jogosData);

                                                              RelacionadosjogoData
                                                                  relacionadosjogoData = c.relJogo
                                                                      .where((p0) =>
                                                                          p0.idJogador == e.id)
                                                                      .where((p0) =>
                                                                          p0.idJogo == jogosData.id)
                                                                      .first;

                                                              relacionadosjogoData.gols =
                                                                  relacionadosjogoData.gols! + 1;

                                                              e.gols = e.gols! + 1;
                                                              c.relJogo.refresh();
                                                              c.jogadores.refresh();

                                                              await c.incrementGolsJogador(
                                                                  relacionadosjogoData);
                                                            },
                                                            icon:
                                                                Icon(Icons.sports_soccer_rounded)),
                                                      ),
                                                      Tooltip(
                                                        message: "Assistencias",
                                                        child: IconButton(
                                                            onPressed: () async {
                                                              RelacionadosjogoData
                                                                  relacionadosjogoData = c.relJogo
                                                                      .where((p0) =>
                                                                          p0.idJogador == e.id)
                                                                      .where((p0) =>
                                                                          p0.idJogo == jogosData.id)
                                                                      .first;

                                                              relacionadosjogoData.assistencias =
                                                                  relacionadosjogoData
                                                                          .assistencias! +
                                                                      1;

                                                              e.assistencias = e.assistencias! + 1;
                                                              c.relJogo.refresh();
                                                              c.jogadores.refresh();

                                                              await c.incrementAssistJogador(
                                                                  relacionadosjogoData);
                                                            },
                                                            icon: Icon(
                                                                Icons.format_color_text_rounded)),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    )),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
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
        bottom: 42,
        child: DragTarget(
          builder: (context, accepted, rejected) {
            return UiJogadorMapa(
              jogadorData: c.searchJogador(escalacao["GOL"] ?? 0),
              jogosData: jData,
            );
          },
          onAcceptWithDetails: (DragTargetDetails details) async {
            JogadorData j = details.data;

            if (c.searchJogadorInEscalacao(j.id ?? 0, escalacao) == true) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Jogador já escalado")));
            } else {
              escalacao["GOL"] = j.id ?? 0;
              jData.escalacao = escalacao;
              await c.editEscalacao(jData);
            }
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
        bottom: 100,
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
        bottom: 100,
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
        right: 90,
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
        left: 90,
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
        Tooltip(
          message:
              quemSai.idJogadorEntra?.nome == null ? "" : "Entra: ${quemSai.idJogadorEntra?.nome}",
          child: Badge(
            isLabelVisible: quemSai.idJogadorEntra?.nome == null ? false : true,
            backgroundColor: Colors.transparent,
            alignment: Alignment.centerRight,
            label: Icon(
              Icons.arrow_downward_sharp,
              color: Colors.red.shade800,
              size: 16,
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
                        substituicoesDialog(context, jogosData, c, jogadorData);
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
        ),
        Row(
          children: [
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
    );
  }
}
