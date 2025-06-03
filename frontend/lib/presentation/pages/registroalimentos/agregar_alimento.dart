import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para input formatters
import 'package:nutritack/data/models/ingesta_model.dart';
import 'package:nutritack/data/services/ingesta_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/alimneto_model.dart';
import '../../../data/services/alimentos_service.dart'; // Importar el servicio

class AgregarAlimentoPage extends StatefulWidget {
  const AgregarAlimentoPage({super.key});

  @override
  State<AgregarAlimentoPage> createState() => _AgregarAlimentoPageState();
}

class _AgregarAlimentoPageState extends State<AgregarAlimentoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tamanoRacionController = TextEditingController(text: '100');
  late TextEditingController _numeroRacionesController; // Declarado aquí
  final TextEditingController _caloriasController = TextEditingController();
  final TextEditingController _carbohidratosController = TextEditingController();
  final TextEditingController _grasaController = TextEditingController();
  final TextEditingController _proteinaController = TextEditingController();


  String? _selectedTipoIngestaParaRegistro;
  final List<String> _tiposIngestaDisponibles = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];

  final AlimentoService _alimentoService = AlimentoService();
  final IngestaService _ingestaService = IngestaService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _numeroRacionesController = TextEditingController(text: '80');
  }

  Future<void> _guardarNuevoAlimento() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final nuevoAlimentoParaCrear = Alimento(
        nombre: _nombreController.text,
        calorias: double.tryParse(_caloriasController.text) ?? 0.0,
        proteinas: double.tryParse(_proteinaController.text) ?? 0.0,
        carbohidratos: double.tryParse(_carbohidratosController.text) ?? 0.0,
        grasas: double.tryParse(_grasaController.text) ?? 0.0,
      );

      Alimento? alimentoCreado = await _alimentoService.crearAlimento(nuevoAlimentoParaCrear);

      if (!mounted) return;

      if (alimentoCreado != null && alimentoCreado.id != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alimento "${alimentoCreado.nombre}" guardado con ID: ${alimentoCreado.id}.')),
        );

        if (_selectedTipoIngestaParaRegistro != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final usuarioId = prefs.getInt('jwt_id');

          if (usuarioId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Usuario no autenticado para registrar ingesta.')),
            );
            setState(() => _isSaving = false);
            Navigator.pop(context, true);
            return;
          }
          
          final now = DateTime.now();
          final fecha = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
          final hora = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

          final nuevaIngesta = Ingesta(
            usuarioId: usuarioId,
            alimentoId: alimentoCreado.id!,
            cantidad: 1,
            fechaConsumo: fecha,
            horaConsumo: hora,
            tipoIngesta: _selectedTipoIngestaParaRegistro!,
          );

          bool ingestaRegistrada = await _ingestaService.registrarIngesta(nuevaIngesta);
          if (ingestaRegistrada) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Además, "${alimentoCreado.nombre}" ha sido registrado como $_selectedTipoIngestaParaRegistro.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Alimento creado, pero falló el registro de la ingesta para "${alimentoCreado.nombre}".')),
            );
          }
        }
        Navigator.pop(context, true);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el alimento. Inténtalo de nuevo.')),
        );
      }
      if (mounted) {
         setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tamanoRacionController.dispose();
    _numeroRacionesController.dispose();
    _caloriasController.dispose();
    _carbohidratosController.dispose();
    _grasaController.dispose();
    _proteinaController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFieldLabel(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLabeledTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Color textColor,
    required InputDecoration inputDecoration,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label, textColor),
        TextFormField(
          controller: controller,
          style: TextStyle(color: textColor, fontSize: 18),
          decoration: inputDecoration.copyWith(hintText: hintText),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color fieldBackgroundColor = const Color(0xFF2A2A2A);
    final Color accentColor = const Color(0xFF5A99D6);
    final Color textColor = Colors.white;
    final Color hintColor = textColor.withOpacity(0.5);

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: fieldBackgroundColor,
      hintStyle: TextStyle(color: hintColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: accentColor, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context, null),
        ),
        title: Text('Agregar Nuevo Alimento', 
          style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSectionTitle('Nombre del alimento', textColor),
              _buildLabeledTextFormField(
                controller: _nombreController,
                label: 'Nombre del alimento',
                hintText: 'Ej: Manzana, Pechuga de pollo',
                textColor: textColor,
                inputDecoration: inputDecoration,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre.';
                  }
                  return null;
                },
              ),
              
              _buildLabeledTextFormField(
                controller: _tamanoRacionController,
                label: 'Tamaño de la ración (g/ml)',
                hintText: 'Ej: 100',
                textColor: textColor,
                inputDecoration: inputDecoration,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                    return 'Número inválido.';
                  }
                  return null; // Opcional
                },
              ),

              _buildLabeledTextFormField(
                controller: _numeroRacionesController,
                label: 'Número de raciones',
                hintText: 'Ej: 1',
                textColor: textColor,
                inputDecoration: inputDecoration,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                 validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Número inválido.';
                  }
                  return null; // Opcional
                },
              ),
              
              _buildFieldLabel('Tipo de comida (Opcional)', textColor),
              DropdownButtonFormField<String>(
                value: _selectedTipoIngestaParaRegistro,
                hint: Text('Seleccionar...', style: TextStyle(color: hintColor)),
                dropdownColor: fieldBackgroundColor,
                style: TextStyle(color: textColor, fontSize: 18),
                decoration: inputDecoration,
                items: _tiposIngestaDisponibles.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTipoIngestaParaRegistro = newValue;
                  });
                },
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEditableNutritionCircle(
                    controller: _caloriasController,
                    unit: 'Cal',
                    label: 'Calorías',
                    accentColor: accentColor,
                    textColor: textColor,
                  ),
                  _buildEditableNutritionCircle(
                    controller: _proteinaController,
                    unit: 'g',
                    label: 'Proteínas',
                    accentColor: accentColor,
                    textColor: textColor,
                  ),
                  _buildEditableNutritionCircle(
                    controller: _carbohidratosController,
                    unit: 'g',
                    label: 'Carbohidratos',
                    accentColor: accentColor,
                    textColor: textColor,
                  ),
                  _buildEditableNutritionCircle(
                    controller: _grasaController,
                    unit: 'g',
                    label: 'Grasas',
                    accentColor: accentColor,
                    textColor: textColor,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              if (_isSaving)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _guardarNuevoAlimento,
                    child: const Text('Agregar Alimento'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableNutritionCircle({
    required TextEditingController controller,
    required String unit,
    required String label,
    required Color accentColor,
    required Color textColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 35,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.end,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\\d*\\.?\\d*')),
                    ],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero, 
                      isDense: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
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
} 