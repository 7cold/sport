import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/div.dart';

import 'controller/controller.dart';

class RankingArtilharia extends StatelessWidget {
  const RankingArtilharia({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Controller());
    return Scaffold(
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
                        Row(
                          children: [
                            Badge(
                              backgroundColor: Get.theme.primaryColor,
                              label: Text("Gols"),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  (artilheiro.gols ?? 0).toString(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Badge(
                              backgroundColor: Get.theme.primaryColor,
                              label: Text("Jogos"),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  (artilheiro.jogos ?? 0).toString(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Tooltip(
                              message: 'Média de gols por jogo',
                              child: CircleAvatar(
                                radius: 14,
                                child: Text(
                                  (((artilheiro.gols ?? 0) / (artilheiro.jogos ?? 0)))
                                      .toStringAsFixed(1),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
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
    );
  }
}
