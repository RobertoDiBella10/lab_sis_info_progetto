import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/data/user_type.dart';
import 'package:lab_sis_info_progetto/main.dart';
import 'package:lab_sis_info_progetto/models/home/components/main_drawer.dart';

import '../other/super_components/app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final String user = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "none"),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Benvenuto ${getUserType()}\n",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Clicca in alto a destra per il menù",
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text(
                  "SITO WEB",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserType() {
    UserType typeUser = userData.getType();
    if (typeUser == UserType.admin) {
      return "Admin";
    } else if (typeUser == UserType.titolare) {
      return "Titolare/Socio";
    } else if (typeUser == UserType.sarto) {
      return "Sarto";
    }
    return "Addetto";
  }
}
