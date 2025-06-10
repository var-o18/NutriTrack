import 'package:flutter/material.dart';

class CreateComidasPage extends StatefulWidget {
  const CreateComidasPage({super.key});

  @override
  State<CreateComidasPage> createState() => _CreateComidasPageState();
}

class _CreateComidasPageState extends State<CreateComidasPage> {
  String? _imagePath;
  final TextEditingController _nombreController = TextEditingController();
  // Datos simulados para la vista
  int calorias = 0;
  int carbohidratos = 0;
  int grasas = 0;
  int proteinas = 0;
  List<Map<String, String>> articulos = [
    {'nombre': 'Pavo lonchas', 'detalle': 'Pavo , 80gr'},
    {'nombre': 'Pavo lonchas', 'detalle': 'Pavo , 80gr'},
    {'nombre': 'Pavo lonchas', 'detalle': 'Pavo , 80gr'},
    {'nombre': 'Pavo lonchas', 'detalle': 'Pavo , 80gr'},
  ];

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF2A2A2A);
    final Color accentColor = const Color(0xFF5A99D6);
    final Color textColor = Colors.white;
    final Color sectionColor = const Color(0xFF34495E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Crear comida', style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Agregar foto
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Aquí puedes implementar la selección de imagen
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, color: accentColor, size: 48),
                        const SizedBox(height: 4),
                        Text('Agregar foto', style: TextStyle(color: textColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Nombre de la comida
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              color: sectionColor,
              child: TextField(
                controller: _nombreController,
                style: TextStyle(color: textColor, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Deja tu nombre de comida.....',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          // Calorías y macros
          Container(
            color: sectionColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Calorías
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 4),
                      ),
                      child: Center(
                        child: Text('$calorias\nCal',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                // Carbohidratos
                Column(
                  children: [
                    Text('$carbohidratos g', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Carbohidratos', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
                // Grasas
                Column(
                  children: [
                    Text('$grasas g', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Grasas', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
                // Proteínas
                Column(
                  children: [
                    Text('$proteinas g', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Proteínas', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          // Artículos de la comida
          Container(
            color: cardColor,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: const Text('Artículos de la comida', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
          ),
          Expanded(
            child: Container(
              color: sectionColor,
              width: double.infinity,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: Text('Agregar alimento', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                    onTap: () {
                      // Aquí puedes implementar la funcionalidad para agregar alimento
                    },
                  ),
                  ...articulos.map((art) => ListTile(
                    title: Text(art['nombre']!, style: TextStyle(color: textColor)),
                    subtitle: Text(art['detalle']!, style: TextStyle(color: Colors.white54)),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 1, color: const Color(0xFF5A99D6)),
        BottomNavigationBar(
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: const Color(0xFF80C0FF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: 2, // Pasos
          onTap: (index) {
            // Aquí puedes agregar la navegación según el índice
          },
          items: [
            _buildBarItem(label: "Inicio", assetName: 'inicio.png'),
            _buildBarItem(label: "Diario", assetName: 'diario.png'),
            BottomNavigationBarItem(
              icon: Container(width: 40, height: 40, child: Image.asset('assets/images/anadiralimento.png', width: 24)),
              label: "",
            ),
            _buildBarItem(label: "Pasos", iconData: Icons.directions_walk),
            _buildBarItem(label: "Más", assetName: 'opcionmas.png'),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem({
    required String label,
    String? assetName,
    IconData? iconData,
  }) {
    final Color inactiveColor = Colors.grey;
    Widget iconWidget;
    if (iconData != null) {
      iconWidget = Icon(iconData, size: 24, color: inactiveColor);
    } else if (assetName != null) {
      iconWidget = Image.asset(
        'assets/images/$assetName',
        width: 24,
        height: 24,
        color: inactiveColor,
      );
    } else {
      iconWidget = const SizedBox(width: 24, height: 24);
    }
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 7),
        ],
      ),
      label: label,
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
