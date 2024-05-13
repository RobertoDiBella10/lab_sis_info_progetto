import 'package:flutter/material.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';
import 'components/table_providers.dart';

// ignore: must_be_immutable
class Providers extends StatelessWidget {
   const Providers({required this.pageNumber, required this.pageSize, required this.search, required this.filter, required this.sort,super.key});

  final int pageNumber;
  final int pageSize;
  final String search;
  final List<String> filter;
    final String sort;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const SuperAppBar(area: "warehouse_providers"),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Fornitori",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
             TableProviders(pageNumber: pageNumber,pageSize: pageSize,search: search, filter: filter, sort: sort),
          ],
        ),
      ),
    );
  }
}
