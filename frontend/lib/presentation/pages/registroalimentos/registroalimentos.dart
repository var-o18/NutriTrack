import 'package:flutter/material.dart';
import 'agregar_alimento.dart';
import 'lector_codigo_barras.dart';

class RegistroAlimentosPage extends StatefulWidget {
  final String mealType;
  const RegistroAlimentosPage({super.key, required this.mealType});

  @override
  State<RegistroAlimentosPage> createState() => _RegistroAlimentosPageState();
}

class _RegistroAlimentosPageState extends State<RegistroAlimentosPage> {
  int _currentIndex = 0;
  late String selectedMeal;
  final List<String> mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];

  @override
  void initState() {
    super.initState();
    selectedMeal = widget.mealType;
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color textColor = const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: DropdownButton<String>(
          value: selectedMeal,
          dropdownColor: backgroundColor,
          style: TextStyle(color: textColor, fontSize: 20),
          icon: Icon(Icons.arrow_drop_down, color: textColor),
          underline: Container(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedMeal = newValue;
              });
            }
          },
          items: mealTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Top section with tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab('Mis Comidas', textColor),
                  _buildTab('Mis Recetas', textColor),
                  _buildTab('Mis Alimentos', textColor),
                ],
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Leer código\nde barras',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LectorCodigoBarrasPage(),
                      ),
                    );
                  },
                  backgroundColor: cardBackgroundColor,
                  textColor: textColor,
                ),
                _buildActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Agregar\nNuevo',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgregarAlimentoPage(),
                      ),
                    );
                  },
                  backgroundColor: cardBackgroundColor,
                  textColor: textColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Editorial section
          _buildSection('Historial', 3, cardBackgroundColor, textColor),

          const SizedBox(height: 20),

          // Sugerencias section
          _buildSection('Sugerencias', 3, cardBackgroundColor, textColor),

          const Spacer(),

          // Bottom Navigation Bar
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildTab(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: textColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, int itemCount, Color cardBackgroundColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Ver recientes',
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${title} ${index + 1}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '200 calorías',
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
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
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/dashboard');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/diario');
                break;
              case 2:
                Navigator.pushNamed(context, '/agregarAlimento');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/control');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/mas');
                break;
            }
          },
          items: [
            _buildBarItem('inicio.png', "Inicio", 0),
            _buildBarItem('diario.png', "Diario", 1),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/anadiralimento.png', width: 24),
              ),
              label: "",
            ),
            _buildBarItem('progreso.png', "Control", 3),
            _buildBarItem('opcionmas.png', "Más", 4),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem(String assetName, String label, int index) {
    bool isActive = index == _currentIndex;
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/$assetName',
            width: 24,
            color: isActive ? const Color(0xFF80C0FF) : Colors.grey,
          ),
          if (isActive)
            Container(
              width: 24,
              height: 3,
              color: const Color(0xFF5A99D6),
              margin: const EdgeInsets.only(top: 4),
            )
          else
            const SizedBox(height: 7),
        ],
      ),
      label: label,
    );
  }
}
