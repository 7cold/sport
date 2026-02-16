import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sport/HomeVisitante.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/data/substituicoes_data.dart';
import 'package:sport/detalheJogos/detalhesJogosUi.dart';
import 'package:sport/rankingArtilhariaGeralUi.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'controller/controller.dart';

class ResumoPartidaUi extends StatefulWidget {
  final JogosData jogosData;

  const ResumoPartidaUi({required this.jogosData});

  @override
  State<ResumoPartidaUi> createState() => _ResumoPartidaUiState();
}

class _ResumoPartidaUiState extends State<ResumoPartidaUi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Controller());
    ScreenshotController screenshotController = ScreenshotController();
    Uint8List? _imageFile;

    var myLongWidget = Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Resumo da Partida",
                    style: Get.theme.textTheme.headlineSmall,
                  ),
                ),
                Card(
                  child: Column(children: [
                    Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    color: Get.theme.primaryColor,
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        widget.jogosData.tipoJogo ?? "",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ))),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                    "${c.dateFormatterSimple.format(widget.jogosData.data ?? DateTime.now())} às ${c.dateFormatterHora.format(widget.jogosData.hora ?? DateTime.now())}"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    widget.jogosData.emCasa == true
                        ? Wrap(
                            children: [
                              Wrap(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 45.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                              "assets/images/sport.png",
                                            )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Sport",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            DateTime.now().isBefore(
                                                    widget.jogosData.data ?? DateTime.now())
                                                ? "-"
                                                : widget.jogosData.placarLocal.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 55.0,
                                          height: 55.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/generico.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.jogosData.adversario ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            DateTime.now().isBefore(
                                                    widget.jogosData.data ?? DateTime.now())
                                                ? "-"
                                                : widget.jogosData.placarAdversario.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Wrap(
                            children: [
                              Wrap(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 55.0,
                                          height: 55.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/generico.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.jogosData.adversario ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            widget.jogosData.placarAdversario.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 45.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                              "assets/images/sport.png",
                                            )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Sport",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            widget.jogosData.placarLocal.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.jogosData.isCancelado == true
                            ? Text(
                                "Jogo Cancelado",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : Text(
                                widget.jogosData.local ?? "",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(child: escalacao442(widget.jogosData, context, c)),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gols",
                        style: Get.theme.textTheme.headlineSmall,
                      ),
                    ),
                    c.getJogadoresMarcaram(widget.jogosData).isEmpty
                        ? SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Card(child: Center(child: Text("Sem Gols"))),
                          )
                        : Column(
                            children: c.getJogadoresMarcaram(widget.jogosData).map((element) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              element.foto == null
                                                  ? CircleAvatar(
                                                      radius: 20,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(element.foto ?? ""),
                                                      radius: 20),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(element.nome ?? ""),
                                            ],
                                          ),
                                          CircleAvatar(
                                            child: Text(c
                                                .getNumGols(
                                                    element.id ?? 0, widget.jogosData.id ?? 0)
                                                .toString()),
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Substituições",
                        style: Get.theme.textTheme.headlineSmall,
                      ),
                    ),
                    c.getSubstituicoes(widget.jogosData).isEmpty
                        ? Card(
                            child: ListTile(
                              title: Text("Sem Substituições"),
                            ),
                          )
                        : Column(
                            children: c.getSubstituicoes(widget.jogosData).map((element) {
                              SubstituicoesData subs = element;

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              subs.idJogadorEntra?.foto == null
                                                  ? CircleAvatar(
                                                      radius: 16,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          subs.idJogadorEntra?.foto ?? ""),
                                                      radius: 16.0,
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(subs.idJogadorEntra?.nome ?? ""),
                                            ],
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: Icon(
                                              Icons.arrow_upward_outlined,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              subs.idJogadorSai?.foto == null
                                                  ? CircleAvatar(
                                                      radius: 16,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          subs.idJogadorSai?.foto ?? ""),
                                                      radius: 16.0,
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(subs.idJogadorSai?.nome ?? ""),
                                            ],
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: Icon(
                                              Icons.arrow_downward_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RankingArtilhariaVisit2(),
                SizedBox(
                  height: 20,
                ),
                UltimosJogos2(),
              ],
            ),
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Resumo Partida"),
      ),
      body: Badge(
          isLabelVisible: true,
          alignment: Alignment.topLeft,
          backgroundColor: Colors.transparent,
          label: IconButton.filled(
              onPressed: () async {
                screenshotController
                    .captureFromLongWidget(
                  pixelRatio: 1.5,
                  InheritedTheme.captureAll(
                    context,
                    Material(child: myLongWidget),
                  ),
                  delay: Duration(milliseconds: 100),
                  context: context,
                )
                    .then((image) async {
                  if (kIsWeb) {
                    await downloadImageWeb(image);
                  } else {
                    await saveImageToFile(image);
                  }
                  // Handle captured image
                });
              },
              icon: Icon(Icons.camera_alt_outlined)),
          child: myLongWidget),
    );
  }
}

class RankingArtilhariaVisit2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<JogadorData> list = c.jogadores.where((jogador) => jogador.ativo == true).toList();
    list.sort((a, b) => b.gols!.compareTo(a.gols!));

    // WidgetsToImageController to access widget
    WidgetsToImageController controller = WidgetsToImageController();
    Uint8List? bytes;

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: c.ultimoJogo().adversario == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ranking Artilharia",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: list
                        .toList()
                        .map(
                          (artilheiro) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage: NetworkImage(artilheiro.foto ?? ""),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      artilheiro.nome ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  child: Text(
                                    (artilheiro.gols ?? 0).toString(),
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .take(1)
                        .toList(),
                  ),
                  Column(
                    children: list
                        .map(
                          (artilheiro) => Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16.0,
                                      backgroundImage: NetworkImage(artilheiro.foto ?? ""),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      artilheiro.nome ?? "",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 16,
                                  child: Text(
                                    (artilheiro.gols ?? 0).toString(),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .skip(1)
                        .take(2)
                        .toList(),
                  )
                ],
              ),
      ),
    );
  }
}

class UltimosJogos2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Histórico de Jogos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/sport.png",
                      width: 45,
                    ),
                    Row(
                        children: c.jogos
                            .where((e) => (e.data ?? DateTime.now()).isBefore(DateTime.now()))
                            .where((e) => e.isCancelado != true)
                            .map((e) {
                              if ((e.placarLocal ?? 0) > (e.placarAdversario ?? 0)) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 5,
                                  ),
                                );
                              } else if ((e.placarLocal ?? 0) < (e.placarAdversario ?? 0)) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 5,
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[400],
                                    radius: 5,
                                  ),
                                );
                              }
                            })
                            .toList()
                            .take(5)
                            .toList())
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
