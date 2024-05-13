
import 'dart:js_interop';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../data/providers.dart';
import 'components/select_table_clothes.dart';
import 'components/select_table_pack.dart';
import 'components/select_table_packaging.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Order extends StatefulWidget {
  Order(
      {required this.pageNumber,
      required this.pageSize,
      required this.filter,
      required this.sort,
      required this.selectedValue,
      required this.provider,
      required this.typeProvider,
      super.key});

  final int pageNumber;
  final int pageSize;
  final List<String> filter;
  final String sort;
  String selectedValue;
  String provider;
  List<String> typeProvider;

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> items = [
    'Vestiti',
    'Confezioni',
    'Imballaggi',
  ];

  int _idOrder = 0;
  DateTime _deliveryProduct = DateTime.now();
  double total = 0;

  List<Map<String, dynamic>> order = [];

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      Fornitore()
          .createOrder(_idOrder, order, widget.provider, formatted,
              _deliveryProduct.toString().substring(0, 10), total, context)
          .then((value) {
        if (!value) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }

  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    if (!widget.typeProvider.contains("VESTITO")) {
      items.remove('Vestiti');
    }
    if (!widget.typeProvider.contains("CONFEZIONE")) {
      items.remove('Confezioni');
    }
    if (!widget.typeProvider.contains("IMBALLAGGIO")) {
      items.remove('Imballaggi');
    }
    widget.selectedValue = items.first;
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
      appBar: const SuperAppBar(
        area: "none",
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  DropdownButtonHideUnderline(
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
                        iconEnabledColor:
                            Theme.of(context).colorScheme.background,
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
                  GestureDetector(
                    onTap: () {
                      if (order.isNotEmpty) {
                        showInsertNumberOrder();
                      }
                    },
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: (order.isNotEmpty)
                                ? Theme.of(context).colorScheme.error
                                : Colors.grey),
                        child: Text(
                          "Completa Ordine",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        )),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                ],
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

  void showInsertNumberOrder() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Aggiungi all'ordine",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                maxLength: 20,
                                validator: ((value) {
                                      if (double.tryParse(value!) == null) {
                                    return "Concessi solo numeri";
                                  }
                                  if (value.isEmpty) {
                                    return "Campo Obbligatorio";
                                  }
                              
                                  if (int.parse(value) <= 0) {
                                    return "Il valore deve essere positivo";
                                  }
                                  return null;
                                }),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Numero Ordine",
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _idOrder = int.parse(value!);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: DateTimeField(
                                decoration: const InputDecoration(
                                  labelText: "Data consegna",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isNull) {
                                    return "Inserire data di consegna prodotto";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _deliveryProduct = value as DateTime;
                                },
                                format: DateFormat("yyyy-MM-dd"),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2200),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isLoading) {
                                  _trySubmit();
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 47,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.shadow,
                                      offset: const Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: (isLoading)
                                    ? SpinKitCircle(
                                        size: 20,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return const DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                          );
                                        },
                                      )
                                    : const Text(
                                        "Conferma",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ])),
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  Widget getTable(String selectedValue) {
    if (selectedValue == "Vestiti") {
      return TableSelectClothes(
          pageNumber: widget.pageNumber,
          pageSize: widget.pageSize,
          filter: widget.filter,
          sort: widget.sort,
          function:
              (String idProduct, int quantity, double price) {
            bool found = false;
            Map<String, dynamic> product = {
              'id': idProduct,
              'quantity': quantity,
              'price': price,
            };
            for (Map<String, dynamic> singleProduct in order) {
              if (singleProduct['id'] == idProduct) {
                found = true;
              }
            }
            if (found) {
              var snackBar = const SnackBar(
                content: Text(
                    "Prodotto non inserito perchè già presente nell'ordine"),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              order.add(product);
              total += quantity*price;
              var snackBar = const SnackBar(
                content: Text("Prodotto aggiunto!"),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {});
            }
          });
    } else if (selectedValue == "Confezioni") {
      return TableSelectPack(
          pageNumber: widget.pageNumber,
          pageSize: widget.pageSize,
          filter: (widget.filter.length > 4)
              ? widget.filter.sublist(0, 3)
              : widget.filter,
          sort: widget.sort,
          function: (String idProduct, int quantity, double price) {
            bool found = false;
            Map<String, dynamic> product = {
              'id': idProduct,
              'quantity': quantity,
              'price': price
            };
            for (Map<String, dynamic> singleProduct in order) {
              if (singleProduct['id'] == idProduct) {
                found = true;
              }
            }
            if (found) {
              var snackBar = const SnackBar(
                content: Text(
                    "Prodotto non inserito perchè già presente nell'ordine"),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              order.add(product);
                            total += quantity*price;

              var snackBar = const SnackBar(
                content: Text("Prodotto aggiunto!"),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {});
            }
          });
    } else {
      return TableSelectPackaging(
          pageNumber: widget.pageNumber,
          pageSize: widget.pageSize,
          filter: (widget.filter.length > 2)
              ? widget.filter.sublist(0, 1)
              : widget.filter,
          sort: widget.sort,
          function: (String idProduct, int quantity, double price) {
            bool found = false;
            Map<String, dynamic> product = {
              'id': idProduct,
              'quantity': quantity,
              'price': price
            };
            for (Map<String, dynamic> singleProduct in order) {
              if (singleProduct['id'] == idProduct) {
                found = true;
              }
            }
            if (found) {
              var snackBar = const SnackBar(
                content: Text(
                    "Prodotto non inserito perchè già presente nell'ordine"),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              order.add(product);
                            total += quantity*price;

              var snackBar = const SnackBar(
                content: Text("Prodotto aggiunto!"),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {});
            }
          });
    }
  }
}
