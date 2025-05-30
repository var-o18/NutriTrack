import 'package:flutter/material.dart';
import 'lector_codigo_barras.dart';

class EscaneoRapidoPage extends StatefulWidget {
  const EscaneoRapidoPage({super.key});

  @override
  State<EscaneoRapidoPage> createState() => _EscaneoRapidoPageState();
}

class _EscaneoRapidoPageState extends State<EscaneoRapidoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tamanoRacionController = TextEditingController(text: '100gr');
  final TextEditingController _numeroRacionesController = TextEditingController(text: '80');
  final TextEditingController _caloriasController = TextEditingController(text: '0');
  final TextEditingController _carbohidratosController = TextEditingController(text: '0');
  final TextEditingController _grasaController = TextEditingController(text: '0');
  final TextEditingController _proteinaController = TextEditingController(text: '0');
  String _tipoComida = 'Desayuno';
  final List<String> _tiposComida = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];

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
                onPressed: () {
                  // Aquí iría la lógica para agregar el alimento
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
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
    _numeroRacionesController.dispose();
    _caloriasController.dispose();
    _carbohidratosController.dispose();
    _grasaController.dispose();
    _proteinaController.dispose();
    super.dispose();
  }
} 