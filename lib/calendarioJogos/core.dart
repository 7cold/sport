import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:sport/controller/controller.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/upperCase.dart';

cadastroJogos(BuildContext context) {
  final Controller c = Get.find();
  RxBool emcasa = false.obs;
  TimeOfDay? hora = TimeOfDay.now();
  DateTime? date = DateTime.now();
  TextEditingController local = TextEditingController();
  TextEditingController tipoJogo = TextEditingController();
  TextEditingController adversario = TextEditingController();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  return showFDialog<void>(
    context: context,
    builder: (context, _, __) {
      return Obx(
        () => FDialog(
          title: const Text("Cadastro"),
          body: SingleChildScrollView(
            child: SizedBox(
              width: context.isPhone ? Get.width : context.width / 3,
              child: Form(
                key: formKey2,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FTextField(
                          controller: adversario,
                          label: Text("Adversario"),
                        ),
                        FTextField(
                          controller: local,
                          label: Text("Local"),
                        ),
                        FDateField(
                          label: Text('Data'),
                          initialDate: DateTime.now(),
                          onChange: (pickedDate) {
                            if (pickedDate != null) {
                              date = pickedDate;
                            }
                          },
                        ),
                        FTimeField(
                          initialTime: FTime(hora!.hour, hora!.minute),
                          hour24: true,
                          label: Text('Hora'),
                          onChange: (pickedDate) {
                            if (pickedDate != null) {
                              hora = TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute);
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FCheckbox(
                          value: emcasa.value,
                          label: const Text("Em casa"),
                          onChange: (_) {
                            emcasa.value = !emcasa.value;
                            if (emcasa.value) {
                              local.text = "Campo de Crisólia - Crisólia - MG";
                            } else {
                              local.text = "";
                            }
                          }),
                    ),
                    FSelect<String>.rich(
                      initialValue: tipoJogo.text,
                      label: Text("Tipo de jogo"),
                      hint: 'Selecione uma opção',
                      format: (s) => s,
                      onChange: (String? newValue) {
                        tipoJogo.text = newValue ?? "";
                      },
                      children: c.tipoJogos
                          .map((e) => FSelectItem<String>(
                                value: e,
                                title: Text(e),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            FButton(
              style: FButtonStyle.ghost(),
              onPress: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            FButton(
              onPress: () async {
                if (!formKey2.currentState!.validate()) {
                  return;
                } else {
                  await c.createJogo(JogosData(
                    data: date,
                    hora: DateTime(0, 0, 0, hora!.hour, hora!.minute),
                    local: local.text,
                    tipoJogo: tipoJogo.text,
                    adversario: adversario.text,
                    isCancelado: false,
                    emCasa: emcasa.value,
                    uniforme: 1,
                    placarLocal: 0,
                    placarAdversario: 0,
                    escalacao: {
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
                      "ATAE": null
                    },
                  ));
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      );
    },
  );
}
