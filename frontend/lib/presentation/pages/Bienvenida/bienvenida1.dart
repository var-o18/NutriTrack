import 'package:flutter/material.dart';

class Bienvenida1 extends StatelessWidget {
  const Bienvenida1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image.png',
                  width: screenWidth * (344.81 / 390),
                  height: screenHeight * (235 / 844),
                  fit: BoxFit.contain,
                ),

                SizedBox(height: screenHeight * 0.05),

                const Text(
                  'Tu compañero ideal \n para alcanzar tus \n objetivos de salud y \n bienestar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),

                SizedBox(height: screenHeight * 0.10),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bienvenida2');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF5A99D6),
                      width: 2.5,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'EMPEZAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
