import 'package:flutter/material.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  int _currentIndex = 1;
  DateTime _selectedDate = DateTime.now();

  Map<String, List<Map<String, dynamic>>> _meals = {
    'Desayuno': [],
    'Almuerzo': [],
    'Cena': [],
    'Aperitivos': [],
  };

  int _getTotalCalories() {
    int total = 0;
    _meals.forEach((key, items) {
      for (var item in items) {
        total += item['calories'] as int;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = const Color(0xFF5A99D6).withOpacity(0.2);
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chevron_left, color: textColor),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_selectedDate),
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.chevron_right, color: textColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 🔥 Calorie Summary
              Text(
                '${_getTotalCalories()}',
                style: TextStyle(color: textColor, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Text(
                'Calorías - Alimentos',
                style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
              ),
              const SizedBox(height: 24),
              // 🍽️ Meal Cards
              Expanded(
                child: ListView(
                  children: _meals.entries.map((entry) {
                    return _buildMealCard(
                      entry.key,
                      entry.value,
                      cardBackgroundColor,
                      textColor,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 🌐 Bottom Navigation Bar
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
                break; // Ya estamos en Diario
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
            _buildBarItem('inicio.png', "Inicio", 0, _currentIndex),
            _buildBarItem('diario.png', "Diario", 1, _currentIndex),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/anadiralimento.png', width: 24),
              ),
              label: "",
            ),
            _buildBarItem('progreso.png', "Control", 3, _currentIndex),
            _buildBarItem('opcionmas.png', "Más", 4, _currentIndex),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem(
      String assetName,
      String label,
      int index,
      int currentIndex,
      ) {
    final bool isActive = index == currentIndex;
    final Color activeColor = const Color(0xFF80C0FF);
    final Color inactiveColor = Colors.grey;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/$assetName',
            width: 24,
            height: 24,
            color: isActive ? activeColor : inactiveColor,
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

  /// 📆 Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF5A99D6),
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF5A99D6),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildMealCard(
      String title,
      List<Map<String, dynamic>> items,
      Color cardBackgroundColor,
      Color textColor,
      ) {
    int totalCalories = items.fold(0, (sum, item) => sum + (item['calories'] as int));

    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$totalCalories Cal",
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 16),

            ...items.map((item) => _buildFoodItem(
              item['name'],
              item['details'],
              "${item['calories']} Cal",
              textColor,
            )),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => _agregarAlimento(title),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text('Agregar alimento', style: TextStyle(color: Colors.blueAccent.shade100)),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFoodItem(String name, String details, String calories, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(color: textColor, fontSize: 14)),
              Text(details, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
            ],
          ),
          Text(calories, style: TextStyle(color: textColor, fontSize: 14)),
        ],
      ),
    );
  }

  void _agregarAlimento(String mealType) {
    print("Agregar alimento a $mealType");
  }
}
