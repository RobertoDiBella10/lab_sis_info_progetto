import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/clients_area/clients/clients.dart';
import 'package:lab_sis_info_progetto/models/clients_area/meetings/meetings.dart';

import '../../data/user_type.dart';
import '../../main.dart';
import '../other/super_components/app_bar.dart';
import 'clients_order/clients_order.dart';

class ClientsArea extends StatelessWidget {
  const ClientsArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "none"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "GESTIONE Clienti\n",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Operazioni",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 40,
            ),
            (userData.getType() == UserType.titolare ||
                    userData.getType() == UserType.admin)
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Clients(),
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
                        "CLIENTI",
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
                      builder: (context) => const ClientsOrder(),
                    ));
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text(
                  "ORDINI CLIENTI",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            (userData.getType() == UserType.titolare ||
                    userData.getType() == UserType.admin ||
                    userData.getType() == UserType.sarto)
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Meeting(),
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
                        "APPUNTAMENTI",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
                const SizedBox(height: 40,),
                      (userData.getType() == UserType.titolare ||
                    userData.getType() == UserType.admin)
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Clients(),
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
                        "NOTE RICERCHE DI MERCATO",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
