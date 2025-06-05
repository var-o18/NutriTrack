import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/registroalimentos/lector_codigo_barras.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/alimneto_model.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/services/alimentos_service.dart';
import '../../../data/services/ingesta_service.dart';
import 'agregar_alimento.dart';
import 'escaneo_rapido.dart';

class RegistroAlimentosPage extends StatefulWidget {
  final String mealType;
  const RegistroAlimentosPage({super.key, required this.mealType});

  @override
  State<RegistroAlimentosPage> createState() => _RegistroAlimentosPageState();
}

class _RegistroAlimentosPageState extends State<RegistroAlimentosPage> {
  int _currentIndex = 1;
  late String selectedMeal;
  final List<String> mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];

  final AlimentoService alimentoService = AlimentoService();
  final IngestaService ingestaService = IngestaService();

  List<Alimento> _alimentos = [];
  List<Alimento> _alimentosFiltrados = [];
  bool _isLoading = true;
  int? _usuarioId;
  List<Alimento> _alimentosSeleccionados = [];
  List<Alimento> _historialUnico = [];
  int _sugerenciasVisiblesCount = 3;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (mealTypes.contains(widget.mealType)) {
      selectedMeal = widget.mealType;
    } else {
      selectedMeal = 'Almuerzo';
      assert(() {
        return true;
      }());
    }
    _initializeData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterAlimentos();
    });
  }

  void _filterAlimentos() {
    if (_searchQuery.isEmpty) {
      _alimentosFiltrados = List.from(_alimentos);
    } else {
      _alimentosFiltrados = _alimentos
          .where((alimento) =>
              alimento.nombre.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    _sugerenciasVisiblesCount = 3;
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('jwt_id');

    if (id != null) {
      setState(() {
        _usuarioId = id;
      });
    } else {
      print('_usuarioId is null');
    }

    final alimentos = await alimentoService.getAllAlimentos();
    print('Total alimentos fetched: ${alimentos.length}');
    setState(() {
      _alimentos = alimentos;
      _alimentosFiltrados = alimentos;
      _isLoading = false;
    });

    if (id != null) {
      final ingestas = await ingestaService.obtenerIngestasDelUsuario();
      print('Ingestas fetched for user $id: ${ingestas.length}');
      ingestas.sort((a, b) {
        final dateComparison = b.fechaConsumo.compareTo(a.fechaConsumo);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return b.horaConsumo.compareTo(a.horaConsumo);
      });

      final List<int> alimentoIdsUnicosOrdenados = ingestas
          .map((i) => i.alimentoId)
          .toSet()
          .toList();

      print('Unique alimento IDs from sorted ingestas: $alimentoIdsUnicosOrdenados');

      final Map<int, Alimento> alimentosMap = {for (var a in _alimentos) a.id!: a};

      final List<Alimento> historialTemp = [];
      final Set<int> addedAlimentoIds = {};

      for (final ingesta in ingestas) {
        if (historialTemp.length >= 3) break;

        if (!addedAlimentoIds.contains(ingesta.alimentoId)) {
          final alimento = alimentosMap[ingesta.alimentoId];
          if (alimento != null) {
            historialTemp.add(alimento);
            addedAlimentoIds.add(ingesta.alimentoId);
          }
        }
      }

      print('Historial (filtered alimentos, top 3 recent unique) count: ${historialTemp.length}');

      setState(() {
        _historialUnico = historialTemp;
      });
    } else {
      print('Skipping ingestas fetch and _historialUnico population because user ID is null.');
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
        cantidad: 1,
        fechaConsumo: fecha,
        horaConsumo: hora,
        tipoIngesta: selectedMeal,
      );
      bool success = await ingestaService.registrarIngesta(ingesta);
      if (success) {
        successCount++;
      } else {
        failureCount++;
      }
    }

    String mensajeFinal;
    if (successCount > 0 && failureCount == 0) {
      mensajeFinal = '$successCount ingesta(s) guardada(s) exitosamente.';
    } else if (successCount > 0 && failureCount > 0) {
      mensajeFinal = '$successCount ingesta(s) guardada(s), $failureCount fallaron.';
    } else if (failureCount > 0) {
      mensajeFinal = 'Falló el registro de todas las ingestas. Revise la consola.';
    } else {
      mensajeFinal = 'No se procesaron ingestas.';
    }
    _mostrarMensaje(mensajeFinal);

    if (successCount > 0) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        setState(() {
          _alimentosSeleccionados.clear();
          _initializeData();
        });
      }
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Buscar alimentos...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.search, color: textColor),
                  filled: true,
                  fillColor: cardBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: textColor),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            _buildAcciones(cardBackgroundColor, textColor),
            const SizedBox(height: 20),
            _buildSection('Historial', _historialUnico, cardBackgroundColor, textColor),
            const SizedBox(height: 20),
            _buildSugerenciasSection('Sugerencias', _alimentosFiltrados, cardBackgroundColor, textColor),
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
          _buildActionButton(
            Icons.qr_code_scanner,
            'Leer código\nde barras',
            () async {
              final String? barcode = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => const LectorCodigoBarrasPage()),
              );

              if (barcode != null && barcode.isNotEmpty) {
                print('Scanned barcode: $barcode');
                _mostrarMensaje('Código escaneado: $barcode. Implementar búsqueda.');
              } else {
                print('Barcode scanning cancelled or no barcode returned.');
              }
            },
            bgColor,
            textColor
          ),
          _buildActionButton(Icons.add_circle_outline, 'Agregar\nNuevo', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AgregarAlimentoPage()),
            );

          }, bgColor, textColor),
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

  Widget _buildSugerenciasSection(String title, List<Alimento> alimentosSugeridos, Color bgColor, Color textColor) {
    final int itemsToShow = _sugerenciasVisiblesCount.clamp(0, alimentosSugeridos.length);
    final List<Alimento> alimentosMostrados = alimentosSugeridos.take(itemsToShow).toList();
    final bool hasMore = itemsToShow < alimentosSugeridos.length;

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
                    _sugerenciasVisiblesCount = (_sugerenciasVisiblesCount + 3).clamp(0, alimentosSugeridos.length);
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
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 4),
                    Text('${alimento.calorias.toStringAsFixed(0)} calorías',
                        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                    ),
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
            if (index == _currentIndex && index != 2) return;

            if (index == 2 && ModalRoute.of(context)?.settings.name == '/registralimentos' ){

            } else {
                 setState(() {
                    _currentIndex = index;
                 });
            }

            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/dashboard');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/diario');
                break;
              case 2:
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
              icon: Container(width: 40, height: 40, child: Image.asset('assets/images/anadiralimento.png', width: 24)),
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
}
