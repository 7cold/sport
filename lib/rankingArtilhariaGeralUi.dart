import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/div.dart';

import 'controller/controller.dart';

class RankingArtilharia extends StatelessWidget {
  const RankingArtilharia({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Controller());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Ranking Artilharia e Jogos'),
        ),
        body: ExtraDiv(
          widget: Column(
            children: c.artilheiros
                .map(
                  (artilheiro) => Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              artilheiro.foto == null
                                  ? CircleAvatar(
                                      radius: 22.0,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
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
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    (artilheiro.gols ?? 0).toString(),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Gols",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Text(
                                    (artilheiro.jogos ?? 0).toString(),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Jogos",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    (((artilheiro.gols ?? 0) / (artilheiro.jogos ?? 0)))
                                        .toStringAsFixed(1),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Média Gols/Jogo",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
