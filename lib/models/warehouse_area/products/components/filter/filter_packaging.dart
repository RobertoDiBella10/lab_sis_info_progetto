import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/data/packaging.dart';
import 'package:lab_sis_info_progetto/models/other/super_components/app_bar.dart';

class FilterPackaging extends StatefulWidget {
  const FilterPackaging({super.key});

  @override
  State<FilterPackaging> createState() => _FilterPackagingState();
}

class _FilterPackagingState extends State<FilterPackaging> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  int pageNumber = 0;
  int pageSize = 10;
  List<String> filter = [];
  String sort = "id";

  var _larghezza = "default_value";
  var _lunghezza = "default_value";
  var _profondita = "default_value";

  var _materiale = "default_value";
  String dimensione = "";

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (_lunghezza.isNotEmpty ||
          _larghezza.isNotEmpty ||
          _profondita.isNotEmpty) {
        if (_larghezza.isEmpty || _larghezza.isEmpty || _profondita.isEmpty) {
          setState(() {
            loadingAccess = false;
          });
          const snackBar = SnackBar(
            content: Text("I campi dimensione sono tutti obbligatori"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      }

      
      if (_lunghezza.isNotEmpty &&
          _larghezza.isNotEmpty &&
          _profondita.isNotEmpty) {

        dimensione = "${_lunghezza}X${_larghezza}X$_profondita";
          }
      

      Imballaggio().showFilterDialog(_materiale, dimensione, context);
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
                        labelText: "Lunghezza",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _lunghezza = value!;
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
                        labelText: "Larghezza",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _larghezza = value!;
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
                        labelText: "Profondità",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _profondita = value!;
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
                          labelText: "Materiale",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _materiale = value!;
                        },
                      )),
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
