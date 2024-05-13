import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/data/providers.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/providers/providers.dart';

class FormAddProvider extends StatefulWidget {
  const FormAddProvider({super.key});

  @override
  State<FormAddProvider> createState() => _FormAddProviderState();
}

class _FormAddProviderState extends State<FormAddProvider> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  int pageNumber = 0;
  int pageSize = 10;
  String search = "";
  List<String> filter = [];
  String sort = "ragioneSociale";

  bool _isCheckedClothes = false;
  // ignore: prefer_final_fields
  bool _isCheckedPack = false;
  // ignore: prefer_final_fields
  bool _isCheckedPackaging = false;

  var _piva = "default_value";
  var _regione = "default_value";
  var _citta = "default_value";
  var _provincia = "default_value";
  var _ragioneSociale = "default_value";
  // ignore: prefer_final_fields
  List<String> _tipologiaProdotto = [];
  var _cellulare = "default_value";
  var _email = "default_value";

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_isCheckedClothes) {
        _tipologiaProdotto.add("VESTITO");
      }
      if (_isCheckedPackaging) {
        _tipologiaProdotto.add("CONFEZIONE");
      }
      if (_isCheckedPack) {
        _tipologiaProdotto.add("IMBALLAGGIO");
      }
      Fornitore()
          .addProvider(_piva, _regione, _citta, _provincia, _ragioneSociale,
              _tipologiaProdotto, int.parse(_cellulare), _email, context)
          .then((value) {
        if (value == true) {
          setState(() {
            loadingAccess = true;
          });
          const snackBar = SnackBar(
            content: Text("Operazione eseguita!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Providers(
                      pageNumber: pageNumber,
                      pageSize: pageSize,
                      search: search,
                      filter: filter,
                      sort: sort)));
        } else {
          setState(() {
            loadingAccess = false;
          });
        }
      });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 11,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 11) {
                    return "Minimo 11 caratteri";
                  }
                  if (double.tryParse(value) == null) {
                    return "Concessi solo numeri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Partita IVA",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _piva = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Regione",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _regione = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Città",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _citta = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Provincia",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _provincia = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Ragione Sociale",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _ragioneSociale = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CheckboxListTile(
                title: const Text("Tipologia vestito"),
                value: _isCheckedClothes,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isCheckedClothes = newValue as bool;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Tipologia Imballaggio"),
                value: _isCheckedPack,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isCheckedPack = newValue as bool;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Tipologia Confezione"),
                value: _isCheckedPackaging,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isCheckedPackaging = newValue as bool;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 10,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 10) {
                    return "Minimo 10 caratteri";
                  }
                  if (double.tryParse(value) == null) {
                    return "Concessi solo numeri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Cellulare",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _cellulare = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  const pattern =
                      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                  final regex = RegExp(pattern);

                  return value.isNotEmpty && !regex.hasMatch(value)
                      ? 'Email invalida'
                      : null;
                }),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(
                height: 10,
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
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                              decoration: BoxDecoration(color: Colors.white),
                            );
                          },
                        )
                      : const Text(
                          "Aggiungi",
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
    );
  }
}
