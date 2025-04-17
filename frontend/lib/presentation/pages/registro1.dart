import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/resgistro2.dart';
import '../widgets/botones/botonescontinuarcongoogleblancos.dart';


class Registro1 extends StatelessWidget {
  const Registro1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Regístrate',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logonutritracknegro.png',
                width: screenWidth * (344.81 / 390),
                height: screenHeight * (235 / 844),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registro2()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF5A99D6),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF232323),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '─────────────  o  ─────────────',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 20),

            botonesBlancosRegistro(
              iconAsset: 'assets/images/logogoogle.png',
              label: 'Continuar con Google',
              iconWidth: 25,
              iconHeight: 25,
            ),
            const SizedBox(height: 16),
            botonesBlancosRegistro(
              iconAsset: 'assets/images/logoapple.png',
              label: 'Continuar con Apple',
              iconWidth: 50,
              iconHeight: 50,
            ),
            const SizedBox(height: 150),
            GestureDetector(
              onTap: () {
                // Navegar a política
              },
              child: const Text(
                'Política de privacidad de NutriTrack',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              'En NutriTrack, protegemos tu privacidad. Recopilamos información personal y de salud para mejorar tu experiencia. No compartimos tus datos, excepto con proveedores de servicios necesarios. Consulta nuestra política completa para más detalles.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }
}
