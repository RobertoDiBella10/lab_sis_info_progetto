import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';

class Soon extends StatelessWidget {
  const Soon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SuperAppBar(area: "none"),
      body: Center(
        child: Text(
          "Funzione non implementata",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
