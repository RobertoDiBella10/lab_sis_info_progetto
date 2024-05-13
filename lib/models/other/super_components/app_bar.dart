import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/data/providers.dart';
import 'package:lab_sis_info_progetto/data/user_type.dart';
import 'package:lab_sis_info_progetto/main.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/products/components/filter/filter_clothes.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/providers/add_provider/add.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/providers/components/filter_providers.dart';

import '../../clients_area/clients/add_clients/add_client.dart';
import '../../warehouse_area/products/add_product/add_product.dart';
import '../../warehouse_area/products/components/filter/filter_pack.dart';
import '../../warehouse_area/products/components/filter/filter_packaging.dart';

class SuperAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SuperAppBar({required this.area, super.key});

  final String area;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.background),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Bocciuolo Sposa SRL",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        if (area == "warehouse_providers")
          IconButton(
              onPressed: () {
                Fornitore().showSortDialog(context);
              },
              icon: const Icon(Icons.sort)),
        if (area == "warehouse_providers")
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterProviders()));
              },
              icon: const Icon(Icons.filter_alt)),
        if (area == "warehouse_product_Imballaggi")
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterPackaging()));
              },
              icon: const Icon(Icons.filter_alt)),
        if (area == "warehouse_product_Confezioni")
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterPack()));
              },
              icon: const Icon(Icons.filter_alt)),
        if (area == "warehouse_product_Vestiti")
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterClothes()));
              },
              icon: const Icon(Icons.filter_alt)),
        PopupMenuButton(onSelected: (result) {
          if (result == 0) {
            userData.logOut(context);
          }
          if (result == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddProvider()));
          }
          if (result == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddProduct()));
          }
          if (result == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddClient()));
          }
          if (result == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddClient()));
          }
        }, itemBuilder: (context) {
          return [
            if (area == "warehouse_providers")
              const PopupMenuItem(value: 1, child: Text("Aggiungi fornitore")),
            if (area == "warehouse_product_Imballaggi" &&
                (userData.getType() == UserType.admin ||
                    userData.getType() == UserType.titolare))
              const PopupMenuItem(value: 2, child: Text("Aggiungi prodotto")),
            if (area == "warehouse_product_Confezioni" &&
                (userData.getType() == UserType.admin ||
                    userData.getType() == UserType.titolare))
              const PopupMenuItem(value: 2, child: Text("Aggiungi prodotto")),
            if (area == "warehouse_product_Vestiti" &&
                (userData.getType() == UserType.admin ||
                    userData.getType() == UserType.titolare))
              const PopupMenuItem(value: 2, child: Text("Aggiungi prodotto")),
            if (area == "clients_client")
              const PopupMenuItem(value: 3, child: Text("Aggiungi cliente")),
            if (area == "clients_orders")
              const PopupMenuItem(value: 4, child: Text("Aggiungi ordine")),
            const PopupMenuItem(value: 0, child: Text("Log out")),
          ];
        })
      ],
      actionsIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.background),
    );
  }
}
