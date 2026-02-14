// ignore_for_file: unnecessary_null_comparison

import 'dart:math';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/upperCase.dart';

import 'controller/controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class PlantelUi extends StatefulWidget {
  @override
  State<PlantelUi> createState() => _PlantelUiState();
}

class _PlantelUiState extends State<PlantelUi> {
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
  final Controller c = Get.put(Controller());
  RxBool ativos = true.obs;
  Rx<Uint8List> img = Uint8List(0).obs;

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
                      child: Center(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _pickAndUploadImageCad();
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    img.value.isNotEmpty ? MemoryImage(img.value) : null,
                                radius: 30.0,
                                child: img.value.isNotEmpty
                                    ? null
                                    : Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            Text("Selecione uma foto"),
                          ],
                        ),
                      ),
                    ),
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
                onPressed: () async {
                  var publicUrl;
                  if (img.value.isNotEmpty) {
                    final path = 'fotos_perfil/${Random().nextInt(10000).toString()}.png';
                    final response =
                        await c.supabase.storage.from('arquivos').uploadBinary(path, img.value);

                    if (response != null) {
                      publicUrl = c.supabase.storage.from("arquivos").getPublicUrl(path);
                      print('Upload completo: $publicUrl');
                    } else {
                      print('Erro no upload');
                    }
                  }

                  await c.createJogador(JogadorData(
                    nome: nome.text,
                    posicao: posicao.value,
                    numero: numero.value,
                    ativo: true,
                    gols: 0,
                    jogos: 0,
                    foto: img.value.isNotEmpty ? publicUrl : null,
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
    ).whenComplete(() {
      img.value = Uint8List(0);
    });
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
                      child: Center(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _pickAndUploadImage(jData);
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(jData.foto ?? ""),
                                radius: 30.0,
                              ),
                            ),
                            Text("Foto atual"),
                          ],
                        ),
                      ),
                    ),
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

  Future<void> _pickAndUploadImage(JogadorData jData) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,

      withData: true, // <-- aqui é importante no web
    );

    if (result != null) {
      // Pegamos os bytes
      final fileBytes = result.files.single.bytes;
      final controller = CropController();

      Get.dialog(
        AlertDialog(
          title: Text("Recortar Imagem"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                controller.crop();
              },
              child: Text("Salvar"),
            ),
          ],
          content: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Crop(
                image: fileBytes!,
                controller: controller,
                onCropped: (result) async {
                  switch (result) {
                    case CropSuccess():
                      var imgcup = result.croppedImage;

                      final path = 'fotos_perfil/${Random().nextInt(10000).toString()}.png';

                      final response =
                          await c.supabase.storage.from('arquivos').uploadBinary(path, imgcup);

                      if (response != null) {
                        final publicUrl = c.supabase.storage.from("arquivos").getPublicUrl(path);
                        jData.foto = publicUrl;
                        c.editJogador(jData);
                        print('Upload completo: $publicUrl');
                      } else {
                        print('Erro no upload');
                      }
                    case CropFailure():
                  }
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _pickAndUploadImageCad() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      final fileBytes = result.files.single.bytes;
      final controller = CropController();

      Get.dialog(
        AlertDialog(
          title: Text("Recortar Imagem"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                controller.crop();
              },
              child: Text("Salvar"),
            ),
          ],
          content: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Crop(
                image: fileBytes!,
                controller: controller,
                onCropped: (result) async {
                  switch (result) {
                    case CropSuccess():
                      img.value = result.croppedImage;
                      Get.back();

                    case CropFailure():
                  }
                },
              ),
            ),
          ),
        ),
      );
    }
  }

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
                            leading: Material(
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: jogador.foto == null
                                  ? InkWell(
                                      onTap: () {
                                        // _pickAndUploadImage(jogador);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.lightBlueAccent[300],
                                        radius: 30.0,
                                        child: Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // _pickAndUploadImage(jogador);
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(jogador.foto ?? ""),
                                        radius: 30.0,
                                      ),
                                    ),
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
