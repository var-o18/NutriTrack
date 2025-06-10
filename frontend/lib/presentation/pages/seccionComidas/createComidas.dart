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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(
            color: Color(0x4D5A99D6),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/diario');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/descubre');
              break;
            case 4:
              Navigator.pushNamed(context, '/ajustes');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                const Icon(Icons.grid_view),
                if (2 == 0)
                  Container(
                    width: 24,
                    height: 2,
                    color: Colors.blue,
                    margin: const EdgeInsets.only(top: 4),
                  ),
              ],
            ),
            label: 'Panel',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                const Icon(Icons.book),
                if (2 == 1)
                  Container(
                    width: 24,
                    height: 2,
                    color: Colors.blue,
                    margin: const EdgeInsets.only(top: 4),
                  ),
              ],
            ),
            label: 'Diario',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, 5),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                const Icon(Icons.lightbulb_outline),
                if (2 == 3)
                  Container(
                    width: 24,
                    height: 2,
                    color: Colors.blue,
                    margin: const EdgeInsets.only(top: 4),
                  ),
              ],
            ),
            label: 'Descubre',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                const Icon(Icons.more_horiz),
                if (2 == 4)
                  Container(
                    width: 24,
                    height: 2,
                    color: Colors.blue,
                    margin: const EdgeInsets.only(top: 4),
                  ),
              ],
            ),
            label: 'Más',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
