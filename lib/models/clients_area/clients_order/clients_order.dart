import 'package:flutter/material.dart';

import '../../other/super_components/app_bar.dart';
import 'components/table_clients_order.dart';

class ClientsOrder extends StatelessWidget {
  const ClientsOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "none"),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Ordini Clienti",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const TableClientsOrder(),
          ],
        ),
      ),
    );
  }
}
