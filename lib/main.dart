import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/user_type.dart';
import 'models/access/access.dart';

///creazione variabili di tema globale
var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.black);

///variabile globale utente
User userData = User();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Laboratorio sistemi informativi',
        theme:
            ThemeData(colorScheme: kColorScheme).copyWith(useMaterial3: true),
        home: const Access());
  }
}
