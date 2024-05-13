import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import '../../../../data/clients_orders.dart';
import '../../meetings/create_meeting/create_meeting.dart';

class TableClientsOrder extends StatefulWidget {
  const TableClientsOrder({super.key});

  @override
  State<TableClientsOrder> createState() => _TableClientsOrderState();
}

class _TableClientsOrderState extends State<TableClientsOrder> {
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
      future: OrdineClienti().data,
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
    return
    
    
    
    
    
    Container(
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
                      'Crea Appuntamento',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMeeting(
                                    order: _selectedRowKeys.first,
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
                  name: 'numeroOrdine',
                  label: const Text('Numero Ordine'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'stato',
                  label: const Text('Stato'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'data',
                  label: const Text('data'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'codiceFiscaleCliente',
                  label: const Text('Codice Fiscale Cliente'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'codiceFiscaleAddetto',
                  label: const Text('Codice Fiscale Addetto'),
                  dataCell: (value) => DataCell(Text('$value')),
                ),
                WebDataColumn(
                  name: 'scontoApplicato',
                  label: const Text('Sconto Applicato'),
                  dataCell: (value) => DataCell(Text('$value')),
                  sortable: false,
                ),
                WebDataColumn(
                  name: 'tipoConsegna',
                  label: const Text('Tipo Consegna'),
                  dataCell: (value) => DataCell(Text('$value')),
                  sortable: false,
                ),
                WebDataColumn(
                  name: 'totale',
                  label: const Text('Totale'),
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
              primaryKeyName: 'numeroOrdine',
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
