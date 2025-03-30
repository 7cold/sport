import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/upperCase.dart';

import 'controller/controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class PlantelUi extends StatelessWidget {
  final List<String> items = [
    "GOL",
    "LD",
    "LE",
    "DEF",
    "VOL",
    "MEI",
    "ATA",
  ];

  List<int> numbers = List.generate(99, (index) => index + 1);

  cadastroJogador(BuildContext context) {
    TextEditingController nome = TextEditingController();
    RxString posicao = "GOL".obs;
    RxInt numero = 1.obs;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Obx(
          () => AlertDialog(
            title: Row(
              children: [const Text("Cadastro")],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: context.isPhone ? Get.width : context.width / 3,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        inputFormatters: [FirstLetterTextFormatter()],
                        textCapitalization: TextCapitalization.sentences,
                        controller: nome,
                        decoration: const InputDecoration(labelText: "Nome", filled: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(filled: true),
                        value: posicao.value,
                        hint: Text("Selecione uma opção"),
                        icon: Icon(Icons.arrow_drop_down), // Ícone do dropdown
                        onChanged: (String? newValue) {
                          posicao.value = newValue ?? "";
                        },
                        items: items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(filled: true),
                        value: numero.value,
                        hint: Text("Selecione uma opção"),
                        icon: Icon(Icons.arrow_drop_down), // Ícone do dropdown
                        onChanged: (newValue) {
                          numero.value = newValue ?? 0;
                        },
                        onTap: () {},
                        items: numbers.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
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
                  c.createJogador(JogadorData(
                    nome: nome.text,
                    posicao: posicao.value,
                    numero: numero.value,
                    ativo: true,
                    gols: 0,
                    assistencias: 0,
                    cartaoAmarelo: 0,
                    cartaoVermelho: 0,
                  ));
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        );
      },
    );
  }

  editJogador(BuildContext context, JogadorData jData) {
    TextEditingController nome = TextEditingController(text: jData.nome);
    Rx<String?> posicao = jData.posicao.obs;
    Rx<int?> numero = jData.numero.obs;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Obx(
          () => AlertDialog(
            title: const Text("Editar"),
            content: SingleChildScrollView(
              child: SizedBox(
                width: context.isPhone ? Get.width : context.width / 3,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        controller: nome,
                        decoration: const InputDecoration(labelText: "Nome", filled: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(filled: true),
                        value: posicao.value,
                        hint: Text("Selecione uma opção"),
                        icon: Icon(Icons.arrow_drop_down), // Ícone do dropdown
                        onChanged: (String? newValue) {
                          posicao.value = newValue ?? "";
                        },
                        items: items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(filled: true),
                        value: numero.value,
                        hint: Text("Selecione uma opção"),
                        icon: Icon(Icons.arrow_drop_down), // Ícone do dropdown
                        onChanged: (newValue) {
                          numero.value = newValue ?? 0;
                        },
                        onTap: () {},
                        items: numbers.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
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
                  jData.nome = nome.text;
                  jData.posicao = posicao.value;
                  jData.numero = numero.value;

                  c.editJogador(jData);
                },
                child: const Text("Editar"),
              ),
            ],
          ),
        );
      },
    );
  }

  final Controller c = Get.put(Controller());

  RxBool ativos = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plantel'),
        actions: c.supabase.auth.currentUser == null
            ? []
            : [
                IconButton(
                    onPressed: () {
                      c.getJogadores();
                    },
                    icon: Icon(Icons.refresh)),
                IconButton(
                    onPressed: () {
                      cadastroJogador(context);
                    },
                    icon: Icon(Icons.add)),
                PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry>[
                          CheckedPopupMenuItem(
                            checked: ativos.value == true ? true : false,
                            onTap: () {
                              ativos.value = !ativos.value;
                            },
                            child: const Text("Ativos"),
                          ),
                          CheckedPopupMenuItem(
                            checked: ativos.value == true ? false : true,
                            onTap: () {
                              ativos.value = !ativos.value;
                            },
                            child: Text("Inativos"),
                          ),
                        ])
              ],
      ),
      body: Obx(() {
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
                      child: Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
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
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.center,
                                                runAlignment: WrapAlignment.center,
                                                children: [
                                                  Text("Opções",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold)),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: jogador.ativo == false
                                                            ? FilledButton.icon(
                                                                onPressed: () {
                                                                  jogador.ativo = true;
                                                                  c.inativarJogador(jogador);
                                                                },
                                                                label: Text("Ativar"),
                                                                icon: Icon(Icons.check))
                                                            : FilledButton.icon(
                                                                onPressed: () {
                                                                  jogador.ativo = false;
                                                                  c.inativarJogador(jogador);
                                                                },
                                                                label: Text("Desativar"),
                                                                icon: Icon(
                                                                    Icons.do_disturb_alt_sharp)),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: FilledButton.icon(
                                                            onPressed: () {
                                                              Get.back();
                                                              editJogador(context, jogador);
                                                            },
                                                            label: Text("Editar"),
                                                            icon: Icon(Icons.edit)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                },
                          child: ExpansionTile(
                            expandedAlignment: Alignment.centerLeft,
                            title: Wrap(
                              children: [
                                Text(jogador.nome ?? ""),
                                SizedBox(
                                  width: 8,
                                ),
                                CircleAvatar(
                                    radius: 12,
                                    child: Text(
                                      jogador.numero.toString(),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            subtitle: Text(jogador.posicao ?? ""),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(jogador.foto ?? ""),
                              radius: 30.0,
                            ),
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.transparent,
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Badge(
                                        backgroundColor: Colors.red[400],
                                        label: Text(
                                          jogador.gols.toString(),
                                          style:
                                              TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        child: Wrap(
                                          children: [
                                            Text("Gols: "),
                                            Icon(
                                              Icons.sports_soccer_outlined,
                                              size: 20,
                                            ),
                                          ],
                                        )),
                                    SizedBox(width: 14),
                                    Badge(
                                        backgroundColor: Get.theme.primaryColor,
                                        label: Text(
                                          jogador.assistencias.toString(),
                                          style:
                                              TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        child: Wrap(
                                          children: [
                                            Text("Assistências: "),
                                            Icon(Icons.text_format_rounded, size: 22),
                                          ],
                                        )),
                                    SizedBox(width: 14),
                                    Badge(
                                        backgroundColor: Get.theme.primaryColor,
                                        label: Text(
                                          jogador.jogos.toString(),
                                          style:
                                              TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        child: Wrap(
                                          children: [
                                            Text("Jogos: "),
                                            Icon(Icons.crop_square_outlined, size: 22),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
