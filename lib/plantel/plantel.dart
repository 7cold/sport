import 'dart:math';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/plantel/core.dart';
import 'package:sport/upperCase.dart';

import '../controller/controller.dart';

final Controller c = Get.put(Controller());
RxBool ativos = true.obs;

class PlantelUi extends StatefulWidget {
  @override
  State<PlantelUi> createState() => _PlantelUiState();
}

class _PlantelUiState extends State<PlantelUi> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text('Plantel'),
        suffixes: [
          Obx(
            () => Transform.scale(
              scale: 0.8,
              child: FSwitch(
                value: ativos.value,
                onChange: (value) async {
                  ativos.value = value;
                },
              ),
            ),
          ),
          FHeaderAction(
              icon: Icon(FIcons.plus),
              onPress: () {
                cadastroJogador(context);
              })
        ],
      ),
      child: Obx(() {
        if (c.loading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: c.jogadores.where((element) => element.ativo == ativos.value).length,
            itemBuilder: (context, index) {
              JogadorData jogador =
                  c.jogadores.where((element) => element.ativo == ativos.value).toList()[index];

              return Align(
                alignment: Alignment.topCenter,
                child: Responsive(
                  children: [
                    Div(
                        divison: Division(
                          colL: 6,
                          colXL: 4,
                        ),
                        child: CardJogador(jogador: jogador))
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}

class CardJogador extends StatelessWidget {
  final JogadorData jogador;

  const CardJogador({required this.jogador});
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FCard(
        image: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FAvatar(
              image: NetworkImage(jogador.foto ?? ""),
            ),
            Row(
              children: [
                FButton.icon(
                    onPress: () {
                      editJogador(context, jogador);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(FIcons.pencil),
                    )),
                Transform.scale(
                  scale: 0.8,
                  child: FSwitch(
                    value: jogador.ativo ?? false,
                    onChange: (value) async {
                      jogador.ativo = value;
                      await c.inativarJogador(jogador);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        title: Text(jogador.nome ?? ""),
        subtitle: Text(jogador.posicao ?? ""),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jogos: ${jogador.jogos.toString()}",
              style: TextStyle(fontSize: 13),
            ),
            Text(
              "Gols: ${jogador.gols.toString()}",
              style: TextStyle(fontSize: 13),
            ),
            Text(
              "Asistências: ${jogador.assistencias.toString()}",
              style: TextStyle(fontSize: 13),
            ),
            Text(
              "CA: ${jogador.cartaoAmarelo.toString()}",
              style: TextStyle(fontSize: 13),
            ),
            Text(
              "CV ${jogador.cartaoVermelho.toString()}",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
