import 'package:flutter/material.dart';

class AgregarAlimentoPage extends StatefulWidget {
  const AgregarAlimentoPage({super.key});

  @override
  State<AgregarAlimentoPage> createState() => _AgregarAlimentoPageState();
}

class _AgregarAlimentoPageState extends State<AgregarAlimentoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tamanoRacionController = TextEditingController(text: '100gr');
  final TextEditingController _numeroRacionesController = TextEditingController(text: '80');
  final TextEditingController _caloriasController = TextEditingController(text: '0');
  final TextEditingController _carbohidratosController = TextEditingController(text: '0');
  final TextEditingController _grasaController = TextEditingController(text: '0');
  final TextEditingController _proteinaController = TextEditingController(text: '0');
  String _tipoComida = 'Desayuno';
  final List<String> _tiposComida = ['Desayuno', 'Almuerzo', 'Cena', 'Aperitivos'];
  int _currentIndex = 0;

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Agregar Alimento', 
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
              // Nombre del alimento
              TextField(
                controller: _nombreController,
                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Pavo Lonchas',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
              Text(
                'Pavo',
                style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Campos de entrada
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

              // Círculos de información nutricional editables
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEditableNutritionCircle(_caloriasController, 'Cal', 'Calorías', accentColor, textColor),
                  _buildEditableNutritionCircle(_carbohidratosController, 'g', 'Carbohidratos', accentColor, textColor),
                  _buildEditableNutritionCircle(_grasaController, 'g', 'Grasa', accentColor, textColor),
                  _buildEditableNutritionCircle(_proteinaController, 'g', 'Proteína', accentColor, textColor),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
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
              icon: Container(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/anadiralimento.png', width: 24),
              ),
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
    bool isActive = index == _currentIndex;
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/$assetName',
            width: 24,
            color: isActive ? const Color(0xFF80C0FF) : Colors.grey,
          ),
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