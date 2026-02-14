import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sport/data/jogos_data.dart';
import 'package:sport/upperCase.dart';
import 'controller/controller.dart';
import 'detalhesJogosUi.dart';

final Controller c = Get.put(Controller());

cadastro(BuildContext context) {
  RxBool emcasa = false.obs;
  TimeOfDay? time = TimeOfDay.now();
  DateTime? date = DateTime.now();
  TextEditingController local = TextEditingController();
  TextEditingController tipoJogo = TextEditingController();
  TextEditingController adversario = TextEditingController();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Obx(
        () => AlertDialog(
          title: const Text("Cadastro"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: context.isPhone ? Get.width : context.width / 3,
              child: Form(
                key: formKey2,
                child: Wrap(
                  children: [
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
                            initialDate: DateTime.now(),
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
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CheckboxListTile(
                          value: emcasa.value,
                          title: const Text("Em casa"),
                          onChanged: (_) {
                            emcasa.value = !emcasa.value;
                            if (emcasa.value) {
                              local.text = "Campo de Crisólia - Crisólia - MG";
                            } else {
                              local.text = "";
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty ? "Campo obrigatorio" : null,
                        inputFormatters: [FirstLetterTextFormatter()],
                        textCapitalization: TextCapitalization.sentences,
                        controller: local,
                        decoration: const InputDecoration(labelText: "Local", filled: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty ? "Campo obrigatorio" : null,
                        inputFormatters: [FirstLetterTextFormatter()],
                        textCapitalization: TextCapitalization.sentences,
                        controller: adversario,
                        decoration: const InputDecoration(labelText: "Adversário", filled: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropDownSearchFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: tipoJogo,
                          decoration: const InputDecoration(hintText: "Tipo", filled: true),
                        ),
                        suggestionsCallback: (pattern) async {
                          return c.tipoJogos;
                        },
                        itemBuilder: (context, data) {
                          return ListTile(
                            title: Text(data),
                          );
                        },
                        onSuggestionSelected: (data) {
                          tipoJogo.text = data;
                        },
                        validator: (value) => value == "" ? "Campo obrigatorio" : null,
                        displayAllSuggestionWhenTap: true,
                      ),
                    ),
                  ],
                ),
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
                if (!formKey2.currentState!.validate()) {
                  return;
                } else {
                  await c.createJogo(JogosData(
                    data: date,
                    hora: DateTime(0, 0, 0, time!.hour, time!.minute),
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

class Calendariojogosui extends StatelessWidget {
  Calendariojogosui({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: c.supabase.auth.currentUser == null
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () {
                cadastro(context);
              },
              child: const Icon(Icons.add),
            ),
      appBar: AppBar(
        title: const Text("Calendário de Jogos"),
      ),
      body: c.loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Obx(
              () => ListView(
                children: c.jogos.map((e) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Responsive(
                      children: [
                        Div(
                          divison: Division(colL: 6, colXL: 4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: e.isCancelado == true && c.supabase.auth.currentUser == null
                                    ? null
                                    : () {
                                        Get.to(() => DetalhesJogosUi(), arguments: e);
                                      },
                                onLongPress: c.supabase.auth.currentUser == null
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
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      runAlignment: WrapAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: FilledButton.icon(
                                                              onPressed: () async {
                                                                c.deleteJogo(e);
                                                                Get.back();
                                                              },
                                                              label: Text("Deletar"),
                                                              icon: Icon(
                                                                  Icons.delete_forever_outlined)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                      },
                                child: Column(
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
                                                padding: const EdgeInsets.all(8.0),
                                                child: Card(
                                                    color: Get.theme.colorScheme.primary,
                                                    child: Center(
                                                        child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(
                                                        e.tipoJogo ?? "",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ))),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Text(
                                                      "${c.dateFormatterSimple.format(e.data ?? DateTime.now())} às ${c.dateFormatterHora.format(e.hora ?? DateTime.now())}"),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
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
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            DateTime.now().isBefore(
                                                                        e.data ?? DateTime.now()) ||
                                                                    e.isCancelado == true
                                                                ? "-"
                                                                : e.placarLocal.toString(),
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
                                                          e.adversario ?? "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            DateTime.now().isBefore(
                                                                        e.data ?? DateTime.now()) ||
                                                                    e.isCancelado == true
                                                                ? "-"
                                                                : e.placarAdversario.toString(),
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
                                                          e.adversario ?? "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            DateTime.now().isBefore(
                                                                        e.data ?? DateTime.now()) ||
                                                                    e.isCancelado == true
                                                                ? "-"
                                                                : e.placarAdversario.toString(),
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
                                                            DateTime.now().isBefore(
                                                                        e.data ?? DateTime.now()) ||
                                                                    e.isCancelado == true
                                                                ? "-"
                                                                : e.placarLocal.toString(),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: e.isCancelado == true
                                          ? Text(
                                              "Jogo Cancelado",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              e.local ?? "",
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
