import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/models/home/home.dart';

class FormAddClientOrder extends StatefulWidget {
  const FormAddClientOrder({required this.cfClient, super.key});

  final String cfClient;

  @override
  State<FormAddClientOrder> createState() => _FormAddClientOrderState();
}

class _FormAddClientOrderState extends State<FormAddClientOrder> {
  final _formKey = GlobalKey<FormState>();

  var _totalCost = "";
  var cfClient = "";
  bool loadingAccess = false;

  //inserire metodo pssaggio parametri super classe per caricamento prodotti

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    }
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
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || int.parse(value) < 0) {
                    return "Valore invalido";
                  }
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: "Costo totale",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _totalCost = value!;
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
                  height: 45,
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
                          "Accedi",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
