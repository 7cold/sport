import 'dart:math';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/jogador_data.dart';
import 'package:sport/upperCase.dart';

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
Rx<Uint8List> img = Uint8List(0).obs;

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

Future<void> _pickAndUploadImage(JogadorData jData) async {
  final Controller c = Get.find();
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

Future<void> cadastroJogador(BuildContext context) {
  TextEditingController nome = TextEditingController();
  RxString posicao = "GOL".obs;
  RxInt numero = 0.obs;
  final Controller c = Get.find();

  return showFDialog<void>(
      context: context,
      builder: (context, style, animation) => FDialog(
            actions: [
              FButton(
                  style: FButtonStyle.outline(),
                  child: const Text('Cancelar'),
                  onPress: () => Navigator.of(context).pop()),
              FButton(
                  child: const Text('Salvar'),
                  onPress: () async {
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
                  }),
            ],
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: context.isPhone ? Get.width : context.width / 3,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Column(
                          children: [
                            Material(
                              child: InkWell(
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
                            ),
                            Text("Selecione uma foto"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FTextField(
                        controller: nome,
                        inputFormatters: [FirstLetterTextFormatter()],
                        textCapitalization: TextCapitalization.sentences,
                        description: Text("Nome"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FSelect<String>.rich(
                        initialValue: posicao.value,
                        description: Text("Posição"),
                        hint: 'Selecione uma opção',
                        format: (s) => s,
                        onChange: (String? newValue) {
                          posicao.value = newValue ?? "";
                        },
                        children: items
                            .map((e) => FSelectItem<String>(
                                  value: e,
                                  title: Text(e),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          )).whenComplete(() {
    img.value = Uint8List(0);
  });
}

Future<void> editJogador(BuildContext context, JogadorData jData) {
  TextEditingController nome = TextEditingController(text: jData.nome);
  Rx<String?> posicao = jData.posicao.obs;
  Rx<int?> numero = jData.numero.obs;
  final Controller c = Get.find();

  return showFDialog<void>(
    context: context,
    builder: (context, style, animation) => FDialog(
      actions: [
        FButton(
            style: FButtonStyle.outline(),
            child: const Text('Cancelar'),
            onPress: () => Navigator.of(context).pop()),
        FButton(
            child: const Text('Salvar'),
            onPress: () {
              jData.nome = nome.text;
              jData.posicao = posicao.value;
              jData.numero = numero.value;

              c.editJogador(jData);
            }),
      ],
      body: SizedBox(
        width: context.isPhone ? Get.width : context.width / 3,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                child: Column(
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () {
                          _pickAndUploadImage(jData);
                        },
                        child: FAvatar(
                          image: NetworkImage(jData.foto ?? ""),
                        ),
                      ),
                    ),
                    Text("Foto atual"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FTextField(
                controller: nome,
                description: Text("Nome"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FSelect<String>.rich(
                initialValue: posicao.value,
                description: Text("Posição"),
                hint: 'Selecione uma opção',
                format: (s) => s,
                onChange: (String? newValue) {
                  posicao.value = newValue ?? "";
                },
                children: items
                    .map((e) => FSelectItem<String>(
                          value: e,
                          title: Text(e),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: FSelect<String>.rich(
                initialValue: numero.value.toString(),
                description: Text("Numero"),
                hint: 'Selecione uma opção',
                format: (s) => s,
                onChange: (String? newValue) {
                  numero.value = int.tryParse(newValue ?? "") ?? 0;
                },
                children: items
                    .map((e) => FSelectItem<String>(
                          value: e,
                          title: Text(e),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
