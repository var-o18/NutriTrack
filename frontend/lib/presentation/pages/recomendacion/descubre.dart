import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DescubrePage extends StatefulWidget {
  final int caloriasRestantes;
  final List<Map<String, dynamic>> recomendaciones;

  const DescubrePage({
    Key? key,
    required this.caloriasRestantes,
    required this.recomendaciones,
  }) : super(key: key);

  @override
  State<DescubrePage> createState() => _DescubrePageState();
}

class _DescubrePageState extends State<DescubrePage> {
  int _currentIndex = 3;
  DateTime selectedDate = DateTime.now();

  final int calorias = 1750;
  final int caloriasObjetivo = 2000;
  final double carbs = 134;
  final double protein = 20;
  final double fat = 14;
  final double carbsGoal = 205;
  final double proteinGoal = 75;
  final double fatGoal = 70;

  Color get cardColor => const Color(0x4D5A99D6); // azul translúcido
  Color get accentColor => const Color(0xFF5A99D6); // azul fuerte
  Color get backgroundColor => const Color(0xFF1E1E1E);

  String get formattedDate => DateFormat('d MMM').format(selectedDate);

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Descubre',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateBar(),
            const SizedBox(height: 18),
            _buildMacrosCard(),
            const SizedBox(height: 16),
            _buildRecommendationCard(),
            const SizedBox(height: 18),
            const Text(
              'Te recomendamos:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: widget.recomendaciones.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final alimento = widget.recomendaciones[index];
                  return _alimentoCard(alimento, context);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDateBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _changeDate(-1),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            formattedDate,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _changeDate(1),
            child: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Row(
        children: [
          // Círculo de calorías
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withOpacity(0.18),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department, color: accentColor, size: 28),
                  const SizedBox(height: 4),
                  Text('$calorias', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const Text('KCAL', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          // Barras de macros
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _macroBar('Carbs', carbs, carbsGoal, accentColor, Colors.white),
                const SizedBox(height: 12),
                _macroBar('Proteína', protein, proteinGoal, const Color(0xFF22C55E), Colors.white),
                const SizedBox(height: 12),
                _macroBar('Grasa', fat, fatGoal, const Color(0xFFF59E0B), Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroBar(String label, double value, double goal, Color color, Color textColor) {
    double percent = (goal > 0) ? (value / goal).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15)),
            Text('${value.toStringAsFixed(0)}g', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text('${(value/goal*100).clamp(0,100).toStringAsFixed(0)}% de $label', style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.emoji_food_beverage, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Plan actual: Dieta balanceada',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
        ],
      ),
    );
  }

  Widget _alimentoCard(Map<String, dynamic> alimento, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: alimento['imagen'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  alimento['imagen'],
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.fastfood, color: accentColor, size: 40),
        title: Text(
          alimento['nombre'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '${alimento['calorias']} kcal',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${alimento['nombre']} añadido a tu diario')),
            );
          },
          child: const Text('Agregar', style: TextStyle(color: Colors.white)),
        ),
      ),
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
      child: Theme(
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
            if (index == _currentIndex) return;
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
                  if (_currentIndex == 0)
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
                  if (_currentIndex == 1)
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
                  if (_currentIndex == 3)
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
                  if (_currentIndex == 4)
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
      ),
    );
  }
}

// Ejemplo de uso:
// DescubrePage(
//   caloriasRestantes: 500,
//   recomendaciones: [
//     {'nombre': 'Manzana', 'calorias': 52, 'imagen': 'assets/images/manzana.png'},
//     {'nombre': 'Yogur natural', 'calorias': 80, 'imagen': 'assets/images/yogur.png'},
//   ],
// )
