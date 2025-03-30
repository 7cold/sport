import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/calendarioJogosUi.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/detalhesJogosUi.dart';
import 'package:sport/homeUi.dart';
import 'package:sport/image_converter.dart';
import 'package:sport/login.dart';
import 'package:sport/plantel.dart';
import 'package:sport/rankingArtilhariaGeralUi.dart';
import 'package:widgets_to_png/widgets_to_png.dart';

final Controller c = Get.put(Controller());

class HomeVisitante extends StatelessWidget {
  const HomeVisitante({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        c.jogadores.length;

        return c.ultimoJogo().adversario == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Responsive(
                  children: [
                    Responsive(
                      children: [
                        Header(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          child: Center(
                            child: Text("Bem vindo ao Sport Club Crisólia",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Center(
                          child: Div(
                            divison: Division(colL: 6, colXL: 6),
                            child: Responsive(
                              children: [
                                Div(divison: Division(colL: 12, colXL: 6), child: ProximoJogo()),
                                Div(divison: Division(colL: 12, colXL: 6), child: UltimoJogo()),
                                Div(
                                    divison: Division(colL: 12, colXL: 6),
                                    child: RankingArtilhariaVisit()),
                                Div(divison: Division(colL: 12, colXL: 6), child: UltimosJogos()),
                              ],
                            ),
                          ),
                        ),
                        Div(divison: Division(colL: 12, colXL: 12), child: CTASection()),
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40, right: 20, left: 20, top: 10),
                child: Responsive(
                  children: [
                    Div(
                      divison: Division(colL: 6, colXL: 8),
                      child: UltimosJogos(),
                    ),
                  ],
                ),
              ),
              CTASection(),
            ],
          ),
        ),
      );
    });
  }
}

// Header
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/sport.png",
                height: 65,
              ),
              // Text("Sport C. C.", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Get.to(() => Calendariojogosui());
                  },
                  child: Text("Partidas")),
              TextButton(
                  onPressed: () {
                    Get.to(() => PlantelUi());
                  },
                  child: Text("Plantel")),
              TextButton(
                  onPressed: () {
                    c.supabase.auth.currentUser == null
                        ? Get.to(() => Login())
                        : Get.to(() => HomeUi());
                  },
                  child: Text(c.supabase.auth.currentUser == null ? "Login" : "Admin")),
            ],
          )
        ],
      ),
    );
  }
}

class RankingArtilhariaVisit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<JogadorData> list = c.jogadores.where((jogador) => jogador.ativo == true).toList();
    list.sort((a, b) => b.gols!.compareTo(a.gols!));

    final GlobalKey _globalKey = GlobalKey();

    return WidgetToPng(
      keyToCapture: _globalKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Badge(
          alignment: Alignment.topLeft,
          backgroundColor: Colors.transparent,
          label: IconButton.filled(
              onPressed: () async {
                await ImageConverter.saveWidgetToGallery(
                  key: _globalKey,
                  fileName: 'captured_widget.png',
                );
              },
              icon: Icon(Icons.camera_alt_outlined)),
          child: Card(
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Get.to(() => RankingArtilharia()),
              child: Container(
                margin: EdgeInsets.all(10),
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
                                            style: TextStyle(
                                                fontSize: 22, fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.bold),
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
            ),
          ),
        ),
      ),
    );
  }
}

class UltimosJogos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        height: 210,
        child: Card(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Get.to(() => Calendariojogosui());
            },
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
        ),
      ),
    );
  }
}

class ProximoJogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        height: 268,
        child: Card(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: c.proximoJogo().data == null
                ? null
                : () {
                    Get.to(() => DetalhesJogosUi(), arguments: c.proximoJogo());
                  },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedFootballPitch,
                    color: Get.theme.primaryColor,
                    size: 30,
                  ),
                  Text("Próximo Jogo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        c.proximoJogo().data == null
                            ? SizedBox(
                                child: Center(child: Text("Sem jogos agendados")),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    runAlignment: WrapAlignment.spaceBetween,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Text(c.dateFormatterSimple
                                                  .format(c.proximoJogo().data ?? DateTime.now())),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                    "${c.dateFormatterHora.format(c.proximoJogo().hora ?? DateTime.now())} hrs"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  c.proximoJogo().emCasa == true
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
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
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
                                                        c.proximoJogo().adversario ?? "",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
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
                                                        c.proximoJogo().adversario ?? "",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
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
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      c.proximoJogo().local ?? "",
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
        ),
      ),
    );
  }
}

class UltimoJogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        height: 268,
        child: Card(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Get.to(() => DetalhesJogosUi(), arguments: c.ultimoJogo());
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedFootballPitch,
                    color: Get.theme.primaryColor,
                    size: 30,
                  ),
                  Text("Último Jogo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              runAlignment: WrapAlignment.spaceBetween,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Text(c.dateFormatterSimple
                                            .format(c.ultimoJogo().data ?? DateTime.now())),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              "${c.dateFormatterHora.format(c.ultimoJogo().hora ?? DateTime.now())} hrs"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            c.ultimoJogo().emCasa == true
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
                                                    c.ultimoJogo().placarLocal.toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0),
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
                                                  c.ultimoJogo().adversario ?? "",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 18.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    c.ultimoJogo().placarAdversario.toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0),
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
                                                  c.ultimoJogo().adversario ?? "",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 18.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    c.ultimoJogo().placarAdversario.toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0),
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
                                                    c.ultimoJogo().placarLocal.toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: c.ultimoJogo().isCancelado == true
                                  ? Text(
                                      "Jogo Cancelado",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Text(
                                      c.ultimoJogo().local ?? "",
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
        ),
      ),
    );
  }
}

class CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
      margin: EdgeInsets.only(top: 50),
      color: const Color.fromARGB(255, 11, 55, 131),
      width: double.infinity,
      child: Column(
        children: [
          Text("Em breve mais novidades!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
