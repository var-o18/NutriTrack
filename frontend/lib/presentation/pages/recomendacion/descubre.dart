import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/quick_actions.dart';

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
  bool _showTitle = false;

  final int calorias = 1750;
  final int caloriasObjetivo = 2000;
  final double carbs = 134;
  final double protein = 20;
  final double fat = 14;
  final double carbsGoal = 205;
  final double proteinGoal = 75;
  final double fatGoal = 70;

  Color get cardColor => const Color(0x4D5A99D6);
  Color get accentColor => const Color(0xFF5A99D6);
  Color get backgroundColor => const Color(0xFF1E1E1E);

  String get formattedDate => DateFormat('d MMM').format(selectedDate);

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  void _handleScroll(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollUpdateNotification) {
      final bool shouldShowTitle = scrollInfo.metrics.pixels > 140;
      if (shouldShowTitle != _showTitle) {
        setState(() {
          _showTitle = shouldShowTitle;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          _handleScroll(scrollInfo);
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: backgroundColor,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              title: _showTitle 
                ? const Text(
                    'Descubre',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
                    // Fondo con gradiente y patrón
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withOpacity(0.7),
                            backgroundColor,
                          ],
                        ),
                      ),
                    ),
                    // Patrón de decoración
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -60,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // Contenido principal
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Descubre',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Encuentra tu próxima comida',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  _buildNutritionSummary(),
                  const SizedBox(height: 24),
                  _buildCategorySection(),
                  const SizedBox(height: 24),
                  _buildRecommendationsSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () => _changeDate(-1),
          ),
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen Nutricional',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildNutritionCircle(
                'Calorías',
                '$calorias',
                'kcal',
                Icons.local_fire_department,
                accentColor,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildNutrientBar('Carbohidratos', carbs, carbsGoal, accentColor),
                    const SizedBox(height: 12),
                    _buildNutrientBar('Proteínas', protein, proteinGoal, Colors.green),
                    const SizedBox(height: 12),
                    _buildNutrientBar('Grasas', fat, fatGoal, Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCircle(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(String label, double value, double goal, Color color) {
    final percentage = (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '${value.toInt()}/${goal.toInt()}g',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Actual',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Dieta balanceada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recomendaciones para ti',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.recomendaciones.length,
          itemBuilder: (context, index) {
            final recomendacion = widget.recomendaciones[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fastfood,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    recomendacion['nombre'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${recomendacion['calorias']} kcal',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${recomendacion['nombre']} añadido a tu diario',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Agregar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                showQuickActions(context);
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
