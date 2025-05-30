import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/alimneto_model.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/services/alimentos_service.dart';
import '../../../data/services/ingesta_service.dart';

class RegistroAlimentosPage extends StatefulWidget {
  final String mealType;
  const RegistroAlimentosPage({super.key, required this.mealType});

  @override
  State<RegistroAlimentosPage> createState() => _RegistroAlimentosPageState();
}

class _RegistroAlimentosPageState extends State<RegistroAlimentosPage> {
  int _currentIndex = 0;
  late String selectedMeal;
  final List<String> mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];

  final AlimentoService alimentoService = AlimentoService();
  final IngestaService ingestaService = IngestaService();

  List<Alimento> _alimentos = [];
  bool _isLoading = true;
  int? _usuarioId;
  List<Alimento> _alimentosSeleccionados = [];
  List<Alimento> _historialUnico = [];
  int _sugerenciasVisiblesCount = 3;

  @override
  void initState() {
    super.initState();
    if (mealTypes.contains(widget.mealType)) {
      selectedMeal = widget.mealType;
    } else {
      selectedMeal = 'Almuerzo';
      assert(() {
        print('[WARN] Invalid mealType \'${widget.mealType}\' passed to RegistroAlimentosPage. Defaulting to \'Almuerzo\'.');
        return true;
      }());
    }
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('jwt_id');
    print('[DEBUG] User ID from SharedPreferences (jwt_id): $id');

    if (id != null) {
      setState(() {
        _usuarioId = id;
      });
    } else {
      print('[DEBUG] _usuarioId is null. History will likely be empty.');
    }

    final alimentos = await alimentoService.getAllAlimentos();
    print('[DEBUG] Total alimentos fetched: ${alimentos.length}');
    setState(() {
      _alimentos = alimentos;
      _isLoading = false;
    });

    if (id != null) {
      final ingestas = await ingestaService.obtenerIngestasDelUsuario();
      print('[DEBUG] Ingestas fetched for user $id: ${ingestas.length}');

      // Sort ingestas by fechaConsumo and horaConsumo in descending order
      ingestas.sort((a, b) {
        final dateComparison = b.fechaConsumo.compareTo(a.fechaConsumo);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return b.horaConsumo.compareTo(a.horaConsumo);
      });

      // Get unique alimento_ids from the sorted ingestas
      final List<int> alimentoIdsUnicosOrdenados = ingestas
          .map((i) => i.alimentoId)
          .toSet() // To get unique IDs
          .toList(); // Convert back to list, order from Set is not guaranteed, but we will map back to sorted ingestas

      print('[DEBUG] Unique alimento IDs from sorted ingestas: $alimentoIdsUnicosOrdenados');

      // Create a map of Alimento objects for quick lookup
      final Map<int, Alimento> alimentosMap = {for (var a in _alimentos) a.id!: a};

      // Build the unique history, maintaining recency and limiting to top 3
      final List<Alimento> historialTemp = [];
      final Set<int> addedAlimentoIds = {}; // To ensure we only add unique alimentos

      for (final ingesta in ingestas) {
        if (historialTemp.length >= 3) break; // Stop if we have 3 items

        if (!addedAlimentoIds.contains(ingesta.alimentoId)) {
          final alimento = alimentosMap[ingesta.alimentoId];
          if (alimento != null) {
            historialTemp.add(alimento);
            addedAlimentoIds.add(ingesta.alimentoId);
          }
        }
      }

      print('[DEBUG] Historial (filtered alimentos, top 3 recent unique) count: ${historialTemp.length}');

      setState(() {
        _historialUnico = historialTemp;
      });
    } else {
      print('[DEBUG] Skipping ingestas fetch and _historialUnico population because user ID is null.');
    }
  }

  void _guardarIngestas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('jwt_id');

    if (_alimentosSeleccionados.isEmpty) {
      _mostrarMensaje('No hay alimentos seleccionados para guardar.');
      return;
    }

    if (id == null) {
      _mostrarMensaje('Usuario no autenticado. No se pueden guardar las ingestas.');
      return;
    }

    final now = DateTime.now();
    final fecha = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final hora = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    int successCount = 0;
    int failureCount = 0;

    for (final alimento in _alimentosSeleccionados) {
      final ingesta = Ingesta(
        usuarioId: id,
        alimentoId: alimento.id!,
        cantidad: 1, // Asumiendo cantidad 1, ajustar si necesario
        fechaConsumo: fecha,
        horaConsumo: hora,
      );
      bool success = await ingestaService.registrarIngesta(ingesta);
      if (success) {
        successCount++;
      } else {
        failureCount++;
        print('[ERROR] _guardarIngestas: Falló el registro para el alimento: ${alimento.nombre}');
      }
    }

    if (successCount > 0 && failureCount == 0) {
      _mostrarMensaje('$successCount ingesta(s) guardada(s) exitosamente.');
    } else if (successCount > 0 && failureCount > 0) {
      _mostrarMensaje('$successCount ingesta(s) guardada(s), $failureCount fallaron.');
    } else if (failureCount > 0) {
      _mostrarMensaje('Falló el registro de todas las ingestas. Revise la consola.');
    } else { // Should not happen if _alimentosSeleccionados was not empty
      _mostrarMensaje('No se procesaron ingestas.');
    }

    if (successCount > 0) {
      setState(() {
        _alimentosSeleccionados.clear();
        // Consider re-fetching history or updating UI as needed
        _initializeData(); // Re-fetch data to update history and suggestions
      });
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color textColor = const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: _buildMealDropdown(textColor),
        actions: [IconButton(icon: Icon(Icons.more_vert, color: textColor), onPressed: () {})],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            _buildTabs(textColor),
            _buildAcciones(cardBackgroundColor, textColor),
            const SizedBox(height: 20),
            _buildSection('Historial', _historialUnico, cardBackgroundColor, textColor),
            const SizedBox(height: 20),
            _buildSugerenciasSection('Sugerencias', _alimentos, cardBackgroundColor, textColor),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _guardarIngestas,
        backgroundColor: const Color(0xFF5A99D6),
        label: Text('Guardar'),
        icon: Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildMealDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedMeal,
      dropdownColor: const Color(0xFF1E1E1E),
      style: TextStyle(color: textColor, fontSize: 20),
      icon: Icon(Icons.arrow_drop_down, color: textColor),
      underline: Container(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() => selectedMeal = newValue);
        }
      },
      items: mealTypes.map((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }

  Widget _buildTabs(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['Mis Comidas', 'Mis Recetas', 'Mis Alimentos']
              .map((tab) => _buildTab(tab, textColor))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
    );
  }

  Widget _buildAcciones(Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.qr_code_scanner, 'Leer código\nde barras', () {}, bgColor, textColor),
          _buildActionButton(Icons.add_circle_outline, 'Agregar\nNuevo', () {}, bgColor, textColor),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onTap, Color backgroundColor, Color textColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, size: 32, color: textColor),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Alimento> alimentos, Color bgColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, textColor),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: alimentos.length,
          itemBuilder: (_, index) => _buildAlimentoCard(alimentos[index], bgColor, textColor),
        ),
      ],
    );
  }

  Widget _buildSugerenciasSection(String title, List<Alimento> alimentos, Color bgColor, Color textColor) {
    final int itemsToShow = _sugerenciasVisiblesCount.clamp(0, alimentos.length);
    final List<Alimento> alimentosMostrados = alimentos.take(itemsToShow).toList();
    final bool hasMore = itemsToShow < alimentos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, textColor),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alimentosMostrados.length,
          itemBuilder: (_, index) {
            final alimento = alimentosMostrados[index];
            final isSelected = _alimentosSeleccionados.contains(alimento);
            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected ? _alimentosSeleccionados.remove(alimento) : _alimentosSeleccionados.add(alimento);
                });
              },
              child: _buildAlimentoCard(
                alimento,
                isSelected ? bgColor.withOpacity(0.9) : bgColor,
                textColor,
                isSelected: isSelected,
              ),
            );
          },
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A99D6),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _sugerenciasVisiblesCount = (_sugerenciasVisiblesCount + 3).clamp(0, alimentos.length);
                  });
                },
                child: const Text('Ver más'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          TextButton(onPressed: () {}, child: Text('Ver recientes', style: TextStyle(color: textColor))),
        ],
      ),
    );
  }

  Widget _buildAlimentoCard(Alimento alimento, Color bgColor, Color textColor, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.fastfood, color: textColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(alimento.nombre,
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('${alimento.calorias.toStringAsFixed(0)} calorías',
                        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)),
                  ],
                ),
              ),
              Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline,
                  color: isSelected ? Colors.greenAccent : textColor),
            ],
          ),
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
            setState(() => _currentIndex = index);
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
                Navigator.pushReplacementNamed(context, '/mas');
                break;
            }
          },
          items: [
            _buildBarItem('inicio.png', "Inicio", 0),
            _buildBarItem('diario.png', "Diario", 1),
            BottomNavigationBarItem(
              icon: Container(width: 40, height: 40, child: Image.asset('assets/images/anadiralimento.png', width: 24)),
              label: "",
            ),
            _buildBarItem('progreso.png', "Control", 3),
            _buildBarItem('opcionmas.png', "Más", 4),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem(String assetName, String label, int index) {
    final bool isActive = index == _currentIndex;
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/$assetName',
            width: 24,
            color: isActive ? const Color(0xFF80C0FF) : Colors.grey,
          ),
          isActive
              ? Container(width: 24, height: 3, color: const Color(0xFF5A99D6), margin: const EdgeInsets.only(top: 4))
              : const SizedBox(height: 7),
        ],
      ),
      label: label,
    );
  }
}
