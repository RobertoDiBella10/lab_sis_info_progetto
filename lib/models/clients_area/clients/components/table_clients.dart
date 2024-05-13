import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import '../../../../data/clients.dart';
import '../../clients_order/add_order/add_order.dart';

class TableClients extends StatefulWidget {
  const TableClients({super.key});

  @override
  State<TableClients> createState() => _TableClientsState();
}

class _TableClientsState extends State<TableClients> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    _sortColumnName = 'browser';
    _sortAscending = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_willSearch) {
        if (_latestTick != null && timer.tick > _latestTick!) {
          _willSearch = true;
        }
      }
      if (_willSearch) {
        _willSearch = false;
        _latestTick = null;
        setState(() {
          if (_filterTexts != null && _filterTexts!.isNotEmpty) {
            _filterTexts = _filterTexts;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Cliente().data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return hasData(snapshot);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: WebDataTable(
            header: const Text('Elenco'),
            actions: [
              if (_selectedRowKeys.length == 1)
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.primary)),
                    child: const Text(
                      'Crea Ordine',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddClientOrder(
                                    client: _selectedRowKeys.first,
                                  )));
                    },
                  ),
                ),
              if (_selectedRowKeys.isNotEmpty)
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.error)),
                    child: const Text(
                      'Elimina',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRowKeys.clear();
                      });
                    },
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Filtraggio',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    _filterTexts = text.trim().split(' ');
                    _willSearch = false;
                    _latestTick = _timer?.tick;
                  },
                ),
              ),
            ],
            source: WebDataTableSource(
              sortColumnName: _sortColumnName,
              sortAscending: _sortAscending,
              filterTexts: _filterTexts,
              columns: [
                WebDataColumn(
                  name: 'codiceFiscale',
                  label: const Text('Codice Fiscale'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'nome',
                  label: const Text('Nome'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'cognome',
                  label: const Text('Cognome'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'telefono',
                  label: const Text('Telefono'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'via',
                  label: const Text('Via'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'cap',
                  label: const Text('CAP'),
                  dataCell: (value) => DataCell(Text('$value')),
                  sortable: false,
                ),
                WebDataColumn(
                  name: 'citta',
                  label: const Text('Città'),
                  dataCell: (value) => DataCell(Text('$value')),
                  sortable: false,
                ),
                WebDataColumn(
                  name: 'provincia',
                  label: const Text('Provincia'),
                  dataCell: (value) => DataCell(Text('$value')),
                  sortable: false,
                ),
                WebDataColumn(
                  name: 'email',
                  label: const Text('Email'),
                  dataCell: (value) => DataCell(Text('$value')),
                  sortable: false,
                ),
              ],
              rows: snapshot.data as List<Map<String, dynamic>>,
              selectedRowKeys: _selectedRowKeys,
              onTapRow: (rows, index) {},
              onSelectRows: (keys) {
                setState(() {
                  _selectedRowKeys = keys;
                });
              },
              primaryKeyName: 'codiceFiscale',
            ),
            horizontalMargin: 15,
            onPageChanged: (offset) {},
            onSort: (columnName, ascending) {
              setState(() {
                _sortColumnName = columnName;
                _sortAscending = ascending;
              });
            },
            onRowsPerPageChanged: (rowsPerPage) {
              setState(() {
                if (rowsPerPage != null) {
                  _rowsPerPage = rowsPerPage;
                }
              });
            },
            rowsPerPage: _rowsPerPage,
          ),
        ),
      ),
    );
  }
}
