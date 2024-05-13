import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';
import 'components/table_clothes.dart';
import 'components/table_pack.dart';
import 'components/table_packaging.dart';

class ShowProducts extends StatelessWidget {
  const ShowProducts({required this.idOrder, super.key});

  final int pageNumber = 0;
  final int pageSize = 10;
  final String sort = "id";
  final String idOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "warehouse_product"),
      body: Center(
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Text(
              "Dettaglio ordine numero $idOrder",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                TableClothes(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort,
                  filter: const [],
                  idOrder: idOrder,
                ),
                const SizedBox(
                  height: 25,
                ),
                TablePack(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort,
                  filter: const [],
                                    idOrder: idOrder,

                ),
                const SizedBox(
                  height: 25,
                ),
                TablePackaging(
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort,
                  filter: const [],
                                    idOrder: idOrder,

                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
