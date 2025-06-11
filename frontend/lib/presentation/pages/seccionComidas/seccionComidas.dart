import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/seccionComidas/createComidas.dart';

class SeccionComidasPage extends StatefulWidget {
  const SeccionComidasPage({super.key});

  @override
  State<SeccionComidasPage> createState() => _SeccionComidasPageState();
}

class _SeccionComidasPageState extends State<SeccionComidasPage> {
  int _selectedMenu = 1; // 0: Todo, 1: Mis Comidas, 2: Mis Alimentos
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
          // Mensaje informativo
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
    path.lineTo(size.width / 2, 60); // Profundidad del pico
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
    final double leftPeakHeight = height * 0.28; // Más alto
    final double centerValleyHeight = height * 0.36; // Mantener el centro

    final path = Path();
    path.moveTo(0, leftPeakHeight); // Inicio en el lateral izquierdo
    path.lineTo(width * 0.15, leftPeakHeight); // Pico izquierdo más cerca del borde
    path.lineTo(width * 0.5, centerValleyHeight); // Pico central hacia abajo
    path.lineTo(width * 0.85, leftPeakHeight); // Pico derecho más cerca del borde
    path.lineTo(width, leftPeakHeight); // Lateral derecho
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
    // El vértice del triángulo debe estar en el borde inferior
    final double trianglePeakY = height; // Ahora el pico está en el borde inferior
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
