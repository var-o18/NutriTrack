import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/Registro/registroEdad.dart';
import 'package:nutritack/presentation/pages/Registro/registroGenero.dart';
import 'package:nutritack/presentation/pages/Registro/registroPeso.dart';
import 'package:nutritack/presentation/pages/Registro/resgistro2.dart';
import 'presentation/pages/Bienvenida/bienvenida1.dart';
import 'presentation/pages/Bienvenida/bienvenida2.dart';
import 'presentation/pages/Registro/registro1.dart';
import 'presentation/pages/Registro/registroObjetivos.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Bienvenida1(),
        '/bienvenida2': (context) => const Bienvenida2(),
        '/registro1': (context) => const Registro1(),
        '/registro2': (context) => const Registro2(),
        '/registroObjetivos': (context) => const RegistroObjetivos(),
        '/registroGenero': (context) => const RegistroGenero(),
        '/registroEdad': (context) => const RegistroEdad(),
        '/registroPeso': (context) => const RegistroPeso(),





      },
    );
  }
}
