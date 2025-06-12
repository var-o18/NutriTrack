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
import '../presentation/pages/registroalimentos/lector_codigo_barras.dart';
import '../presentation/pages/registroalimentos/registroalimentos.dart';
import '../presentation/pages/ajustes/ajustes_page.dart';
import '../presentation/pages/ajustes/perfil_page.dart';
import '../presentation/pages/recomendacion/descubre.dart';
import '../presentation/pages/seccionComidas/createComidas.dart';

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
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/lectorCodigoBarras': (context) => LectorCodigoBarrasPage(),
        '/agregarComida': (context) => CreateComidasPage(),
        '/ajustes': (context) => const AjustesPage(),
        '/perfil': (context) => const PerfilPage(),
        '/diario': (context) => const DiarioScreen(),
        '/registralimentos': (context) => const RegistroAlimentosPage(mealType: ''),
        '/descubre': (context) => DescubrePage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    DiarioScreen(),
    RegistroAlimentosPage(mealType: ''),
    DescubrePage(),
    AjustesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1E1E1E),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() => _currentIndex = index);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Panel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Diario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              label: 'Descubre',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Más',
            ),
          ],
        ),
      ),
    );
  }
}