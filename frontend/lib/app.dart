import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/resgistro2.dart';
import 'presentation/pages/bienvenida1.dart';
import 'presentation/pages/bienvenida2.dart';
import 'presentation/pages/registro1.dart';
import 'presentation/pages/registroObjetivos.dart';


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


      },
    );
  }
}
