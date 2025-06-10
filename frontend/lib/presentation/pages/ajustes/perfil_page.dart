import 'package:flutter/material.dart';
import '../../../data/services/login_service.dart';
import '../../../data/models/registro_model.dart';
import 'dart:convert';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  RegistroModel? _usuario;
  bool _isLoading = true;
  int? editingIndex;
  TextEditingController editingController = TextEditingController();

  // Opciones para los dropdowns
  final List<String> objetivos = [
    'Ganancia Muscular',
    'Ganancia Muscular Rapida',
    'Pérdida de Grasa',
    'Pérdida de Grasa Rapida',
    'Mantenimiento',
  ];
  final List<String> actividades = [
    'Sedentario',
    'Ligero',
    'Moderado',
    'Activo',
    'Muy Activo',
  ];

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final usuario = await getDatosUsuario();
    print('Usuario recibido: $usuario');
    print('Usuario JSON: ${jsonEncode(usuario)}');
    // Si usuario es un modelo, puedes imprimir los campos relevantes:
    print('Objetivo Personal: ${usuario?.objetivoPersonal}');
    setState(() {
      _usuario = usuario;
      _isLoading = false;
    });
  }

  void _editarCampo(String key, String label, String? valorActual) async {
    final controller = TextEditingController(text: valorActual ?? '');
    final nuevoValor = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Future.microtask(() => Navigator.pop(context));
            },
            child: const Text('Cancelar')
          ),
          TextButton(
            onPressed: () {
              Future.microtask(() => Navigator.pop(context, controller.text));
            },
            child: const Text('Guardar')
          ),
        ],
      ),
    );
    if (nuevoValor != null) {
      setState(() {
        switch (key) {
          case 'Nombre':
            _usuario!.nombre = nuevoValor;
            break;
          case 'Apellidos':
            _usuario!.apellidos = nuevoValor;
            break;
          case 'Sexo':
            _usuario!.sexo = nuevoValor;
            break;
          case 'Edad':
            _usuario!.edad = double.tryParse(nuevoValor)?.toInt();
            break;
          case 'Peso':
            _usuario!.peso = double.tryParse(nuevoValor);
            break;
          case 'Altura':
            _usuario!.altura = double.tryParse(nuevoValor);
            break;
          case 'Correo':
            _usuario!.correo = nuevoValor;
            break;
          case 'Objetivo Personal':
            _usuario!.objetivoPersonal = nuevoValor;
            break;
          case 'Nivel Actividad Física':
            _usuario!.nivelActividadFisica = nuevoValor;
            break;
          case 'Calorías Diarias':
            _usuario!.caloriasDiarias = int.tryParse(nuevoValor);
            break;
        }
      });
      // Aquí puedes llamar a una función para guardar los cambios en el backend si lo deseas
    }
  }

  void _guardarEdicion(String key, String nuevoValor, int index) async {
    Map<String, dynamic> patchData = {};
    switch (key) {
      case 'Nombre':
        patchData['nombre'] = nuevoValor;
        break;
      case 'Apellidos':
        patchData['apellidos'] = nuevoValor;
        break;
      case 'Sexo':
        patchData['sexo'] = nuevoValor;
        break;
      case 'Edad':
        patchData['edad'] = double.tryParse(nuevoValor)?.toInt();
        break;
      case 'Peso':
        patchData['peso'] = double.tryParse(nuevoValor);
        break;
      case 'Altura':
        patchData['altura'] = double.tryParse(nuevoValor);
        break;
      case 'Correo':
        patchData['correo'] = nuevoValor;
        break;
      case 'Objetivo Personal':
        patchData['objetivoPersonal'] = nuevoValor;
        break;
      case 'Nivel Actividad Física':
        patchData['nivelActividadFisica'] = nuevoValor;
        break;
      case 'Calorías Diarias':
        patchData['caloriasDiarias'] = int.tryParse(nuevoValor);
        break;
    }
    if (patchData.isEmpty) {
      setState(() {
        editingIndex = null;
      });
      return;
    }
    final success = await patchUsuario(patchData);
    if (success) {
      setState(() {
        switch (key) {
          case 'Nombre':
            _usuario!.nombre = nuevoValor;
            break;
          case 'Apellidos':
            _usuario!.apellidos = nuevoValor;
            break;
          case 'Sexo':
            _usuario!.sexo = nuevoValor;
            break;
          case 'Edad':
            _usuario!.edad = double.tryParse(nuevoValor)?.toInt();
            break;
          case 'Peso':
            _usuario!.peso = double.tryParse(nuevoValor);
            break;
          case 'Altura':
            _usuario!.altura = double.tryParse(nuevoValor);
            break;
          case 'Correo':
            _usuario!.correo = nuevoValor;
            break;
          case 'Objetivo Personal':
            _usuario!.objetivoPersonal = nuevoValor;
            break;
          case 'Nivel Actividad Física':
            _usuario!.nivelActividadFisica = nuevoValor;
            break;
          case 'Calorías Diarias':
            _usuario!.caloriasDiarias = int.tryParse(nuevoValor);
            break;
        }
        editingIndex = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el usuario en el servidor.')),
      );
    }
  }

  void _editarCarrusel(String key, int index) async {
    if (_usuario == null) return;
    dynamic valorActual;
    List<dynamic> valores = [];
    String unidad = '';
    if (key == 'Edad') {
      valorActual = _usuario!.edad?.toDouble() ?? 18.0;
      valores = List.generate(91, (i) => (i + 16).toDouble());
      unidad = 'años';
    } else if (key == 'Peso') {
      valorActual = _usuario!.peso ?? 60.0;
      valores = List.generate(361, (i) => 20.0 + i * 0.5); // 20.0kg a 200.0kg
      unidad = 'kg';
    } else if (key == 'Altura') {
      valorActual = _usuario!.altura ?? 1.60;
      valores = List.generate(121, (i) => (1.00 + i * 0.01)); // 1.00m a 2.20m
      unidad = 'm';
    }
    int selectedIndex;
    if (key == 'Peso') {
      selectedIndex = valores.indexWhere((v) => v.toStringAsFixed(1) == valorActual.toStringAsFixed(1));
    } else if (key == 'Altura') {
      selectedIndex = valores.indexWhere((v) => v.toStringAsFixed(2) == valorActual.toStringAsFixed(2));
    } else {
      selectedIndex = valores.indexOf(valorActual);
    }
    if (selectedIndex == -1) selectedIndex = 0;
    int tempIndex = selectedIndex;

    final Color modalBg = const Color(0xFF34495E); // Fondo oscuro
    final Color accentColor = const Color(0xFF5A99D6); // Azul para el número seleccionado
    final Color buttonColor = const Color(0xFFFFB74D); // Naranjo para el botón

    final result = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: modalBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Selecciona $key',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    controller: FixedExtentScrollController(initialItem: tempIndex),
                    onSelectedItemChanged: (i) {
                      setModalState(() {
                        tempIndex = i;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: valores.length,
                      builder: (context, i) {
                        final isSelected = i == tempIndex;
                        return Center(
                          child: Text(
                            key == 'Altura'
                                ? '${valores[i].toStringAsFixed(2)} $unidad'
                                : key == 'Peso'
                                    ? '${valores[i].toStringAsFixed(1)} $unidad'
                                    : '${valores[i].toStringAsFixed(0)} $unidad',
                            style: TextStyle(
                              fontSize: isSelected ? 24 : 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Future.microtask(() => Navigator.pop(context, valores[tempIndex]));
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(180, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      _guardarEdicion(key, result.toString(), index);
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$key actualizado correctamente.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color accentColor = const Color(0xFF5A99D6);
    final Color textColor = const Color(0xFFFFFFFF);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_usuario == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: Text('No se pudo cargar el usuario')),
      );
    }

    List<Map<String, dynamic>> profileItems = [
      {
        'title': 'Información personal',
        'isHeader': true,
      },
      {
        'title': 'Nombre',
        'value': _usuario!.nombre ?? '',
      },
      {
        'title': 'Apellidos',
        'value': _usuario!.apellidos ?? '',
      },
      {
        'title': 'Foto de perfil',
        'hasAvatar': true,
      },
      {
        'title': 'Sexo',
        'value': _usuario!.sexo ?? '',
      },
      {
        'title': 'Edad',
        'value': _usuario!.edad?.toString() ?? '',
      },
      {
        'title': 'Peso',
        'value': _usuario!.peso?.toStringAsFixed(1) ?? '',
      },
      {
        'title': 'Altura',
        'value': _usuario!.altura?.toStringAsFixed(2) ?? '',
      },
      {
        'title': 'Correo',
        'value': _usuario!.correo ?? '',
      },
      {
        'title': 'Objetivo Personal',
        'value': _usuario!.objetivoPersonal ?? '',
      },
      {
        'title': 'Nivel Actividad Física',
        'value': _usuario!.nivelActividadFisica ?? '',
      },
      {
        'title': 'Calorías Diarias',
        'value': _usuario!.caloriasDiarias?.toString() ?? '',
      },
    ];

    // Eliminar 'Foto de perfil' y 'Calorías Diarias' del formulario
    final filteredProfileItems = profileItems.where((item) =>
      item['title'] != 'Foto de perfil' && item['title'] != 'Calorías Diarias'
    ).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _usuario?.nombre ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Calorías diarias', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text('${_usuario?.caloriasDiarias ?? 0}', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                children: [
                  Text('Restantes', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text('${_usuario?.caloriasRestantes ?? 0}', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...filteredProfileItems.map((item) {
            if (item['isHeader'] == true) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8, left: 8),
                child: Text(
                  item['title'],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            bool isEditing = editingIndex == filteredProfileItems.indexOf(item);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: isEditing
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: editingController,
                              autofocus: true,
                              style: TextStyle(color: textColor, fontSize: 16),
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: item['title'],
                                labelStyle: TextStyle(color: Colors.white70),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              _guardarEdicion(item['title'], editingController.text, filteredProfileItems.indexOf(item));
                            },
                          ),
                        ],
                      )
                    : Text(
                        item['title'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                trailing: isEditing && item['title'] == 'Objetivo Personal'
                    ? SizedBox(
                        width: 160,
                        child: DropdownButton<String>(
                          value: objetivos.contains(_usuario!.objetivoPersonal) ? _usuario!.objetivoPersonal : objetivos.first,
                          dropdownColor: const Color(0xFF34495E),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          isExpanded: true,
                          items: objetivos.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _guardarEdicion(item['title'], value, filteredProfileItems.indexOf(item));
                            }
                          },
                        ),
                      )
                    : isEditing && item['title'] == 'Nivel Actividad Física'
                        ? SizedBox(
                            width: 140,
                            child: DropdownButton<String>(
                              value: actividades.contains(_usuario!.nivelActividadFisica) ? _usuario!.nivelActividadFisica : actividades.first,
                              dropdownColor: const Color(0xFF34495E),
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                              isExpanded: true,
                              items: actividades.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _guardarEdicion(item['title'], value, filteredProfileItems.indexOf(item));
                                }
                              },
                            ),
                          )
                        : (item['title'] == 'Edad' || item['title'] == 'Peso' || item['title'] == 'Altura')
                            ? GestureDetector(
                                onTap: () => _editarCarrusel(item['title'], filteredProfileItems.indexOf(item)),
                                child: Text(
                                  item['value'] ?? '',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              )
                            : isEditing
                                ? null
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        editingIndex = filteredProfileItems.indexOf(item);
                                        editingController.text = item['value'] ?? '';
                                      });
                                    },
                                    child: Text(
                                      item['value'] ?? '',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                onTap: null,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
} 