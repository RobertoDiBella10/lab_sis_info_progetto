import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';

import 'component/form_add_client_order.dart';


class AddClientOrder extends StatefulWidget {
  const AddClientOrder({required this.client, super.key});

  final String client;

  @override
  State<AddClientOrder> createState() => _AddClientOrderState();
}

class _AddClientOrderState extends State<AddClientOrder> {
  String cfClient = "";


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    cfClient = widget.client;
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "none"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CREA ORDINE\n",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Compila i seguenti campi:",
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
                width: 300,
                margin: const EdgeInsets.only(right: 35),
                child: FormAddClientOrder(
                  cfClient: cfClient,
                )),
          ],
        ),
      ),
    );
  }
}