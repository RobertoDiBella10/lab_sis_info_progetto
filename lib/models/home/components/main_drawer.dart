import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/data/user_type.dart';
import 'package:lab_sis_info_progetto/main.dart';
import 'package:lab_sis_info_progetto/models/other/soon.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/warehouse.dart';
import '../../clients_area/clients_area.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Row(
            children: [
              Icon(
                Icons.people,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                "Operazioni",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              )
            ],
          ),
        ),
        (userData.getType() != UserType.socialMediaManager && userData.getType() != UserType.sarto) ?
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  Warehouse(),
              ),
            );
          },
          leading: Icon(
            Icons.warehouse,
            size: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            "Gestione magazzino",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ):Container(),
                (userData.getType() != UserType.socialMediaManager) ?

        ListTile(
          onTap: () {Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClientsArea(),
              ),
            );},
          leading: Icon(
            Icons.person,
            size: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            "Gestione clienti",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ): Container(),
                (userData.getType() != UserType.sarto && userData.getType() != UserType.addetto) ?

        ListTile(
          onTap: () {Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Soon(),
              ),
            );},
          leading: Icon(
            Icons.info,
            size: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            "Gestione servizi",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ):Container(),
                (userData.getType() != UserType.socialMediaManager && userData.getType() != UserType.sarto && userData.getType() != UserType.sarto) ?

        ListTile(
          onTap: () {Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Soon(),
              ),
            );},
          leading: Icon(
            Icons.settings,
            size: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            "Macchinari difettosi",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ):Container(),
      ],
    ));
  }
}
