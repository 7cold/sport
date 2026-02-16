import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:sport/HomeVisitante.dart';
import 'package:sport/agendaUi.dart';
import 'package:sport/calendarioJogos/calendarioJogosUi.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/detalheJogos/detalhesJogosUi.dart';
import 'package:sport/div.dart';
import 'package:sport/plantel/plantel.dart';
import 'package:sport/rankingArtilhariaGeralUi.dart';

final c = Get.put(Controller());

// class HomeUi extends StatefulWidget {
//   const HomeUi({super.key});

//   @override
//   State<HomeUi> createState() => _HomeUiState();
// }

// class _HomeUiState extends State<HomeUi> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Get.theme.colorScheme.primaryContainer,
//         title: Text("Sport"),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Get.theme.colorScheme.primaryContainer,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             ListTile(
//               title: const Text('Tabela de Jogos'),
//               onTap: () {
//                 Get.to(() => Calendariojogosui());
//               },
//             ),
//             ListTile(
//               title: const Text('Calendário de Jogos'),
//               onTap: () {
//                 Get.to(() => AgendaUi());
//               },
//             ),
//             ListTile(
//               title: const Text('Plantel'),
//               onTap: () {
//                 Get.to(() => PlantelUi());
//               },
//             ),
//             ListTile(
//               title: const Text('Configurações'),
//               onTap: () {},
//             ),
//             ListTile(
//               title: const Text('Ir para Site'),
//               onTap: () {
//                 Get.to(() => HomeVisitante());
//               },
//             ),
//             ListTile(
//               title: const Text('Sair'),
//               onTap: () {
//                 c.logout();
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         return c.loading.value == true
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : ExtraDiv(
//                 widget: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Wrap(
//                     children: [
//                       Card(
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(10),
//                           onTap: c.proximoJogo().data == null
//                               ? null
//                               : () {
//                                   Get.to(() => DetalhesJogosUi(), arguments: c.proximoJogo());
//                                 },
//                           child: Container(
//                             width: double.infinity,
//                             margin: EdgeInsets.all(10),
//                             padding: EdgeInsets.all(10),
//                             child: Wrap(
//                               children: [
//                                 Text(
//                                   "Próximo Jogo",
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                                 c.proximoJogo().data == null
//                                     ? SizedBox()
//                                     : InkWell(
//                                         borderRadius: BorderRadius.circular(10.0),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Wrap(
//                                               runAlignment: WrapAlignment.spaceBetween,
//                                               alignment: WrapAlignment.spaceBetween,
//                                               children: [
//                                                 Flex(
//                                                   direction: Axis.horizontal,
//                                                   children: [
//                                                     Expanded(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.all(8.0),
//                                                         child: Card(
//                                                             color: Get.theme.colorScheme.primary,
//                                                             child: Center(
//                                                                 child: Padding(
//                                                               padding: const EdgeInsets.all(2.0),
//                                                               child: Text(
//                                                                 c.proximoJogo().tipoJogo ?? "",
//                                                                 style:
//                                                                     TextStyle(color: Colors.white),
//                                                               ),
//                                                             ))),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Center(
//                                                         child: Text(
//                                                             "${c.dateFormatterSimple.format(c.proximoJogo().data ?? DateTime.now())} às ${c.dateFormatterHora.format(c.proximoJogo().hora ?? DateTime.now())}"),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                             c.proximoJogo().emCasa == true
//                                                 ? Wrap(
//                                                     children: [
//                                                       Wrap(
//                                                         children: [
//                                                           Flex(
//                                                             direction: Axis.horizontal,
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Container(
//                                                                   width: 45.0,
//                                                                   height: 45.0,
//                                                                   decoration: BoxDecoration(
//                                                                     shape: BoxShape.circle,
//                                                                     image: DecorationImage(
//                                                                         image: AssetImage(
//                                                                       "assets/images/sport.png",
//                                                                     )),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 flex: 2,
//                                                                 child: Text(
//                                                                   "Sport",
//                                                                   style: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: 18.0),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     DateTime.now().isBefore(
//                                                                             c.proximoJogo().data ??
//                                                                                 DateTime.now())
//                                                                         ? "-"
//                                                                         : c
//                                                                             .proximoJogo()
//                                                                             .placarLocal
//                                                                             .toString(),
//                                                                     style: TextStyle(
//                                                                         fontWeight: FontWeight.bold,
//                                                                         fontSize: 18.0),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Wrap(
//                                                         children: [
//                                                           Flex(
//                                                             direction: Axis.horizontal,
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Container(
//                                                                   width: 55.0,
//                                                                   height: 55.0,
//                                                                   decoration: BoxDecoration(
//                                                                     shape: BoxShape.circle,
//                                                                     image: DecorationImage(
//                                                                       image: AssetImage(
//                                                                         "assets/images/generico.png",
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 flex: 2,
//                                                                 child: Text(
//                                                                   c.proximoJogo().adversario ?? "",
//                                                                   style: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: 18.0),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     DateTime.now().isBefore(
//                                                                             c.proximoJogo().data ??
//                                                                                 DateTime.now())
//                                                                         ? "-"
//                                                                         : c
//                                                                             .proximoJogo()
//                                                                             .placarAdversario
//                                                                             .toString(),
//                                                                     style: TextStyle(
//                                                                         fontWeight: FontWeight.bold,
//                                                                         fontSize: 18.0),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   )
//                                                 : Wrap(
//                                                     children: [
//                                                       Wrap(
//                                                         children: [
//                                                           Flex(
//                                                             direction: Axis.horizontal,
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Container(
//                                                                   width: 55.0,
//                                                                   height: 55.0,
//                                                                   decoration: BoxDecoration(
//                                                                     shape: BoxShape.circle,
//                                                                     image: DecorationImage(
//                                                                       image: AssetImage(
//                                                                         "assets/images/generico.png",
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 flex: 2,
//                                                                 child: Text(
//                                                                   c.proximoJogo().adversario ?? "",
//                                                                   style: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: 18.0),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     c
//                                                                         .proximoJogo()
//                                                                         .placarAdversario
//                                                                         .toString(),
//                                                                     style: TextStyle(
//                                                                         fontWeight: FontWeight.bold,
//                                                                         fontSize: 18.0),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Wrap(
//                                                         children: [
//                                                           Flex(
//                                                             direction: Axis.horizontal,
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Container(
//                                                                   width: 45.0,
//                                                                   height: 45.0,
//                                                                   decoration: BoxDecoration(
//                                                                     shape: BoxShape.circle,
//                                                                     image: DecorationImage(
//                                                                         image: AssetImage(
//                                                                       "assets/images/sport.png",
//                                                                     )),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 flex: 2,
//                                                                 child: Text(
//                                                                   "Sport",
//                                                                   style: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: 18.0),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     c
//                                                                         .proximoJogo()
//                                                                         .placarLocal
//                                                                         .toString(),
//                                                                     style: TextStyle(
//                                                                         fontWeight: FontWeight.bold,
//                                                                         fontSize: 18.0),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                             Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: c.proximoJogo().isCancelado == true
//                                                   ? Text(
//                                                       "Jogo Cancelado",
//                                                       style: TextStyle(color: Colors.red),
//                                                     )
//                                                   : Text(
//                                                       c.proximoJogo().local ?? "",
//                                                     ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Card(
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(10),
//                           onTap: () {
//                             Get.to(() => DetalhesJogosUi(), arguments: c.ultimoJogo());
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             margin: EdgeInsets.all(10),
//                             padding: EdgeInsets.all(10),
//                             child: Wrap(
//                               children: [
//                                 Text(
//                                   "Último Jogo",
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                                 InkWell(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Wrap(
//                                         runAlignment: WrapAlignment.spaceBetween,
//                                         alignment: WrapAlignment.spaceBetween,
//                                         children: [
//                                           Flex(
//                                             direction: Axis.horizontal,
//                                             children: [
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Card(
//                                                       color: Get.theme.colorScheme.primary,
//                                                       child: Center(
//                                                           child: Padding(
//                                                         padding: const EdgeInsets.all(2.0),
//                                                         child: Text(
//                                                           c.ultimoJogo().tipoJogo ?? "",
//                                                           style: TextStyle(color: Colors.white),
//                                                         ),
//                                                       ))),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Center(
//                                                   child: Text(
//                                                       "${c.dateFormatterSimple.format(c.ultimoJogo().data ?? DateTime.now())} às ${c.dateFormatterHora.format(c.ultimoJogo().hora ?? DateTime.now())}"),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       c.ultimoJogo().emCasa == true
//                                           ? Wrap(
//                                               children: [
//                                                 Wrap(
//                                                   children: [
//                                                     Flex(
//                                                       direction: Axis.horizontal,
//                                                       children: [
//                                                         Expanded(
//                                                           child: Container(
//                                                             width: 45.0,
//                                                             height: 45.0,
//                                                             decoration: BoxDecoration(
//                                                               shape: BoxShape.circle,
//                                                               image: DecorationImage(
//                                                                   image: AssetImage(
//                                                                 "assets/images/sport.png",
//                                                               )),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           flex: 2,
//                                                           child: Text(
//                                                             "Sport",
//                                                             style: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 18.0),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               DateTime.now().isBefore(
//                                                                       c.ultimoJogo().data ??
//                                                                           DateTime.now())
//                                                                   ? "-"
//                                                                   : c
//                                                                       .ultimoJogo()
//                                                                       .placarLocal
//                                                                       .toString(),
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   fontSize: 18.0),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Wrap(
//                                                   children: [
//                                                     Flex(
//                                                       direction: Axis.horizontal,
//                                                       children: [
//                                                         Expanded(
//                                                           child: Container(
//                                                             width: 55.0,
//                                                             height: 55.0,
//                                                             decoration: BoxDecoration(
//                                                               shape: BoxShape.circle,
//                                                               image: DecorationImage(
//                                                                 image: AssetImage(
//                                                                   "assets/images/generico.png",
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           flex: 2,
//                                                           child: Text(
//                                                             c.ultimoJogo().adversario ?? "",
//                                                             style: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 18.0),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               DateTime.now().isBefore(
//                                                                       c.ultimoJogo().data ??
//                                                                           DateTime.now())
//                                                                   ? "-"
//                                                                   : c
//                                                                       .ultimoJogo()
//                                                                       .placarAdversario
//                                                                       .toString(),
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   fontSize: 18.0),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )
//                                           : Wrap(
//                                               children: [
//                                                 Wrap(
//                                                   children: [
//                                                     Flex(
//                                                       direction: Axis.horizontal,
//                                                       children: [
//                                                         Expanded(
//                                                           child: Container(
//                                                             width: 55.0,
//                                                             height: 55.0,
//                                                             decoration: BoxDecoration(
//                                                               shape: BoxShape.circle,
//                                                               image: DecorationImage(
//                                                                 image: AssetImage(
//                                                                   "assets/images/generico.png",
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           flex: 2,
//                                                           child: Text(
//                                                             c.ultimoJogo().adversario ?? "",
//                                                             style: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 18.0),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               c
//                                                                   .ultimoJogo()
//                                                                   .placarAdversario
//                                                                   .toString(),
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   fontSize: 18.0),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Wrap(
//                                                   children: [
//                                                     Flex(
//                                                       direction: Axis.horizontal,
//                                                       children: [
//                                                         Expanded(
//                                                           child: Container(
//                                                             width: 45.0,
//                                                             height: 45.0,
//                                                             decoration: BoxDecoration(
//                                                               shape: BoxShape.circle,
//                                                               image: DecorationImage(
//                                                                   image: AssetImage(
//                                                                 "assets/images/sport.png",
//                                                               )),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           flex: 2,
//                                                           child: Text(
//                                                             "Sport",
//                                                             style: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 18.0),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               c.ultimoJogo().placarLocal.toString(),
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight.bold,
//                                                                   fontSize: 18.0),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: c.ultimoJogo().isCancelado == true
//                                             ? Text(
//                                                 "Jogo Cancelado",
//                                                 style: TextStyle(
//                                                   color: Colors.red,
//                                                 ),
//                                               )
//                                             : Text(
//                                                 c.ultimoJogo().local ?? "",
//                                               ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Card(
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(10),
//                           onTap: () => Get.to(() => RankingArtilharia()),
//                           child: Container(
//                             margin: EdgeInsets.all(10),
//                             padding: EdgeInsets.all(10),
//                             width: double.infinity,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Ranking Artilharia",
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                                 Column(
//                                   children: c.artilheiros
//                                       .map(
//                                         (artilheiro) => Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   CircleAvatar(
//                                                     radius: 22.0,
//                                                     backgroundImage:
//                                                         NetworkImage(artilheiro.foto ?? ""),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 6,
//                                                   ),
//                                                   Text(
//                                                     artilheiro.nome ?? "",
//                                                     style: TextStyle(fontSize: 16),
//                                                   ),
//                                                 ],
//                                               ),
//                                               CircleAvatar(
//                                                 child: Text(
//                                                   (artilheiro.gols ?? 0).toString(),
//                                                   style: TextStyle(
//                                                       fontSize: 22, fontWeight: FontWeight.bold),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                       .take(1)
//                                       .toList(),
//                                 ),
//                                 Column(
//                                   children: c.artilheiros
//                                       .map(
//                                         (artilheiro) => Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 25, right: 25, bottom: 8),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   CircleAvatar(
//                                                     radius: 16.0,
//                                                     backgroundImage:
//                                                         NetworkImage(artilheiro.foto ?? ""),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 6,
//                                                   ),
//                                                   Text(
//                                                     artilheiro.nome ?? "",
//                                                     style: TextStyle(fontSize: 14),
//                                                   ),
//                                                 ],
//                                               ),
//                                               CircleAvatar(
//                                                 radius: 16,
//                                                 child: Text(
//                                                   (artilheiro.gols ?? 0).toString(),
//                                                   style: TextStyle(
//                                                       fontSize: 14, fontWeight: FontWeight.bold),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                       .skip(1)
//                                       .take(2)
//                                       .toList(),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//       }),
//     );
//   }
// }

class HomeUi extends StatelessWidget {
  Rx<Widget> currentWidget = Rx<Widget>(Center(child: Text("Home Screen")));

  @override
  Widget build(BuildContext context) {
    currentWidget.value = Calendariojogosui();
    return FScaffold(
        sidebar: FSidebar(children: [
          FSidebarGroup(
            label: const Text('Overview'),
            children: [
              FSidebarItem(
                icon: const Icon(FIcons.house),
                label: const Text('Home'),
                initiallyExpanded: true,
                onPress: () {},
                children: [
                  FSidebarItem(
                      label: const Text('Plantel'),
                      selected: true,
                      onPress: () {
                        currentWidget.value = PlantelUi();
                      }),
                  FSidebarItem(
                      label: const Text('Jogos'),
                      onPress: () {
                        currentWidget.value = Calendariojogosui();
                      }),
                ],
              ),
              FSidebarItem(
                  icon: const Icon(FIcons.bookDashed),
                  label: const Text('Estatísticas'),
                  onPress: () {}),
              FSidebarItem(
                  icon: const Icon(FIcons.settings),
                  label: const Text('Configurações'),
                  onPress: () {}),
            ],
          ),
        ]),
        footer: FBottomNavigationBar(children: const []),
        childPad: true,
        resizeToAvoidBottomInset: true,
        child: Obx(() => currentWidget.value));
  }
}
