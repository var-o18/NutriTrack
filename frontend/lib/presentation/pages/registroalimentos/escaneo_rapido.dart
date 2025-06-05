import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fecha y hora
import 'package:shared_preferences/shared_preferences.dart'; // Para obtener usuarioId
import '../../../data/models/alimneto_model.dart';
import '../../../data/models/ingesta_model.dart';
import '../../../data/services/alimentos_service.dart';
import '../../../data/services/ingesta_service.dart';
import 'lector_codigo_barras.dart';

class EscaneoRapidoPage extends StatefulWidget {
  final Alimento? scannedAlimento;

  const EscaneoRapidoPage({super.key, this.scannedAlimento});

  @override
  State<EscaneoRapidoPage> createState() => _EscaneoRapidoPageState();
}

class _EscaneoRapidoPageState extends State<EscaneoRapidoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tamanoRacionController = TextEditingController(text: '100');
  final TextEditingController _unidadRacionController = TextEditingController(text: 'gr');
  final TextEditingController _numeroRacionesController = TextEditingController(text: '1');
  final TextEditingController _caloriasController = TextEditingController(text: '0');
  final TextEditingController _carbohidratosController = TextEditingController(text: '0');
  final TextEditingController _grasaController = TextEditingController(text: '0');
  final TextEditingController _proteinaController = TextEditingController(text: '0');
  String _tipoComida = 'Desayuno';
  final List<String> _tiposComida = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];

  final AlimentoService _alimentoService = AlimentoService();
  final IngestaService _ingestaService = IngestaService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.scannedAlimento != null) {
      _prefillData(widget.scannedAlimento!);
    }
  }

  void _prefillData(Alimento alimento) {
    _nombreController.text = alimento.nombre;
    _tamanoRacionController.text = '100';
    _unidadRacionController.text = 'gr';
    _numeroRacionesController.text = '1';

    _caloriasController.text = alimento.calorias.toStringAsFixed(0);
    _carbohidratosController.text = alimento.carbohidratos.toStringAsFixed(1);
    _grasaController.text = alimento.grasas.toStringAsFixed(1);
    _proteinaController.text = alimento.proteinas.toStringAsFixed(1);

    print('Ingredientes: ${alimento.ingredientes ?? 'No disponible'}');
    print('Código de barras: ${alimento.codigoBarras ?? 'No disponible'}');
  }

  Future<void> _onAgregarAlimentoPressed() async {
    setState(() => _isLoading = true);

    Alimento? alimentoParaIngesta = widget.scannedAlimento;
    String nombreAlimento = _nombreController.text.trim();
    double calorias = double.tryParse(_caloriasController.text) ?? 0;
    double proteinas = double.tryParse(_proteinaController.text) ?? 0;
    double carbohidratos = double.tryParse(_carbohidratosController.text) ?? 0;
    double grasas = double.tryParse(_grasaController.text) ?? 0;

    if (nombreAlimento.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El nombre del alimento es obligatorio.')));
      setState(() => _isLoading = false);
      return;
    }

    Alimento currentAlimentoData = Alimento(
      id: alimentoParaIngesta?.id,
      nombre: nombreAlimento,
      calorias: calorias,
      proteinas: proteinas,
      carbohidratos: carbohidratos,
      grasas: grasas,
      codigoBarras: alimentoParaIngesta?.codigoBarras,
      ingredientes: alimentoParaIngesta?.ingredientes,
    );

    if (alimentoParaIngesta == null || alimentoParaIngesta.id == null) {
      Alimento? savedAlimento = await _alimentoService.saveAlimento(currentAlimentoData);
      if (savedAlimento != null) {
        alimentoParaIngesta = savedAlimento;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar el alimento en la base de datos.')));
        setState(() => _isLoading = false);
        return;
      }
    } else {
      alimentoParaIngesta = currentAlimentoData;
    }

    if (alimentoParaIngesta == null || alimentoParaIngesta.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo procesar el alimento para la ingesta.')));
      setState(() => _isLoading = false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final int? usuarioId = prefs.getInt('jwt_id');
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: No se pudo obtener el ID del usuario.')));
      setState(() => _isLoading = false);
      return;
    }

    double tamanoRacionNum = double.tryParse(_tamanoRacionController.text) ?? 100.0;
    double numRacionesNum = double.tryParse(_numeroRacionesController.text) ?? 1.0;
    int cantidadTotalGramos = (tamanoRacionNum * numRacionesNum).toInt();

    final now = DateTime.now();
    final String fechaConsumo = DateFormat('yyyy-MM-dd').format(now);
    final String horaConsumo = DateFormat('HH:mm:ss').format(now);

    Ingesta nuevaIngesta = Ingesta(
      usuarioId: usuarioId,
      alimentoId: alimentoParaIngesta.id!,
      cantidad: cantidadTotalGramos,
      fechaConsumo: fechaConsumo,
      horaConsumo: horaConsumo,
      tipoIngesta: _tipoComida,
    );

    bool ingestaRegistrada = await _ingestaService.registrarIngesta(nuevaIngesta);

    setState(() => _isLoading = false);

    if (ingestaRegistrada) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alimento e ingesta agregados exitosamente!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al registrar la ingesta.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF2A2A2A);
    final Color accentColor = const Color(0xFF5A99D6);
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LectorCodigoBarrasPage(),
              ),
            );
          },
        ),
        title: Text('Escaneo Rápido', 
          style: TextStyle(color: textColor, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nombreController,
                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Nombre del alimento',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 24),

              _buildInputField(
                'Tamaño de la ración',
                _tamanoRacionController,
                textColor,
                cardColor,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Número de raciones',
                _numeroRacionesController,
                textColor,
                cardColor,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                'Tipo de comida',
                _tipoComida,
                _tiposComida,
                textColor,
                cardColor,
                (String? newValue) {
                  if (newValue != null) {
                    setState(() => _tipoComida = newValue);
                  }
                },
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEditableNutritionCircle(_caloriasController, 'Cal', 'Calorías', accentColor, textColor),
                  _buildEditableNutritionCircle(_carbohidratosController, 'g', 'Carbohidratos', accentColor, textColor),
                  _buildEditableNutritionCircle(_grasaController, 'g', 'Grasa', accentColor, textColor),
                  _buildEditableNutritionCircle(_proteinaController, 'g', 'Proteína', accentColor, textColor),
                ],
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _onAgregarAlimentoPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)) 
                    : Text(
                  'Agregar Alimento',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    Color textColor,
    Color backgroundColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    Color textColor,
    Color backgroundColor,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: backgroundColor,
              style: TextStyle(color: textColor, fontSize: 16),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableNutritionCircle(
    TextEditingController controller,
    String unit,
    String label,
    Color accentColor,
    Color textColor,
  ) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tamanoRacionController.dispose();
    _unidadRacionController.dispose();
    _numeroRacionesController.dispose();
    _caloriasController.dispose();
    _carbohidratosController.dispose();
    _grasaController.dispose();
    _proteinaController.dispose();
    super.dispose();
  }
} 