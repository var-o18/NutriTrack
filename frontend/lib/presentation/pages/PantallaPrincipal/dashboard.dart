import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/alimneto_model.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/models/registro_model.dart';
import '../../../data/services/alimentos_service.dart';
import '../../../data/services/login_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/services/ingesta_service.dart';
import '../../../utils/quick_actions.dart';
import '../AgregadoEjercicio/ejercicio.dart';


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
  List<int> _stepHistory = [0, 0, 0, 0]; // Historial de los últimos 4 días
  int _caloriasConsumidasHoy = 0;
  double _totalCarbs = 0;
  double _totalProtein = 0;
  double _totalFat = 0;
  double _totalSodium = 0;
  double _healthyFatPercentage = 0;
  int _currentCardIndex = 0;
  int _currentStepsCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _loadDatosUsuario();
    _loadConsumedCalories();
    _loadTodayMacros();
    _loadHeartHealthMetrics();
    _loadStepHistory();
    _loadCurrentStepCount(); // Cargar el contador actual de pasos
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadConsumedCalories(); // Recargar calorías cuando cambian las dependencias
  }

  Future<void> _loadCurrentStepCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    
    setState(() {
      _stepCount = prefs.getInt(dateKey) ?? 0;
    });
  }

  void _onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    
    // Obtener el valor base guardado
    final baseSteps = prefs.getInt('${dateKey}_base') ?? 0;
    
    // Calcular la diferencia desde el último reinicio
    final stepDifference = event.steps - baseSteps;
    
    // Actualizar el contador total
    final newTotalSteps = _stepCount + stepDifference;
    
    setState(() {
      _stepCount = newTotalSteps;
    });
    
    // Guardar el nuevo total
    await prefs.setInt(dateKey, newTotalSteps);
    
    // Actualizar el valor base para el próximo cálculo
    await prefs.setInt('${dateKey}_base', event.steps);
    
    _saveStepCount();
    print('Pasos actualizados: $_stepCount');
  }

  void _initPedometer() {
    print('[DEBUG Pedometer] Inicializando pedómetro...');
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount);
  }

  @override
  void dispose() {
    _stepCountStream.drain();
    super.dispose();
  }

  Future<void> _loadDatosUsuario() async {
    print("Iniciando consulta al backend para datos de usuario...");
    final datos = await getDatosUsuario();
    print("Datos recibidos del backend (crudo): $datos");
    if (datos != null) {
      setState(() {
        usuarioDatos = datos;
      });
      print("usuarioDatos establecido: ${usuarioDatos?.caloriasDiarias}");
    } else {
      print("No se recibieron datos del backend para el usuario.");
    }
  }

  Future<void> _loadConsumedCalories() async {
    try {
      final IngestaService ingestaService = IngestaService();
      final calorias = await ingestaService.calcularYGuardarCaloriasConsumidas();
      print('[DashboardScreen] Calorías calculadas: $calorias');
      
      if (mounted) {
        setState(() {
          _caloriasConsumidasHoy = calorias;
        });
        print('[DashboardScreen] Estado actualizado con $_caloriasConsumidasHoy calorías');
      }
    } catch (e) {
      print('[DashboardScreen] Error al cargar calorías: $e');
    }
  }

  Future<void> _loadTodayMacros() async {
    final IngestaService ingestaService = IngestaService();
    final AlimentoService alimentoService = AlimentoService();

    try {
      print('[DEBUG] _loadTodayMacros: Fetching all foods...');
      final List<Alimento> todosLosAlimentos = await alimentoService.getAllAlimentos();
      print('[DEBUG] _loadTodayMacros: Fetched ${todosLosAlimentos.length} foods');
      
      final Map<int, Alimento> mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };
      print('[DEBUG] _loadTodayMacros: Created food map with ${mapaAlimentos.length} entries');

      print('[DEBUG] _loadTodayMacros: Fetching user intakes...');
      final List<Ingesta> ingestasDelUsuario = await ingestaService.obtenerIngestasDelUsuario();
      print('[DEBUG] _loadTodayMacros: Fetched ${ingestasDelUsuario.length} intakes');

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      print('[DEBUG] _loadTodayMacros: Current date: ${today.toIso8601String()}');

      double totalCarbs = 0;
      double totalProtein = 0;
      double totalFat = 0;

      for (var ingesta in ingestasDelUsuario) {
        DateTime fechaIngesta;
        try {
          // Parsear la fecha y hora de la ingesta
          fechaIngesta = DateTime.parse('${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          // Ajustar a UTC+2
          fechaIngesta = fechaIngesta.add(const Duration(hours: 2));
          // Normalizar a inicio del día para comparación
          fechaIngesta = DateTime(fechaIngesta.year, fechaIngesta.month, fechaIngesta.day);
          
          print('[DEBUG] _loadTodayMacros: Processing intake:');
          print('[DEBUG] _loadTodayMacros: - Original date: ${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          print('[DEBUG] _loadTodayMacros: - Adjusted date: ${fechaIngesta.toIso8601String()}');
          print('[DEBUG] _loadTodayMacros: - Today: ${today.toIso8601String()}');
          print('[DEBUG] _loadTodayMacros: - Is same day: ${fechaIngesta.isAtSameMomentAs(today)}');
        } catch (e) {
          print('[ERROR] _loadTodayMacros: Error parsing date: ${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          continue;
        }

        if (!fechaIngesta.isAtSameMomentAs(today)) {
          print('[DEBUG] _loadTodayMacros: Skipping intake from different day');
          continue;
        }

        final Alimento? alimento = mapaAlimentos[ingesta.alimentoId];
        if (alimento != null) {
          double factor = ingesta.cantidad / 100.0;
          print('[DEBUG] _loadTodayMacros: Processing food:');
          print('[DEBUG] _loadTodayMacros: - Food ID: ${alimento.id}');
          print('[DEBUG] _loadTodayMacros: - Food name: ${alimento.nombre}');
          print('[DEBUG] _loadTodayMacros: - Quantity: ${ingesta.cantidad}g');
          print('[DEBUG] _loadTodayMacros: - Factor: $factor');
          print('[DEBUG] _loadTodayMacros: - Base values (per 100g):');
          print('[DEBUG] _loadTodayMacros:   * Carbs: ${alimento.carbohidratos}g');
          print('[DEBUG] _loadTodayMacros:   * Protein: ${alimento.proteinas}g');
          print('[DEBUG] _loadTodayMacros:   * Fat: ${alimento.grasas}g');

          double carbs = alimento.carbohidratos * factor;
          double protein = alimento.proteinas * factor;
          double fat = alimento.grasas * factor;

          print('[DEBUG] _loadTodayMacros: - Calculated values:');
          print('[DEBUG] _loadTodayMacros:   * Carbs: ${carbs.toStringAsFixed(1)}g');
          print('[DEBUG] _loadTodayMacros:   * Protein: ${protein.toStringAsFixed(1)}g');
          print('[DEBUG] _loadTodayMacros:   * Fat: ${fat.toStringAsFixed(1)}g');

          totalCarbs += carbs;
          totalProtein += protein;
          totalFat += fat;
        } else {
          print('[WARNING] _loadTodayMacros: Food not found for ID: ${ingesta.alimentoId}');
        }
      }

      print('[DEBUG] _loadTodayMacros: Final totals:');
      print('[DEBUG] _loadTodayMacros: - Total carbs: ${totalCarbs.toStringAsFixed(1)}g');
      print('[DEBUG] _loadTodayMacros: - Total protein: ${totalProtein.toStringAsFixed(1)}g');
      print('[DEBUG] _loadTodayMacros: - Total fat: ${totalFat.toStringAsFixed(1)}g');

      if (mounted) {
        setState(() {
          _totalCarbs = totalCarbs;
          _totalProtein = totalProtein;
          _totalFat = totalFat;
        });
        print('[DEBUG] _loadTodayMacros: State updated with new values');
      }
    } catch (e) {
      print('[ERROR] _loadTodayMacros: Error loading macros: $e');
    }
  }

  Future<void> _loadHeartHealthMetrics() async {
    final IngestaService ingestaService = IngestaService();
    final AlimentoService alimentoService = AlimentoService();

    try {
      print('[DEBUG] _loadHeartHealthMetrics: Fetching all foods...');
      final List<Alimento> todosLosAlimentos = await alimentoService.getAllAlimentos();
      print('[DEBUG] _loadHeartHealthMetrics: Fetched ${todosLosAlimentos.length} foods');
      
      final Map<int, Alimento> mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };
      print('[DEBUG] _loadHeartHealthMetrics: Created food map with ${mapaAlimentos.length} entries');

      print('[DEBUG] _loadHeartHealthMetrics: Fetching user intakes...');
      final List<Ingesta> ingestasDelUsuario = await ingestaService.obtenerIngestasDelUsuario();
      print('[DEBUG] _loadHeartHealthMetrics: Fetched ${ingestasDelUsuario.length} intakes');

      final now = DateTime.now();
      print('[DEBUG] _loadHeartHealthMetrics: Current date: ${now.toIso8601String()}');

      double totalSodium = 0;
      double totalHealthyFat = 0;
      double totalFat = 0;

      for (var ingesta in ingestasDelUsuario) {
        DateTime fechaIngesta;
        try {
          fechaIngesta = DateTime.parse('${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          fechaIngesta = fechaIngesta.add(const Duration(hours: 2)); // Ajustar a UTC+2
          print('[DEBUG] _loadHeartHealthMetrics: Processing intake:');
          print('[DEBUG] _loadHeartHealthMetrics: - Original date: ${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          print('[DEBUG] _loadHeartHealthMetrics: - Adjusted date: ${fechaIngesta.toIso8601String()}');
        } catch (e) {
          print('[ERROR] _loadHeartHealthMetrics: Error parsing date: ${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          continue;
        }

        if (fechaIngesta.year != now.year ||
            fechaIngesta.month != now.month ||
            fechaIngesta.day != now.day) {
          print('[DEBUG] _loadHeartHealthMetrics: Skipping intake from different day');
          continue;
        }

        final Alimento? alimento = mapaAlimentos[ingesta.alimentoId];
        if (alimento != null) {
          double factor = ingesta.cantidad / 100.0;
          print('[DEBUG] _loadHeartHealthMetrics: Processing food:');
          print('[DEBUG] _loadHeartHealthMetrics: - Food ID: ${alimento.id}');
          print('[DEBUG] _loadHeartHealthMetrics: - Food name: ${alimento.nombre}');
          print('[DEBUG] _loadHeartHealthMetrics: - Quantity: ${ingesta.cantidad}g');
          print('[DEBUG] _loadHeartHealthMetrics: - Factor: $factor');
          print('[DEBUG] _loadHeartHealthMetrics: - Base values (per 100g):');
          print('[DEBUG] _loadHeartHealthMetrics:   * Sodium: ${alimento.sodio}mg');
          print('[DEBUG] _loadHeartHealthMetrics:   * Healthy fat: ${alimento.grasasSaludables}g');
          print('[DEBUG] _loadHeartHealthMetrics:   * Total fat: ${alimento.grasas}g');

          double sodium = alimento.sodio * factor;
          double healthyFat = alimento.grasasSaludables * factor;
          double fat = alimento.grasas * factor;

          print('[DEBUG] _loadHeartHealthMetrics: - Calculated values:');
          print('[DEBUG] _loadHeartHealthMetrics:   * Sodium: ${sodium.toStringAsFixed(1)}mg');
          print('[DEBUG] _loadHeartHealthMetrics:   * Healthy fat: ${healthyFat.toStringAsFixed(1)}g');
          print('[DEBUG] _loadHeartHealthMetrics:   * Total fat: ${fat.toStringAsFixed(1)}g');

          totalSodium += sodium;
          totalHealthyFat += healthyFat;
          totalFat += fat;
        } else {
          print('[WARNING] _loadHeartHealthMetrics: Food not found for ID: ${ingesta.alimentoId}');
        }
      }

      print('[DEBUG] _loadHeartHealthMetrics: Final totals:');
      print('[DEBUG] _loadHeartHealthMetrics: - Total sodium: ${totalSodium.toStringAsFixed(1)}mg');
      print('[DEBUG] _loadHeartHealthMetrics: - Total healthy fat: ${totalHealthyFat.toStringAsFixed(1)}g');
      print('[DEBUG] _loadHeartHealthMetrics: - Total fat: ${totalFat.toStringAsFixed(1)}g');

      double healthyFatPercentage = totalFat > 0 ? (totalHealthyFat / totalFat) * 100 : 0;
      print('[DEBUG] _loadHeartHealthMetrics: - Healthy fat percentage: ${healthyFatPercentage.toStringAsFixed(1)}%');

      if (mounted) {
        setState(() {
          _totalSodium = totalSodium;
          _healthyFatPercentage = healthyFatPercentage;
        });
        print('[DEBUG] _loadHeartHealthMetrics: State updated with new values');
      }
    } catch (e) {
      print('[ERROR] _loadHeartHealthMetrics: Error loading heart health metrics: $e');
    }
  }

  Future<void> _loadStepHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    
    // Cargar historial de los últimos 4 días
    for (int i = 0; i < 4; i++) {
      final date = today.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month}-${date.day}';
      _stepHistory[i] = prefs.getInt(dateKey) ?? 0;
    }
    
    setState(() {});
  }

  Future<void> _saveStepCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    
    // Guardar pasos de hoy
    await prefs.setInt(dateKey, _stepCount);
    
    // Actualizar historial
    _stepHistory[0] = _stepCount;
    setState(() {});
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
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/image.png',
                        height: 50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 37.0, right: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hoy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: size.height * 0.25,
              child: PageView(
                controller: caloriesController,
                onPageChanged: (index) {
                  setState(() {
                    _currentCardIndex = index;
                  });
                },
                children: [
                  _buildCaloriesCard(),
                  _simpleCard("Macros"),
                  _simpleCard("Corazón Saludable"),
                ],
              ),
            ),
            _buildPageIndicator(3, _currentCardIndex),
            _buildActivitySection(),
            const SizedBox(height: 16),
            SizedBox(
              height: size.height * 0.3,
              child: PageView(
                controller: stepsChartController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStepsCardIndex = index;
                  });
                },
                children: [
                  _buildStepsChartCard(size, "Últimos 90 días"),
                  _buildStepsChartCard(size, "Apple Watch"),
                ],
              ),
            ),
            _buildPageIndicator(2, _currentStepsCardIndex),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageIndicator(int count, int currentIndex) {
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
              color: currentIndex == index ? const Color(0xFF80C0FF) : Colors.transparent,
              border: Border.all(color: const Color(0xFF80C0FF)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesCard() {
    int? caloriasObjetivo = usuarioDatos?.caloriasDiarias;
    int caloriasRestantes = (caloriasObjetivo ?? 0) - _caloriasConsumidasHoy;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x4D5A99D6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Calorías",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Restantes = Objetivo - Alimentos + Ejercicio",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26,
                            border: Border.all(
                              color: Colors.white10,
                              width: 8,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              caloriasRestantes.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Restantes",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Objetivo base",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  "${caloriasObjetivo ?? 0}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Alimentos",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  "$_caloriasConsumidasHoy",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EjercicioScreen()),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Ejercicio",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 12),
            Flexible(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EjercicioScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  constraints: const BoxConstraints(
                    maxWidth: 165,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x4D5A99D6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Pasos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/zapatillapasos.png',
                            width: 24,
                            height: 24,
                            color: Colors.pink,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _stepCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        "Objetivo: 10.000 pasos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EjercicioScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  constraints: const BoxConstraints(
                    maxWidth: 165,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x4D5A99D6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ejercicio",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "0 cal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "00:00 h",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsChartCard(Size size, String subtitle) {
    // Encontrar el máximo para la escala
    int maxPasos = _stepHistory.reduce((a, b) => a > b ? a : b);
    maxPasos = ((maxPasos / 100).ceil() * 100); // Redondear al siguiente múltiplo de 100
    if (maxPasos == 0) maxPasos = 10000; // Valor por defecto si no hay pasos

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
                children: [
                  _buildStepsBar(_stepHistory[0], maxPasos, "Hoy"),
                  _buildStepsBar(_stepHistory[1], maxPasos, "Ayer"),
                  _buildStepsBar(_stepHistory[2], maxPasos, "Hace 2 días"),
                  _buildStepsBar(_stepHistory[3], maxPasos, "Hace 3 días"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsBar(int pasos, int maxPasos, String label) {
    double porcentaje = pasos / maxPasos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: porcentaje,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF5A99D6).withOpacity(0.8),
                            const Color(0xFF5A99D6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              pasos.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0x4D5A99D6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Macros",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildModernMacroCircle(
                    "Carbs",
                    "${_totalCarbs.toStringAsFixed(1)}g",
                    const Color(0xFF3B82F6),
                    Icons.grain,
                  ),
                  _buildModernMacroCircle(
                    "Proteína",
                    "${_totalProtein.toStringAsFixed(1)}g",
                    const Color(0xFF22C55E),
                    Icons.fitness_center,
                  ),
                  _buildModernMacroCircle(
                    "Grasa",
                    "${_totalFat.toStringAsFixed(1)}g",
                    const Color(0xFFF59E0B),
                    Icons.water_drop,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (title == "Corazón Saludable") {
      return Card(
        color: DashboardScreen.kCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Corazón Saludable", style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 12),
                _heartBar("Sodio", _totalSodium, 2300, Colors.blue),
                _heartBar("Grasas Saludables", _healthyFatPercentage, 100, Colors.green),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Recomendaciones:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    MouseRegion(
                      onEnter: (_) => _showRecommendationOverlay(context),
                      onExit: (_) => _hideRecommendationOverlay(),
                      child: Icon(Icons.info_outline, color: Colors.blue[200], size: 20),
                    ),
                  ],
                ),
              ],
            ),
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

  Widget _heartBar(String label, double value, double max, Color color) {
    double percent = (max > 0) ? (value / max).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
        SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (percent > 0)
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 2),
        Text('${value.toStringAsFixed(1)} / ${max.toStringAsFixed(1)}', style: TextStyle(color: Colors.white70, fontSize: 12)),
        SizedBox(height: 8),
      ],
    );
  }

  void _showRecommendationOverlay(BuildContext context) {}

  void _hideRecommendationOverlay() {}

  Widget _buildModernMacroCircle(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
