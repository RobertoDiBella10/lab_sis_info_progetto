import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/data/providers.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';

class FilterProviders extends StatefulWidget {
  const FilterProviders({super.key});

  @override
  State<FilterProviders> createState() => _FilterProvidersState();
}

class _FilterProvidersState extends State<FilterProviders> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  int pageNumber = 0;
  int pageSize = 10;
  String search = "";
  List<String> filter = [];
  String sort = "ragioneSociale";

  var _regione = "default_value";
  var _citta = "default_value";
  var _provincia = "default_value";
  var _ragioneSociale = "default_value";
  final List<String> items = [
    'VESTITO',
    'CONFEZIONE',
    'IMBALLAGGIO',
    'Campo vuoto'
  ];
  String selectedValue = "Campo vuoto";

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      Fornitore().showFilterDialog(
          _regione,
          _citta,
          _provincia,
          _ragioneSociale,
          (selectedValue == "Campo vuoto") ? "" : selectedValue,
          context);
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperAppBar(area: "none"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "FILTRAGGIO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Regione",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _regione = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Città",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _citta = value!;
                        },
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Provincia",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _provincia = value!;
                        },
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Ragione Sociale",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _ragioneSociale = value!;
                        },
                      )),
                  const SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!loadingAccess) {
                        _trySubmit();
                      }
                    },
                    child: Container(
                      width: 90,
                      height: 47,
                      margin: const EdgeInsets.only(left: 30),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            offset: const Offset(0.0, 1.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: (loadingAccess)
                          ? SpinKitCircle(
                              size: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return const DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                );
                              },
                            )
                          : const Text(
                              "Filtra",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
