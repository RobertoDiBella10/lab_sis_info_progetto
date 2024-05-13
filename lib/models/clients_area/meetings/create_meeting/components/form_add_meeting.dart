import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_sis_info_progetto/models/home/home.dart';

class FormAddMeeting extends StatefulWidget {
  const FormAddMeeting({super.key});

  @override
  State<FormAddMeeting> createState() => _FormAddMeetingState();
}

class _FormAddMeetingState extends State<FormAddMeeting> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  var _codiceFiscale = "default_value";
  var _nome = "default_value";
  var _cognome = "default_value";
  var _telefono = "default_value";
  var _via = "default_value";
  var _cap = "default_value";
  var _citta = "default_value";
  var _provincia = "default_value";
  var _email = "default_value";

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
                maxLength: 16,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 16) {
                    return "Minimo 16 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Codice Fiscale",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _codiceFiscale = value!;
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
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _nome = value!;
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
                  labelText: "Cognome",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _cognome = value!;
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
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Telefono",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _telefono = value!;
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
                  labelText: "Via",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _via = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 5,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 5) {
                    return "Minimo 5 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "CAP",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _cap = value!;
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
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _email = value!;
                },
              ),const SizedBox(
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
                  labelText: "Taglia",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _email = value!;
                },
              ),const SizedBox(
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
                  labelText: "Fascia di età",
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
                          "Crea",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ],
    );
  }
}