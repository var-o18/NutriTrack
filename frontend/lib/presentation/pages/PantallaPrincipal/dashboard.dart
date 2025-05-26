import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color kCardColor = Color(0x4D5A99D6); // 30% opacity

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final PageController caloriesController = PageController(viewportFraction: 0.9);
    final PageController stepsChartController = PageController(viewportFraction: 0.9);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header (Profile + Logo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/image.png',
                        height: size.height * 0.06,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer to balance the Row visually
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Hoy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: size.height * 0.25,
              child: PageView(
                controller: caloriesController,
                children: [
                  _buildCaloriesCard(size),
                  _simpleCard("Macros"),
                  _simpleCard("Corazón Saludable"),
                ],
              ),
            ),
            _buildPageIndicator(3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(child: _simpleCard("Pasos", subtitle: "Conéctate para\nregistrar los pasos", iconPath: 'assets/images/zapatillapasos.png')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildExerciseCard(size)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: size.height * 0.3,
              child: PageView(
                controller: stepsChartController,
                children: [
                  _buildStepsChartCard(size, "Últimos 90 días"),
                  _buildStepsChartCard(size, "Apple Watch"),
                ],
              ),
            ),
            _buildPageIndicator(2),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageIndicator(int count) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
              (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF80C0FF)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesCard(Size size) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Calorías", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat')),
            const Text("Restantes = Objetivo - Alimentos + Ejercicio", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCalorieItem('assets/images/fuegocalorias.png', "Objetivo base", "2130"),
                _buildCalorieItem(Icons.restaurant, "Alimentos", "-"),
                _buildCalorieItem(Icons.fitness_center, "Ejercicios", "-"),
                Container(
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey.withOpacity(0.3)),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("2130", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Restantes", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Size size) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ejercicio", style: TextStyle(color: Colors.white, fontSize: 15)),
                Image.asset('assets/images/controltiempo.png', width: 24),
              ],
            ),
            const SizedBox(height: 16),
            const Column(
              children: [
                Text("0 Cal", style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 8),
                Text("00:00", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsChartCard(Size size, String subtitle) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pasos", style: TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["96", "90", "84", "78"].map(_buildChartRow).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartRow(String label) {
    return Row(
      children: [
        SizedBox(width: 30, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        const Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }

  Widget _buildCalorieItem(dynamic icon, String title, String value) {
    return Column(
      children: [
        icon is String
            ? Image.asset(icon, width: 24)
            : Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _simpleCard(String title, {String? subtitle, String? iconPath}) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: title == "Pasos" && iconPath != null
            ? Row(
          children: [
            Image.asset(iconPath, width: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    subtitle ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              if (iconPath != null) Image.asset(iconPath, width: 30),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
            ]
          ],
        ),
      ),
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
          currentIndex: 0,
          items: [
            _buildBarItem('inicio.png', "Inicio"),
            _buildBarItem('diario.png', "Diario"),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Color(0xFF80C0FF), shape: BoxShape.circle),
                child: Image.asset('assets/images/anadiralimento.png', width: 24, color: Colors.black),
              ),
              label: "",
            ),
            _buildBarItem('progreso.png', "Control"),
            _buildBarItem('opcionmas.png', "Más"),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem(String asset, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset('assets/images/$asset', width: 24, color: Colors.grey),
      activeIcon: Image.asset('assets/images/$asset', width: 24, color: const Color(0xFF80C0FF)),
      label: label,
    );
  }
}
