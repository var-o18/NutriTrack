import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/registroalimentos/lector_codigo_barras.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutritack/presentation/pages/seccionComidas/seccionComidas.dart';

import '../../../data/models/alimneto_model.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/services/alimentos_service.dart';
import '../../../data/services/ingesta_service.dart';
import '../../../utils/quick_actions.dart';
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

  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Mis Alimentos', 'Mis Comidas', 'Mis Recetas'];

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
            if (_selectedTabIndex == 0)
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
            _buildTabContent(_selectedTabIndex, textColor, cardBackgroundColor),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          children: List.generate(_tabs.length, (index) {
            final bool selected = _selectedTabIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedTabIndex = index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selected ? textColor : textColor.withOpacity(0.5),
                        decoration: selected ? TextDecoration.underline : null,
                      ),
                    ),
                    if (selected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 3,
                        width: 40,
                        color: textColor,
                      )
                    else
                      const SizedBox(height: 7),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, Color textColor, Color cardBackgroundColor) {
    switch (tabIndex) {
      case 0:
        return Column(
          children: [
            _buildAcciones(cardBackgroundColor, textColor),
            const SizedBox(height: 20),
            _buildSection('Historial', _historialUnico, cardBackgroundColor, textColor),
            const SizedBox(height: 20),
            _buildSugerenciasSection('Sugerencias', _alimentosFiltrados, cardBackgroundColor, textColor),
            const SizedBox(height: 80),
          ],
        );
      case 1:
        return SizedBox(
          height: 500,
          child: SeccionComidasPage(),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text('Aquí irán tus recetas', style: TextStyle(color: textColor, fontSize: 18)),
          ),
        );
      default:
        return Container();
    }
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
        width: MediaQuery.of(context).size.width * 0.4,
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
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EscaneoRapidoPage(scannedAlimento: alimento),
                  ),
                );
                // Opcional: refrescar datos después de añadir
                _initializeData();
              },
              child: _buildAlimentoCard(
                alimento,
                bgColor,
                textColor,
                isSelected: false,
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
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.14,
                height: MediaQuery.of(context).size.width * 0.14,
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
              // Ya no hay icono de selección
            ],
          ),
        ),
      ),
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
