import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/data/user_type.dart';
import 'package:lab_sis_info_progetto/main.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/download_order/download_order.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/products/products.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/providers/providers.dart';
import '../other/super_components/app_bar.dart';
import 'provider_order/provider_orders.dart';

class Warehouse extends StatelessWidget {
  Warehouse({super.key});

  ///Non avendo nessun tipo di filtraggio all'inizializzazione la lista è vuota per garantire il nessun filtraggio
  final List<String> defaultFilter = [];

  ///Non avendo nessun tipo di ordinamento all'inizializzazione la lista è vuota per garantire l'ordinamento di default (ragione Sociale)
  final String defaultSort = "";
  final String search = "default_search";
  final int pageNumber = 0;
  final int pageSize = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "warehouse"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "GESTIONE Magazzino\n",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Operazioni",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 40,
            ),
            (userData.getType() == UserType.admin ||
                    userData.getType() == UserType.titolare)
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Providers(
                                pageNumber: pageNumber,
                                pageSize: pageSize,
                                search: search,
                                filter: defaultFilter,
                                sort: "ragioneSociale"),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Text(
                        "FORNITORI",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProvidersOrders(
                          pageNumber: pageNumber,
                          pageSize: pageSize,
                          sort: "ID"),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text(
                  "ORDINI",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Products(
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        filter: defaultFilter,
                        sort: "id",
                        selectedValue: "Vestiti",
                      ),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text(
                  "SCORTE",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DownloadOrders(
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        sort: "ID",
                      ),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text(
                  "MERCI DA SCARICARE",
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
}
