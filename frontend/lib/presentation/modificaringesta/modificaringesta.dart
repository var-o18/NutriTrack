import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/alimneto_model.dart';
import '../../data/models/ingesta_model.dart';
import '../../data/services/ingesta_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModificarIngestaPage extends StatefulWidget {
  final Ingesta ingesta;
  final Alimento alimento;

  const ModificarIngestaPage({Key? key, required this.ingesta, required this.alimento}) : super(key: key);

  @override
  State<ModificarIngestaPage> createState() => _ModificarIngestaPageState();
}

class _ModificarIngestaPageState extends State<ModificarIngestaPage> {
  late TextEditingController _tamanoRacionController;
  late TextEditingController _caloriasController;
  late TextEditingController _carbohidratosController;
  late TextEditingController _grasaController;
  late TextEditingController _proteinaController;
  String _tipoComida = 'Desayuno';
  final List<String> _tiposComida = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('Ingesta recibida en ModificarIngestaPage: \\n${jsonEncode(widget.ingesta.toMap())}');
    _tamanoRacionController = TextEditingController(text: widget.ingesta.cantidad.toString());
    _tipoComida = widget.ingesta.tipoIngesta;
    _caloriasController = TextEditingController();
    _carbohidratosController = TextEditingController();
    _grasaController = TextEditingController();
    _proteinaController = TextEditingController();
    _actualizarValoresNutricionales();
  }

  void _actualizarValoresNutricionales() {
    double tamanoRacion = double.tryParse(_tamanoRacionController.text) ?? 100.0;
    double factor = tamanoRacion / 100.0;
    setState(() {
      _caloriasController.text = (widget.alimento.calorias * factor).toStringAsFixed(0);
      _carbohidratosController.text = (widget.alimento.carbohidratos * factor).toStringAsFixed(1);
      _grasaController.text = (widget.alimento.grasas * factor).toStringAsFixed(1);
      _proteinaController.text = (widget.alimento.proteinas * factor).toStringAsFixed(1);
    });
  }

  Future<void> _onGuardarCambiosPressed() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final int? usuarioId = prefs.getInt('jwt_id');
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: No se pudo obtener el ID del usuario.')));
      setState(() => _isLoading = false);
      return;
    }
    int cantidad = int.tryParse(_tamanoRacionController.text) ?? 100;
    final String fechaConsumo = widget.ingesta.fechaConsumo;
    final String horaConsumo = widget.ingesta.horaConsumo;
    Ingesta updatedIngesta = Ingesta(
      id: widget.ingesta.id,
      usuarioId: usuarioId,
      alimentoId: widget.alimento.id!,
      cantidad: cantidad,
      fechaConsumo: fechaConsumo,
      horaConsumo: horaConsumo,
      tipoIngesta: _tipoComida,
    );
    final success = await IngestaService().actualizarIngesta(updatedIngesta);
    setState(() => _isLoading = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingesta actualizada correctamente.')));
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al actualizar la ingesta.')));
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Modificar Ingesta', style: TextStyle(color: textColor, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.alimento.nombre, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInputField('Cantidad (Gramos)', _tamanoRacionController, textColor, cardColor),
              const SizedBox(height: 16),
              _buildDropdownField('Tipo de comida', _tipoComida, _tiposComida, textColor, cardColor, (String? newValue) {
                if (newValue != null) {
                  setState(() => _tipoComida = newValue);
                }
              }),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNutritionCircle(_caloriasController, 'Cal', 'Calorías', accentColor, textColor),
                  _buildNutritionCircle(_carbohidratosController, 'g', 'Carbohidratos', accentColor, textColor),
                  _buildNutritionCircle(_grasaController, 'g', 'Grasa', accentColor, textColor),
                  _buildNutritionCircle(_proteinaController, 'g', 'Proteína', accentColor, textColor),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _onGuardarCambiosPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0))
                    : Text('Guardar Cambios', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, Color textColor, Color backgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor, fontSize: 16)),
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
            onChanged: (value) => _actualizarValoresNutricionales(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, Color textColor, Color backgroundColor, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor, fontSize: 16)),
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

  Widget _buildNutritionCircle(TextEditingController controller, String unit, String label, Color accentColor, Color textColor) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.18,
          height: size.width * 0.18,
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
                  width: size.width * 0.08,
                  child: TextField(
                    controller: controller,
                    enabled: false,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: textColor,
                      fontSize: size.width * 0.035,
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
                    fontSize: size.width * 0.03,
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
            fontSize: size.width * 0.03,
          ),
        ),
      ],
    );
  }
}
