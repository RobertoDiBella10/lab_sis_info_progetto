import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/data/clothes.dart';
import 'package:lab_sis_info_progetto/data/pack.dart';
import 'package:lab_sis_info_progetto/data/packaging.dart';
import 'package:lab_sis_info_progetto/models/warehouse_area/products/add_product/components/select_pack.dart';
import '../../products.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({super.key});

  @override
  State<FormAddProduct> createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;
  String selectedValue = "Vestiti";
  bool packIsSelected = false;
  int pageNumber = 0;
  int pageSize = 10;
  String search = "";
  List<String> filter = [];
  String sort = "id";

  final List<String> items = [
    'Vestiti',
    'Confezioni',
    'Imballaggi',
  ];

  final List<String> ageitems = [
    '10-15',
    '16-20',
    '21-25',
    '26-30',
    '31-50',
  ];

  final List<String> sizeitems = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  final List<String> stateitems = [
    'Disponibile',
    'Non disponibile',
    'Ordinato',
  ];

  var _id = "default_value";
  var _quantita = "default_value";
  var _nomeProdotto = "default_value";
  var _marca = "default_value";
  var _genere = "default_value";
  var _tipologia = "default_value";
  var _tessuto = "default_value";
  var _colore = "default_value";
  var _costo = "default_value";
  var _taglia = "L";
  var _fasciaEta = "10-15";
  var _confezione = "default_value";
  var _larghezza = "default_value";
  var _lunghezza = "default_value";
  var _profondita = "default_value";
  var _materiale = "default_value";
  var _stato = "Disponibile";

  void _trySubmitClothes() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (!packIsSelected) {
        const snackBar = SnackBar(
          content: Text("Prima di confermare aggiungi una confezione"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else {
      setState(() {
        loadingAccess = true;
      });

      Vestito()
          .addClothes(
              _id,
              _quantita,
              _nomeProdotto,
              _marca,
              _genere,
              _tipologia,
              _fasciaEta,
              _tessuto,
              _colore,
              _costo,
              _taglia,
              _confezione.toString(),
              context)
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
                  builder: (context) => Products(
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        filter: filter,
                        sort: sort,
                        selectedValue: selectedValue,
                      )));
        } else {
          setState(() {
            loadingAccess = false;
          });
        }
      });
      }
    }
  }

  void _trySubmitPackaging() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });

      String dimensione = "${_lunghezza}X${_larghezza}X$_profondita";
      Imballaggio()
          .addPackaging(_id, _quantita, dimensione, _materiale, context)
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
                  builder: (context) => Products(
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        filter: filter,
                        sort: sort,
                        selectedValue: selectedValue,
                      )));
        } else {
          setState(() {
            loadingAccess = false;
          });
        }
      });
    }
  }

  void _trySubmitPack() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });

      String dimensione = "${_lunghezza}X${_larghezza}X$_profondita";
      Confezione()
          .addPack(
              _id, _quantita, _stato, _tipologia, dimensione, _colore, context)
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
                  builder: (context) => Products(
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        filter: filter,
                        sort: sort,
                        selectedValue: selectedValue,
                      )));
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
                _formKey.currentState?.reset();
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
        chooseType(selectedValue),
      ],
    );
  }

  Widget chooseType(selectedValue) {
    if (selectedValue == "Vestiti") {
      return clothesType();
    } else if (selectedValue == "Imballaggi") {
      return packagingType();
    } else {
      return packType();
    }
  }

  Widget clothesType() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 11,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }

              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "ID",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _id = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Quantità",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _quantita = value!;
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
              labelText: "Nome prodotto",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _nomeProdotto = value!;
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
              labelText: "Marca",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _marca = value!;
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
              labelText: "Genere",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _genere = value!;
            },
          ),
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
                      'Seleziona fascia di età',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: ageitems
                  .map((String ageItem) => DropdownMenuItem<String>(
                        value: ageItem,
                        child: Text(
                          ageItem,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: _fasciaEta,
              onChanged: (value) {
                setState(() {
                  _fasciaEta = value!;
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
                  color: Theme.of(context).colorScheme.secondary,
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
                  color: Theme.of(context).colorScheme.secondary,
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
              labelText: "Tessuto",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _tessuto = value!;
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
              labelText: "Colore",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _colore = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 10,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              const pattern = r"^\d{0,8}(\.\d{1,4})?$";
              final regex = RegExp(pattern);

              return value.isNotEmpty && !regex.hasMatch(value)
                  ? 'Costo invalido'
                  : null;
            }),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Costo",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _costo = value!;
            },
          ),
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
                      'Seleziona taglia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: sizeitems
                  .map((String sizeItem) => DropdownMenuItem<String>(
                        value: sizeItem,
                        child: Text(
                          sizeItem,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: _taglia,
              onChanged: (value) {
                setState(() {
                  _taglia = value!;
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
                  color: Theme.of(context).colorScheme.secondary,
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
                  color: Theme.of(context).colorScheme.secondary,
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
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Riempire il campo";
              }
              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Tipologia",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
             _tipologia = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          (packIsSelected)
              ? Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "confezione selezionata",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
              : GestureDetector(
                  onTap: () {
                    ///riceve dalla lista Confezioni il paramentro [idPack] come id per la confezione da inserire nel vestito
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => TableAddPack(
                                pageNumber: 0,
                                pageSize: 10,
                                filter: const [],
                                sort: "id",
                                function: (String idPack) {
                                  setState(() {
                                    packIsSelected = true;
                                    _confezione = idPack;
                                  });
                                }))));
                  },
                  child: Container(
                    width: 200,
                    height: 47,
                    margin: const EdgeInsets.only(left: 30),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                            "Aggiungi confezione",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              if (!loadingAccess) {
                _trySubmitClothes();
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
    );
  }

  Widget packagingType() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 11,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }

              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "ID",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _id = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Quantità",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _quantita = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Lunghezza",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _lunghezza = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Larghezza",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _larghezza = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }
              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Profondità",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _profondita = value!;
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
              labelText: "Materiale",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _materiale = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              if (!loadingAccess) {
                _trySubmitPackaging();
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
    );
  }

  Widget packType() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 11,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }

              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "ID",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _id = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Quantità",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _quantita = value!;
            },
          ),
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
              items: stateitems
                  .map((String stateItem) => DropdownMenuItem<String>(
                        value: stateItem,
                        child: Text(
                          stateItem,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: _stato,
              onChanged: (value) {
                setState(() {
                  _stato = value!;
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
                  color: Theme.of(context).colorScheme.secondary,
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
                  color: Theme.of(context).colorScheme.secondary,
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
              labelText: "Tipologia",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _tipologia = value!;
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
              labelText: "Colore",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _colore = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Lunghezza",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _lunghezza = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Larghezza",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _larghezza = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            maxLength: 50,
            validator: ((value) {
              if (value!.isEmpty) {
                return "Campo Obbligatorio";
              }
              if (double.tryParse(value) == null) {
                return "Concessi solo numeri";
              }
              if (int.parse(value) <= 0) {
                return "Il valore deve essere positivo";
              }

              return null;
            }),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Profondità",
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _profondita = value!;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              if (!loadingAccess) {
                _trySubmitPack();
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
    );
  }
}
