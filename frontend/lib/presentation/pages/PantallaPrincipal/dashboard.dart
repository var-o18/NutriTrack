import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/registro_model.dart';
import '../../../data/services/login_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const Color kCardColor = Color(0x4D5A99D6);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  RegistroModel? usuarioDatos;
  late Stream<StepCount> _stepCountStream;
  int _stepCount = 0;
  int _caloriasConsumidasHoy = 0;

  @override
  void initState() {
    super.initState();

    _requestActivityRecognitionPermission().then((_) {
      _loadDatosUsuario();
      _initPedometer();
      _loadConsumedCalories();
    });
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _stepCount = event.steps;
    });
  }

  void _onStepCountError(error) {
    print('Error del pedómetro: $error');
  }

  Future<void> _loadDatosUsuario() async {
    print("Iniciando consulta al backend...");
    final datos = await getDatosUsuario();
    print("Datos recibidos del backend: $datos");
    if (datos != null) {
      setState(() {
        usuarioDatos = datos;
      });
    }
  }

  Future<void> _loadConsumedCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? consumed = prefs.getInt('today_calories_consumed');
    print('[DashboardScreen] Loaded today_calories_consumed: $consumed');
    if (consumed != null) {
      if (mounted) {
        setState(() {
          _caloriasConsumidasHoy = consumed;
        });
      }
    }
  }

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
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Hoy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
                  Expanded(
                    child: Card(
                      color: DashboardScreen.kCardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Image.asset('assets/images/zapatillapasos.png', width: 40),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Pasos",
                                      style: TextStyle(color: Colors.white, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(
                                    _stepCount > 0
                                        ? "$_stepCount pasos"
                                        : "Conéctate para\nregistrar los pasos",
                                    style: TextStyle(
                                      color: _stepCount > 0 ? Colors.white : Colors.white70,
                                      fontSize: _stepCount > 0 ? 18 : 12,
                                      fontWeight:
                                      _stepCount > 0 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    int? caloriasObjetivo = usuarioDatos?.caloriasDiarias;
    String caloriasObjetivoTexto = caloriasObjetivo?.toString() ?? '0';

    String caloriasConsumidasTexto = _caloriasConsumidasHoy.toString();

    int caloriasEjercicio = 0;
    String caloriasEjercicioTexto = caloriasEjercicio.toString();

    int caloriasRestantes = (caloriasObjetivo ?? 0) - _caloriasConsumidasHoy + caloriasEjercicio;
    String caloriasRestantesTexto = caloriasRestantes.toString();

    return Card(
      color: DashboardScreen.kCardColor,
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
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
            const Text(
              "Restantes = Objetivo - Alimentos + Ejercicio",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCalorieItem(
                      'assets/images/fuegocalorias.png', "Objetivo", caloriasObjetivoTexto),
                ),
                Expanded(child: _buildCalorieItem(Icons.restaurant, "Alimentos", caloriasConsumidasTexto)),
                Expanded(child: _buildCalorieItem(Icons.fitness_center, "Ejercicios", caloriasEjercicioTexto)),
                Container(
                  width: size.width * 0.22,
                  height: size.width * 0.22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          caloriasRestantesTexto,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Restantes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
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

  Widget _buildExerciseCard(Size size) {
    return Card(
      color: DashboardScreen.kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Ejercicio",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                Icon(Icons.add, color: Colors.white, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/fuegocalorias.png', width: 22),
                    const SizedBox(width: 8),
                    const Text("0 Cal",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset('assets/images/controltiempo.png', width: 22),
                    const SizedBox(width: 8),
                    const Text("00:00",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsChartCard(Size size, String subtitle) {
    return Card(
      color: DashboardScreen.kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pasos",
                style: TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["96", "90", "84", "78"]
                    .map(_buildChartRow)
                    .toList(),
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
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12))),
        const Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }

  Widget _buildCalorieItem(dynamic icon, String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: icon is String
                ? Image.asset(icon, width: 28, height: 28)
                : Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMacroCircle(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.7),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _simpleCard(String title, {String? subtitle, String? iconPath}) {
    if (title == "Macros") {
      return Card(
        color: DashboardScreen.kCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Macros",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMacroCircle("Carbs", "150g", Colors.blue),
                  _buildMacroCircle("Proteína", "90g", Colors.green),
                  _buildMacroCircle("Grasa", "60g", Colors.orange),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: DashboardScreen.kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: title == "Pasos" && iconPath != null
            ? Row(
          children: [
            Image.asset(iconPath, width: 40),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                      const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(subtitle ?? '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(color: Colors.white, fontSize: 18)),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              if (iconPath != null) Image.asset(iconPath, width: 30),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center),
            ]
          ],
        ),
      ),
    );
  }

  int _currentIndex = 0;

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
                Navigator.pushNamed(context, '/ajustes');
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
            _buildBarItem('opcionmas.png', "Ajustes", 4, _currentIndex),
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

  Future<void> _requestActivityRecognitionPermission() async {
    final status = await Permission.activityRecognition.status;

    if (!status.isGranted) {
      final result = await Permission.activityRecognition.request();
      if (result.isGranted) {
        print('Permiso ACTIVITY_RECOGNITION concedido');
      } else {
        print('Permiso ACTIVITY_RECOGNITION denegado');
      }
    } else {
      print('Permiso ACTIVITY_RECOGNITION ya estaba concedido');
    }
  }
}
