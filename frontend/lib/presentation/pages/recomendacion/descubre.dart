import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/services/alimentos_service.dart';
import '../../../data/services/login_service.dart';
import '../../../data/services/ingesta_service.dart';
import '../../../data/models/registro_model.dart';
import '../../../data/models/alimneto_model.dart';
import '../../../utils/quick_actions.dart';
import '../registroalimentos/escaneo_rapido.dart';

class DescubrePage extends StatefulWidget {
  const DescubrePage({super.key});

  @override
  State<DescubrePage> createState() => _DescubrePageState();
}

class _DescubrePageState extends State<DescubrePage> {
  int _currentIndex = 3;
  DateTime selectedDate = DateTime.now();
  bool _showTitle = false;
  bool _isLoading = true;
  RegistroModel? _usuario;
  List<Alimento> _sugerencias = [];
  Map<String, dynamic> _resumenDiario = {};
  final AlimentoService _alimentoService = AlimentoService();
  final IngestaService _ingestaService = IngestaService();

  Color get cardColor => const Color(0x4D5A99D6);
  Color get accentColor => const Color(0xFF5A99D6);
  Color get backgroundColor => const Color(0xFF1E1E1E);

  String get formattedDate => DateFormat('d MMM').format(selectedDate);

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      // Obtener datos del usuario
      final usuario = await getDatosUsuario();
      if (usuario != null) {
        setState(() => _usuario = usuario);
      }

      // Obtener resumen diario
      final resumen = await _ingestaService.getResumenDiario();
      setState(() => _resumenDiario = resumen);

      // Obtener sugerencias de alimentos
      final sugerencias = await _alimentoService.getSugerencias(5, 0.1);
      setState(() => _sugerencias = sugerencias);
    } catch (e) {
      print('Error al cargar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los datos')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                _handleScroll(scrollInfo);
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: backgroundColor,
                    expandedHeight: 280.0,
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
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/descubre_bg.jpg',
                              fit: BoxFit.cover,
                              colorBlendMode: BlendMode.darken,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    backgroundColor,
                                  ],
                                  stops: const [0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
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

  Widget _buildNutritionSummary() {
    if (_usuario == null || _resumenDiario.isEmpty) return const SizedBox.shrink();

    final caloriasConsumidas = _resumenDiario['caloriasConsumidas'] ?? 0;
    final caloriasRestantes = (_usuario!.caloriasDiarias ?? 0) - caloriasConsumidas;
    final carbohidratosConsumidos = _resumenDiario['carbohidratosConsumidos'] ?? 0;
    final proteinasConsumidas = _resumenDiario['proteinasConsumidas'] ?? 0;
    final grasasConsumidas = _resumenDiario['grasasConsumidas'] ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 125,
                      height: 130,
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
                          caloriasRestantes.round().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Restantes',
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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNutrientBar(
                      'Carbs',
                      carbohidratosConsumidos,
                      250.0,
                      accentColor,
                    ),
                    const SizedBox(height: 8),
                    _buildNutrientBar(
                      'Proteínas',
                      proteinasConsumidas,
                      75.0,
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildNutrientBar(
                      'Grasas',
                      grasasConsumidas,
                      65.0,
                      Colors.orange,
                    ),
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
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Text(
              '${value.toInt()}/${goal.toInt()}g',
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
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
    if (_usuario == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Actual',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _usuario!.objetivoPersonal ?? 'Sin objetivo definido',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Objetivo personal',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
    if (_sugerencias.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Recomendaciones para ti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sugerencias.length,
          itemBuilder: (context, index) {
            final alimento = _sugerencias[index];
            return Padding(
              key: ValueKey(alimento.id ?? 'sug_${index}'),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alimento.nombre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${alimento.calorias} kcal',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: GestureDetector(
                          key: ValueKey(alimento.id ?? 'gesture_sug_${index}'),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EscaneoRapidoPage(
                                  scannedAlimento: alimento,
                                ),
                              ),
                            );
                            if (result == true) {
                              _cargarDatos();
                            }
                          },
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
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
