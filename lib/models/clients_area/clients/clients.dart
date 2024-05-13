import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';

import 'components/table_clients.dart';

class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "clients_client"),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Clienti",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const TableClients(),
          ],
        ),
      ),
    );
  }
}
