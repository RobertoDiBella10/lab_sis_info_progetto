import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:lab_sis_info_progetto/data/download_order.dart';

import '../download_order.dart';

// ignore: must_be_immutable
class DownloadTableOrder extends StatefulWidget {
  DownloadTableOrder(
      {required this.pageNumber,
      required this.pageSize,
      required this.sort,
      super.key});

  int pageNumber;
  int pageSize;
  String sort;

  @override
  State<DownloadTableOrder> createState() => _DownloadTableOrderState();
}

class _DownloadTableOrderState extends State<DownloadTableOrder> {
  List<String>? _filterTexts;
  List<String> _selectedRowKeys = [];

  bool isLoading = false;

  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];
  String selectedValue = "10";

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ScaricoMerci().data(
        widget.pageNumber,
        widget.pageSize,
        widget.sort,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return noData();
          } else {
            return hasData(snapshot);
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return loadPage();
      },
    );
  }

  Widget loadPage() {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        CircularProgressIndicator()
      ],
    ));
  }

  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            WebDataTable(
              availableRowsPerPage: const [10, 20, 50, 100],
              rowsPerPage: int.parse(selectedValue),
              header: const Text('Elenco'),
              actions: [
                if (_selectedRowKeys.isNotEmpty)
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: (!isLoading)
                          ? const Text('Completa scaricamento',
                              style: TextStyle(
                                color: Colors.white,
                              ))
                          : SpinKitCircle(
                              size: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return const DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                );
                              },
                            ),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        ScaricoMerci()
                            .setDownload(_selectedRowKeys, context)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          _selectedRowKeys.clear();
                          if (value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DownloadOrders(
                                          pageNumber: 0,
                                          pageSize: 10,
                                          sort: 'ID',
                                        )));
                          }
                        });
                      },
                    ),
                  ),
              ],
              source: WebDataTableSource(
                filterTexts: _filterTexts,
                columns: [
                  WebDataColumn(
                    name: 'id',
                    label: const Text('Numero Ordine'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'addetto',
                    label: const Text('Addetto che ha scaricato la merce'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                ],
                rows: snapshot.data as List<Map<String, dynamic>>,
                selectedRowKeys: _selectedRowKeys,
                onSelectRows: (keys) {
                  setState(() {
                    _selectedRowKeys = keys;
                  });
                },
                primaryKeyName: 'id',
              ),
              horizontalMargin: 15,
            ),
            Positioned(
              right: 5,
              bottom: 8,
              width: 850,
              height: 50,
              child: Container(
                color: const Color.fromARGB(255, 249, 241, 246),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showPageSizeDialog();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "Numero Elementi",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          if (widget.pageNumber != 0) {
                            setState(() {
                              widget.pageNumber--;
                            });
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: (widget.pageNumber != 0)
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              "Pagina indietro",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ))),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      (widget.pageNumber + 1).toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          if ((int.parse(selectedValue) -
                                      snapshot.data!.length ==
                                  0) ||
                              snapshot.data!.isEmpty) {
                            setState(() {
                              widget.pageNumber++;
                            });
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: ((int.parse(selectedValue) -
                                                snapshot.data!.length ==
                                            0) ||
                                        snapshot.data!.isEmpty)
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              "Pagina avanti",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ))),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Nessun ordine in arrivo oggi",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          (widget.pageNumber != 0)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.pageNumber--;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "Pagina indietro",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      )))
              : Container(),
        ],
      ),
    );
  }

  void showPageSizeDialog() {
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
                      const Text("Numero di elementi visualizzabili"),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Seleziona numero',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: itemsNumber
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
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
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
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            stateNumRows();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "CONFERMA",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ))),
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  ///con il seguente metodo si va a aggiornare il numero di righe all'interno della tabella
  void stateNumRows() {
    setState(() {
      widget.pageSize = int.parse(selectedValue);
    });
  }
}
