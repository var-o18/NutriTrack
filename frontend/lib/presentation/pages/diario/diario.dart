import 'package:flutter/material.dart';
import '../registroalimentos/registroalimentos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/models/alimneto_model.dart';
import '../../../data/services/ingesta_service.dart';
import '../../../data/services/alimentos_service.dart';

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
            'details': 'Cantidad: ${ingesta.cantidad}',
            'calories': (alimentoBase.calorias * ingesta.cantidad).round(),
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
                break;
              case 2:
                Navigator.pushNamed(context, '/agregarAlimento');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/descubre');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/ajustes');
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
          final TextEditingController quantityController = TextEditingController(
            text: originalIngesta.cantidad.toString()
          );
          
          final result = await showDialog<double>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF1E1E1E),
                title: Text(
                  'Modificar cantidad',
                  style: TextStyle(color: textColor),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xFF5A99D6)),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final newQuantity = double.tryParse(quantityController.text);
                      if (newQuantity != null && newQuantity > 0) {
                        Navigator.of(context).pop(newQuantity);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor ingrese una cantidad válida')),
                        );
                      }
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Color(0xFF5A99D6)),
                    ),
                  ),
                ],
              );
            },
          );

          if (result != null && result != originalIngesta.cantidad) {
            try {
              final updatedIngesta = Ingesta(
                id: originalIngesta.id,
                alimentoId: originalIngesta.alimentoId,
                cantidad: result.toInt(),
                fechaConsumo: originalIngesta.fechaConsumo,
                tipoIngesta: originalIngesta.tipoIngesta,
                usuarioId: originalIngesta.usuarioId,
                horaConsumo: originalIngesta.horaConsumo,
              );

              final success = await _ingestaService.actualizarIngesta(updatedIngesta);
              
              if (success) {
                if (mounted) {
                  _cargarDatosDelDiario();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cantidad actualizada correctamente')),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al actualizar la cantidad')),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
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
