import 'package:flutter/material.dart';
import '../registroalimentos/registroalimentos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/models/alimneto_model.dart';
import '../../../data/services/ingesta_service.dart';
import '../../../data/services/alimentos_service.dart';
import '../../modificaringesta/modificaringesta.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  int _currentIndex = 1;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  final IngestaService _ingestaService = IngestaService();
  final AlimentoService _alimentoService = AlimentoService();

  Map<String, List<Map<String, dynamic>>> _meals = {
    'Desayuno': [],
    'Almuerzo': [],
    'Cena': [],
    'Aperitivos': [],
  };

  int _getTotalCalories() {
    int total = 0;
    _meals.forEach((key, mealItems) {
      for (var item in mealItems) {
        if (item.containsKey('calories') && item['calories'] is int) {
          total += item['calories'] as int;
        } else {
        }
      }
    });
    return total;
  }

  Future<void> _saveCaloriesToPrefs(int calories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('_saveCaloriesToPrefs: Saving $calories to today_calories_consumed');
    await prefs.setInt('today_calories_consumed', calories);
  }

  @override
  void initState() {
    super.initState();
    _cargarDatosDelDiario();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Future<void> _cargarDatosDelDiario() async {
    if (!mounted) return;
    print(' _cargarDatosDelDiario:  _selectedDate: $_selectedDate');
    final bool isSelectedDateToday = _isToday(_selectedDate);
    print('_cargarDatosDelDiario: isSelectedDateToday: $isSelectedDateToday');

    setState(() {
      _isLoading = true;
      _meals = {
        'Desayuno': [],
        'Almuerzo': [],
        'Cena': [],
        'Aperitivos': [],
      };
    });

    try {
      final List<Alimento> todosLosAlimentos = await _alimentoService.getAllAlimentos();
      final Map<int, Alimento> mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };

      print(' _cargarDatosDelDiario: Fetching ingestas del usuario...');
      final List<Ingesta> ingestasDelUsuario = await _ingestaService.obtenerIngestasDelUsuario();
      print('_cargarDatosDelDiario: Fetched ${ingestasDelUsuario.length} total ingestas for user.');

      for (var ingesta in ingestasDelUsuario) {
        DateTime fechaIngesta;
        try {
          fechaIngesta = DateTime.parse(ingesta.fechaConsumo);
        } catch (e) {
          continue;
        }

        if (fechaIngesta.year != _selectedDate.year ||
            fechaIngesta.month != _selectedDate.month ||
            fechaIngesta.day != _selectedDate.day) {
            continue;
        }

        final Alimento? alimentoBase = mapaAlimentos[ingesta.alimentoId];

        if (alimentoBase != null) {
          final mealMap = {
            'name': alimentoBase.nombre,
            'details': 'Cantidad: ${ingesta.cantidad} Gramos',
            'calories': (alimentoBase.calorias * ingesta.cantidad / 100).round(),
            '_originalIngesta': ingesta,
          };

          if (_meals.containsKey(ingesta.tipoIngesta)) {
            _meals[ingesta.tipoIngesta]?.add(mealMap);
          } else {
          }
        }
      }

      final int currentTotalCaloriesForSelectedDate = _getTotalCalories();

      if (isSelectedDateToday) {
        _saveCaloriesToPrefs(currentTotalCaloriesForSelectedDate);
      } else {
      }
    } catch (e) {
      print(" Error cargando datos: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = const Color(0xFF5A99D6).withOpacity(0.2);
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color textColor = Colors.white;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                  _cargarDatosDelDiario();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 24),
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
              Text(
                '${_getTotalCalories()}',
                style: TextStyle(color: textColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Calorías - Alimentos',
                style: TextStyle(
                    color: textColor.withOpacity(0.7), fontSize: 16),
              ),
              const SizedBox(height: 24),
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
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex && index != 2) return;

          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, '/agregarAlimento');
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
      if (mounted) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _buildMealCard(String mealType,
      List<Map<String, dynamic>> items,
      Color cardBackgroundColor,
      Color textColor,) {
    int totalCalories = items.fold(
        0, (sum, item) => sum + (item.containsKey('calories') && item['calories'] is int ? item['calories'] as int : 0));

    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mealType,
                  style: TextStyle(color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$totalCalories Cal",
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 16),

            ...items.map((itemMap) =>
                _buildFoodItem(
                  mealType,
                  itemMap,
                  textColor,
                )).toList(),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/registralimentos',
                    arguments: {'mealType': mealType},
                  );
                  if (result != null) {
                      _cargarDatosDelDiario();
                  }
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text('Agregar alimento',
                  style: TextStyle(color: Colors.blueAccent.shade100)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(
    String mealType,
    Map<String, dynamic> foodItemMap,
    Color textColor
  ) {
    final Ingesta originalIngesta = foodItemMap['_originalIngesta'] as Ingesta;
    final String name = foodItemMap['name']?.toString() ?? 'Nombre no disponible';
    final String details = foodItemMap['details']?.toString() ?? 'Detalles no disponibles';
    final String calories = "${foodItemMap['calories']?.toString() ?? '0'} Cal";

    return Dismissible(
      key: ObjectKey(originalIngesta),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return true;
      },
      onDismissed: (direction) async {
        if (originalIngesta.id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: No se pudo identificar la ingesta para eliminarla del servidor."))
          );
          return;
        }

        bool deletedSuccessfully = await _ingestaService.eliminarIngesta(originalIngesta.id!);

        if (deletedSuccessfully) {
          if (mounted) {
            setState(() {
              _meals[mealType]?.removeWhere((map) => map['_originalIngesta'] == originalIngesta);
              if (_isToday(_selectedDate)) {
                _saveCaloriesToPrefs(_getTotalCalories());
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$name eliminado correctamente."))
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al eliminar $name del servidor. Inténtalo de nuevo."))
            );
          }
        }
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () async {
          final Alimento? alimento = await _alimentoService.getAlimentoById(originalIngesta.alimentoId);

          if (alimento != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModificarIngestaPage(
                  ingesta: originalIngesta,
                  alimento: alimento,
                ),
              ),
            );
            if (result == true) {
              _cargarDatosDelDiario();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo cargar el alimento para editar.')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(color: textColor, fontSize: 14)),
                    Text(details, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(calories, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
