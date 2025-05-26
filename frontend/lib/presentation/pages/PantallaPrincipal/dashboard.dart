import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController caloriesController = PageController(
        viewportFraction: 0.85);
    final PageController activityController = PageController(
        viewportFraction: 0.9);
    final PageController bottomCarouselController = PageController(
        viewportFraction: 0.85);
    final PageController stepsChartController = PageController(
        viewportFraction: 0.85);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset('assets/images/logonutritracknegro.png', height: 40),
        centerTitle: true,
        leading: const CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 15,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Hoy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: PageView(
                controller: caloriesController,
                children: [
                  _buildCaloriesCard(),
                  _buildMacrosCard(),
                  _buildHealthyHeartCard(),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) =>
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 16),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF80C0FF)),
                        ),
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildStepsCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildExerciseCard()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PageView(
                controller: stepsChartController,
                children: [
                  _buildStepsChartCard(),
                  _buildAppleWatchCard(),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                      (index) =>
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 16),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF80C0FF)),
                        ),
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: PageView(
                controller: bottomCarouselController,
                children: [
                  _buildBottomCarouselCard("Resumen Semanal"),
                  _buildBottomCarouselCard("Estadísticas"),
                  _buildBottomCarouselCard("Logros"),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) =>
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 16),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF80C0FF)),
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xFF80C0FF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/inicio.png',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: Image.asset(
                'assets/images/inicio.png',
                width: 24,
                height: 24,
                color: const Color(0xFF80C0FF),
              ),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/diario.png',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: Image.asset(
                'assets/images/diario.png',
                width: 24,
                height: 24,
                color: const Color(0xFF80C0FF),
              ),
              label: "Diario",
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF80C0FF),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/anadiralimento.png',
                  width: 24,
                  height: 24,
                  color: Colors.black,
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/progreso.png',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: Image.asset(
                'assets/images/progreso.png',
                width: 24,
                height: 24,
                color: const Color(0xFF80C0FF),
              ),
              label: "Control",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/opcionmas.png',
                width: 24,
                height: 24,
                color: Colors.grey,
              ),
              activeIcon: Image.asset(
                'assets/images/opcionmas.png',
                width: 24,
                height: 24,
                color: const Color(0xFF80C0FF),
              ),
              label: "Más",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Calorías",
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
            ),
            const Text(
              "Restantes = Objetivo - Alimentos + Ejercicio",
              style: TextStyle(color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Montserrat'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCalorieItem(
                    Icons.flag, Colors.yellow, "Objetivo base", "2130"),
                _buildCalorieItem(
                    Icons.restaurant, Colors.red, "Alimentos", ""),
                _buildCalorieItem(
                    Icons.fitness_center, Colors.green, "Ejercicios", ""),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey.withOpacity(0.3),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "2130",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          "Restantes",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
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

  Widget _buildMacrosCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: const Center(
        child: Text(
          "Macros",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildHealthyHeartCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: const Center(
        child: Text(
          "Corazón Saludable",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildStepsCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pasos",
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 16),
            Icon(Icons.directions_walk, color: Colors.white, size: 30),
            SizedBox(height: 8),
            Text(
              "Conéctate para\nregistrar los pasos",
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ejercicio",
                  style: TextStyle(color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Montserrat'),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Column(
              children: [
                Text(
                  "0 Cal",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                SizedBox(height: 8),
                Text(
                  "00:00",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsChartCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pasos",
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Montserrat'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Últimos 90 días",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChartRow("96"),
                  _buildChartRow("90"),
                  _buildChartRow("84"),
                  _buildChartRow("78"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppleWatchCard() {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pasos",
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Montserrat'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Apple Watch",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChartRow("96"),
                  _buildChartRow("90"),
                  _buildChartRow("84"),
                  _buildChartRow("78"),
                ],
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
        SizedBox(
          width: 30,
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7), fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCarouselCard(String title) {
    return Card(
      color: const Color(0x4D5A99D6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Icon(
                  _getIconForTitle(title),
                  color: Colors.white.withOpacity(0.7),
                  size: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieItem(IconData icon, Color color, String title,
      String value) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case "Resumen Semanal":
        return Icons.bar_chart;
      case "Estadísticas":
        return Icons.show_chart;
      case "Logros":
        return Icons.emoji_events;
      default:
        return Icons.insert_chart;
    }
  }
}