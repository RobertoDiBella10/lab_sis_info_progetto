import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/products/components/table_clothes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'components/table_pack.dart';
import 'components/table_packaging.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget {
  Products(
      {required this.pageNumber,
      required this.pageSize,
      required this.filter,
      required this.sort,
      required this.selectedValue,
      super.key});

  final int pageNumber;
  final int pageSize;
  final List<String> filter;
  final String sort;
  String selectedValue;

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final List<String> items = [
    'Vestiti',
    'Confezioni',
    'Imballaggi',
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "warehouse_product_${widget.selectedValue}",
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Seleziona tipologia',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: widget.selectedValue,
                  onChanged: (value) {
                    setState(() {
                      widget.selectedValue = value!;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 190,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: IconStyleData(
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Theme.of(context).colorScheme.background,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: getTable(widget.selectedValue)),
          ],
        ),
      ),
    );
  }

  Widget getTable(String selectedValue) {
    if (selectedValue == "Vestiti") {
      return TableClothes(
          pageNumber: widget.pageNumber,
          pageSize: widget.pageSize,
          filter: widget.filter,
          sort: widget.sort);
    } else if (selectedValue == "Confezioni") {
      return TablePack(
          pageNumber: widget.pageNumber,
          pageSize: widget.pageSize,
          filter: (widget.filter.length > 4) ? widget.filter.sublist(0,3): widget.filter,
          sort: widget.sort);
    } else {
      return TablePackaging(
          pageNumber: widget.pageNumber,
          pageSize: widget.pageSize,
          filter: (widget.filter.length > 2) ? widget.filter.sublist(0,1) : widget.filter,
          sort: widget.sort);
    }
  }
}
