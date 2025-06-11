import 'package:flutter/material.dart';

class EjercicioScreen extends StatefulWidget {
  const EjercicioScreen({Key? key}) : super(key: key);

  @override
  State<EjercicioScreen> createState() => _EjercicioScreenState();
}

class _EjercicioScreenState extends State<EjercicioScreen> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _subTabController;

  static const Color kCardColor = Color(0x4D5A99D6);
  static const Color kListColor = Color(0xFF40648A);

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _subTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Inicio', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _mainTabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                indicator: const BoxDecoration(),
                tabs: const [
                  Tab(child: Align(alignment: Alignment.center, child: Text('Cardio'))),
                  Tab(child: Align(alignment: Alignment.center, child: Text('Musculación'))),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                _buildTabContent('Cardio'),
                _buildTabContent('Musculación'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: kListColor,
              side: const BorderSide(color: Color(0xFFB6D0E2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: const Text(
              'Crear un nuevo ejercicio',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String tipo) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _subTabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              indicator: const BoxDecoration(),
              tabs: const [
                Tab(text: 'Historial'),
                Tab(text: 'Mis ejercicios'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              _buildEjerciciosList('$tipo - Historial'),
              _buildEjerciciosList('$tipo - Mis ejercicios'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEjerciciosList(String titulo) {
    // Dummy data
    final ejercicios = List.generate(3, (i) => '$titulo ejercicio ${i + 1}');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...ejercicios.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 16)),
          )),
        ],
      ),
    );
  }
}
