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

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  RegistroModel? usuarioDatos;
  late Stream<StepCount> _stepCountStream;
  int _stepCount = 0;
  int _caloriesConsumedToday = 0;
  int _caloriesRemaining = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _requestActivityRecognitionPermission().then((_) {
      _loadInitialData();
      _initPedometer();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("[INFO Dashboard] App resumed, reloading calorie data.");
      _loadCaloriesConsumedToday();
    }
  }

  Future<void> _loadInitialData() async {
    await _loadDatosUsuario();
    await _loadCaloriesConsumedToday();
    _recalculateAndSaveRemainingCalories();
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
    print("[INFO Dashboard] _loadDatosUsuario: Fetching user data...");
    final datos = await getDatosUsuario();
    print("[INFO Dashboard] _loadDatosUsuario: Backend data for user: $datos");
    if (datos != null && mounted) {
      setState(() {
        usuarioDatos = datos;
      });
      _recalculateAndSaveRemainingCalories();
    }
  }

  Future<void> _loadCaloriesConsumedToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final calories = prefs.getInt('today_calories_consumed');
    print('[INFO Dashboard] _loadCaloriesConsumedToday: Read $calories from SharedPreferences key today_calories_consumed');
    
    if (mounted) {
      setState(() {
        _caloriesConsumedToday = calories ?? 0;
        print('[INFO Dashboard] _loadCaloriesConsumedToday: _caloriesConsumedToday set to $_caloriesConsumedToday after loading from prefs.');
      });
      _recalculateAndSaveRemainingCalories();
    }
  }

  void _recalculateAndSaveRemainingCalories() async {
    print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: Called.');
    print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: Current _caloriesConsumedToday: $_caloriesConsumedToday');
    print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: Current usuarioDatos: ${usuarioDatos?.toJson()}');

    if (usuarioDatos != null && usuarioDatos!.caloriasDiarias != null) {
      int goalCalories = usuarioDatos!.caloriasDiarias!;
      int exerciseCalories = 0;
      
      int remaining = goalCalories - _caloriesConsumedToday + exerciseCalories;
      print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: Calculated remaining: $remaining (Goal: $goalCalories - Consumed: $_caloriesConsumedToday + Exercise: $exerciseCalories)');

      if (mounted) {
        setState(() {
          _caloriesRemaining = remaining;
          print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: _caloriesRemaining state set to $_caloriesRemaining');
        });
      }

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('jwt_id');
      if (userId != null) {
        print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: Attempting to update backend for userId: $userId with remaining calories: $remaining');
        await updateCaloriasRestantesUsuario(userId, remaining);
      } else {
        print("[WARN Dashboard] _recalculateAndSaveRemainingCalories: No userId found, cannot update remaining calories in backend.");
      }
    } else {
      print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: usuarioDatos or caloriasDiarias is null. Cannot calculate accurately.');
      if (mounted) {
        setState(() {
          _caloriesRemaining = _caloriesConsumedToday > 0 ? -_caloriesConsumedToday : 0;
          print('[INFO Dashboard] _recalculateAndSaveRemainingCalories: _caloriesRemaining state set to $_caloriesRemaining (fallback logic due to null goal).');
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
    String caloriasConsumidasTexto = _caloriesConsumedToday.toString();
    String caloriasRestantesTexto = _caloriesRemaining.toString();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildCalorieItem(
                      'assets/images/fuegocalorias.png', "Objetivo\nbase", caloriasObjetivoTexto),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildCalorieItem(Icons.restaurant, "Alimentos", caloriasConsumidasTexto)
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildCalorieItem(Icons.fitness_center, "Ejercicios", "-")
                ),
                const SizedBox(width: 8),
                Container(
                  width: size.width * 0.20,
                  height: size.width * 0.20,
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Restantes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
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
    String formattedTitle = title;
    if (!title.contains('\n')) {
      formattedTitle = '$title\n';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: icon is String
                ? Image.asset(icon, width: 26, height: 26)
                : Icon(icon, color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          formattedTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
          maxLines: 2,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
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
            if (index == _currentIndex) return;
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/diario');
                break;
              case 2:
                Navigator.pushNamed(context, '/agregarAlimento');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/descubre');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/mas');
                break;
            }
          },
          items: [
            _buildBarItem(label: "Inicio", index: 0, currentIndex: _currentIndex, assetName: 'inicio.png'),
            _buildBarItem(label: "Diario", index: 1, currentIndex: _currentIndex, assetName: 'diario.png'),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                    'assets/images/anadiralimento.png', width: 24),
              ),
              label: "",
            ),
            _buildBarItem(label: "Descubre", index: 3, currentIndex: _currentIndex, iconData: Icons.lightbulb_outline),
            _buildBarItem(label: "Más", index: 4, currentIndex: _currentIndex, assetName: 'opcionmas.png'),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem({
    required String label,
    required int index,
    required int currentIndex,
    String? assetName,
    IconData? iconData,
  }) {
    final bool isActive = index == currentIndex;
    final Color activeColor = const Color(0xFF80C0FF);
    final Color inactiveColor = Colors.grey;

    Widget iconWidget;
    if (iconData != null) {
      iconWidget = Icon(iconData, size: 24, color: isActive ? activeColor : inactiveColor);
    } else if (assetName != null) {
      iconWidget = Image.asset(
        'assets/images/$assetName',
        width: 24,
        height: 24,
        color: isActive ? activeColor : inactiveColor,
      );
    } else {
      iconWidget = const SizedBox(width: 24, height: 24);
    }

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
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
