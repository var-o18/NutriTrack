import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/seccionComidas/createComidas.dart';

class SeccionComidasPage extends StatefulWidget {
  const SeccionComidasPage({super.key});

  @override
  State<SeccionComidasPage> createState() => _SeccionComidasPageState();
}

class _SeccionComidasPageState extends State<SeccionComidasPage> {
  int _selectedMenu = 1;
  final List<String> _menus = ['Todo', 'Mis Comidas', 'Mis Alimentos'];

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF2A2A2A);
    final Color accentColor = const Color(0xFF5A99D6);
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 32),
          // Botón Crear Comida
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateComidasPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Crear Comida',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Text(
                  'Registrar tus comidas\npreferidas más rápido',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea y guarda tus comidas favoritas para que puedes registrarlas más rápidos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 15,
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

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class VShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, 60);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomRectWithTopTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final double leftPeakHeight = height * 0.28;
    final double centerValleyHeight = height * 0.36;

    final path = Path();
    path.moveTo(0, leftPeakHeight);
    path.lineTo(width * 0.15, leftPeakHeight);
    path.lineTo(width * 0.5, centerValleyHeight);
    path.lineTo(width * 0.85, leftPeakHeight);
    path.lineTo(width, leftPeakHeight);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SvgTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final double trianglePeakY = height;
    final double trianglePeakX = width / 2;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(trianglePeakX, trianglePeakY);
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
