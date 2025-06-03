import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/Registro/registroActividadFisica.dart';
import 'package:nutritack/presentation/pages/Registro/registroAlergenos.dart';
import 'package:nutritack/presentation/pages/Registro/registroAltura.dart';
import 'package:nutritack/presentation/pages/Registro/registroEdad.dart';
import 'package:nutritack/presentation/pages/Registro/registroGenero.dart';
import 'package:nutritack/presentation/pages/Registro/registroPeso.dart';
import 'package:nutritack/presentation/pages/Registro/resgistro2.dart';
import '../presentation/pages/Bienvenida/bienvenida1.dart';
import '../presentation/pages/Bienvenida/bienvenida2.dart';
import '../presentation/pages/Registro/registro1.dart';
import '../presentation/pages/Registro/registroObjetivos.dart';
import '../presentation/pages/Registro/registroCampos.dart';
import '../presentation/pages/Login/login.dart';
import '../presentation/pages/PantallaPrincipal/dashboard.dart';
import '../presentation/pages/diario/diario.dart';
import '../presentation/pages/registroalimentos/registroalimentos.dart';
import '../presentation/pages/ajustes/ajustes_page.dart';
import '../presentation/pages/ajustes/perfil_page.dart';


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
        '/registroAltura': (context) => const Registroaltura(),
        '/registroActividadFisica': (context) => const RegistroActividadFisica(),
        '/registroAlergenos': (context) => const RegistroRestriccionesAlimentarias(),
        '/registroCampos': (context) => const RegistroCampos(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/ajustes': (context) => const AjustesPage(),
        '/perfil': (context) => const PerfilPage(),
        '/diario': (context) => const DiarioScreen(),
        '/registralimentos': (context) => const RegistroAlimentosPage(mealType: '',),
        '/ajustes': (context) => const AjustesPage(),
        '/perfil': (context) => const PerfilPage(),




      },
    );
  }
}

