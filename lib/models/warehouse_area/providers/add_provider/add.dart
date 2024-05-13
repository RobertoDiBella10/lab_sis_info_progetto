import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';
import 'components/form_add_provider.dart';

class AddProvider extends StatelessWidget {
  const AddProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SuperAppBar(area: "none"),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Text(
              "\nAggiungi fornitore",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 300,
                child: FormAddProvider()),
                  ],
                ),
          )),
    );
  }
}