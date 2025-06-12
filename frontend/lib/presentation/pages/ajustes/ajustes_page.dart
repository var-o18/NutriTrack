import 'package:flutter/material.dart';
import '../Bienvenida/bienvenida1.dart';
import 'notificaciones_page.dart';
import 'ejercicios_page.dart';
import 'apariencia_page.dart';
import 'nutricion_page.dart';
import 'ajustes_diario_page.dart';
import 'premium_page.dart';
import '../../../data/services/login_service.dart';
import '../../pages/Login/login.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color textColor = const Color(0xFFFFFFFF);

    List<Map<String, dynamic>> menuItems = [
      {'title': 'Perfil', 'route': '/perfil'},
      {
        'title': 'Apariencia de la aplicación',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AparienciaPage()),
          );
        }
      },
      {
        'title': 'Ajustes del diario',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjustesDiarioPage()),
          );
        }
      },
      {
        'title': 'Mis ejercicios',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EjerciciosPage()),
          );
        }
      },
      {
        'title': 'Ajustes de nutrición semanales',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NutricionPage()),
          );
        }
      },
      {
        'title': 'Notificaciones automáticas',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificacionesPage()),
          );
        }
      },
      {
        'title': 'Cerrar sesión',
        'onTap': (BuildContext context) async {
          await logoutUser();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Bienvenida1()),
              (Route<dynamic> route) => false,
            );
          }
        }
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title: Text(
          'Ajustes',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      menuItems[index]['title']!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: textColor,
                    ),
                    onTap: () {
                      if (menuItems[index]['onTap'] != null) {
                        menuItems[index]['onTap'](context);
                      } else {
                        Navigator.pushNamed(context, menuItems[index]['route']!);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Hazte Premium y consigue resultados',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Los usuarios Premium tienen un 65% más de probabilidades de cumplir sus objetivos de pérdida de peso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PremiumPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB74D),
                          minimumSize: const Size(200, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Pásate a Premium',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 