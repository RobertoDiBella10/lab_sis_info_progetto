import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';
import 'components/table_orders.dart';

class ProvidersOrders extends StatelessWidget {
  const ProvidersOrders({required this.pageNumber, required this.pageSize, required this.sort,super.key});

  final int pageNumber;
  final int pageSize;
    final String sort;

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
                "Ordini Fornitori",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
             TableOrders(pageNumber: pageNumber,pageSize: pageSize, sort: sort),
          ],
        ),
      ),
    );
  }
}
