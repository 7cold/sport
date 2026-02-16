import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/calendarioJogos/core.dart';
import 'package:sport/data/jogos_data.dart';
import '../controller/controller.dart';
import '../detalheJogos/detalhesJogosUi.dart';

final Controller c = Get.put(Controller());

class Calendariojogosui extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FScaffold(
        header: FHeader(
          title: Text('Jogos'),
          suffixes: [
            FHeaderAction(
                icon: Icon(FIcons.plus),
                onPress: () {
                  cadastroJogos(context);
                })
          ],
        ),
        child: c.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: c.jogos.map((e) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Responsive(
                      children: [
                        Div(divison: Division(colL: 6, colXL: 4), child: CardJogos(e: e)),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

class CardJogos extends StatelessWidget {
  final JogosData e;

  const CardJogos({required this.e});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: FTappable(
        onPress: () {
          Get.to(
            () => DetalhesJogosUi(),
            arguments: e,
          );
        },
        child: FCard(
          title: Text(e.tipoJogo ?? ""),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 20, left: 5, top: 10),
                  child: Text(
                      "${c.dateFormatterSimple.format(e.data ?? DateTime.now())} às ${c.dateFormatterHora.format(e.hora ?? DateTime.now())}"),
                ),
              ),
              e.emCasa == true
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
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      DateTime.now().isBefore(e.data ?? DateTime.now()) ||
                                              e.isCancelado == true
                                          ? "-"
                                          : e.placarLocal.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                                    e.adversario ?? "",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      DateTime.now().isBefore(e.data ?? DateTime.now()) ||
                                              e.isCancelado == true
                                          ? "-"
                                          : e.placarAdversario.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                                    e.adversario ?? "",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      DateTime.now().isBefore(e.data ?? DateTime.now()) ||
                                              e.isCancelado == true
                                          ? "-"
                                          : e.placarAdversario.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      DateTime.now().isBefore(e.data ?? DateTime.now()) ||
                                              e.isCancelado == true
                                          ? "-"
                                          : e.placarLocal.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: e.isCancelado == true
                    ? Text(
                        "Jogo Cancelado",
                        style: TextStyle(
                            color: Colors.red, fontSize: 13.5, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        e.local ?? "",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Material(
//           child: InkWell(
//             onTap: e.isCancelado == true && c.supabase.auth.currentUser == null
//                 ? null
//                 : () {
//                     Get.to(() => DetalhesJogosUi(), arguments: e);
//                   },
//             onLongPress: c.supabase.auth.currentUser == null
//                 ? null
//                 : () {
//                     showModalBottomSheet(
//                         context: context,
//                         builder: (context) {
//                           return BottomSheet(
//                             onClosing: () {},
//                             builder: (BuildContext context) {
//                               return SizedBox(
//                                 height: 200,
//                                 child: Wrap(
//                                   alignment: WrapAlignment.center,
//                                   crossAxisAlignment: WrapCrossAlignment.center,
//                                   runAlignment: WrapAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: FilledButton.icon(
//                                           onPressed: () async {
//                                             c.deleteJogo(e);
//                                             Get.back();
//                                           },
//                                           label: Text("Deletar"),
//                                           icon: Icon(Icons.delete_forever_outlined)),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         });
//                   },
//           ),
//         ),
