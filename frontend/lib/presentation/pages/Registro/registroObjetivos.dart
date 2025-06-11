import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/Registro/registroGenero.dart';
import 'package:nutritack/presentation/pages/Registro/resgistro2.dart';
import 'package:provider/provider.dart';

import '../../../data/registro_data.dart';

class RegistroObjetivos extends StatefulWidget {
  const RegistroObjetivos({super.key});

  @override
  State<RegistroObjetivos> createState() => _RegistroObjetivosState();
}

class _RegistroObjetivosState extends State<RegistroObjetivos> {
  final List<String> objetivos = [
    'Ganancia Muscular',
    'Ganancia Muscular Rapida',
    'Pérdida de Grasa',
    'Pérdida de Grasa Rapida',
    'Mantenimiento',
  ];

  int? seleccionadoIndex;

  @override
  Widget build(BuildContext context) {
    final objetivoSeleccionado = Provider.of<RegistroData>(context).datos.objetivoPersonal;

    if (objetivoSeleccionado != null) {
      seleccionadoIndex = objetivos.indexOf(objetivoSeleccionado);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Objetivos',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 30,
                    height: 4,
                    decoration: BoxDecoration(
                      color: index == 1
                          ? const Color(0xFF5A99D6)
                          : const Color(0xFFD3E3F1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              const Text(
                'Queremos saber cuales son tus objetivos',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Selecciona el objetivo más importante que quieres cumplir',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: objetivos.length,
                  itemBuilder: (context, index) {
                    final isSelected = seleccionadoIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            seleccionadoIndex = index;
                          });

                          final objetivoSeleccionado = objetivos[index];

                          Provider.of<RegistroData>(context, listen: false)
                              .actualizarRegistro(objetivo_personal: objetivoSeleccionado);

                          print('Objetivo guardado: $objetivoSeleccionado');
                        },
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: seleccionadoIndex == null || isSelected ? 1.0 : 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEFF4),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x26000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  objetivos[index],
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: isSelected ? const Color(0xFF5A99D6) : Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Registro2()),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCCE1F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (seleccionadoIndex != null) {
                          final objetivoSeleccionado = objetivos[seleccionadoIndex!];

                          Provider.of<RegistroData>(context, listen: false)
                              .actualizarRegistro(objetivo_personal: objetivoSeleccionado);

                          print('Objetivo guardado: $objetivoSeleccionado');

                          Navigator.pushNamed(context, '/registroGenero');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Por favor selecciona un objetivo")),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A99D6),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Siguiente',
                            style: TextStyle(
                              color: Color(0xFF232323),
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
