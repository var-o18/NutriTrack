import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/Registro/registroActividadFisica.dart';
import 'package:nutritack/presentation/pages/Registro/registroCampos.dart';
import 'package:provider/provider.dart';

import '../../../data/registro_data.dart';

class RegistroRestriccionesAlimentarias extends StatefulWidget {
  const RegistroRestriccionesAlimentarias({super.key});

  @override
  State<RegistroRestriccionesAlimentarias> createState() => _RegistroRestriccionesAlimentariasState();
}

class _RegistroRestriccionesAlimentariasState extends State<RegistroRestriccionesAlimentarias> {
  final List<String> restricciones = [
    'Gluten',
    'Crustaceos',
    'Huevos',
    'Pescado',
    'Cacahuetes',
  ];

  final Map<String, String> imagenesAlergenos = {
    'Gluten': 'assets/images/gluten.png',
    'Crustaceos': 'assets/images/crustaceos.png',
    'Huevos': 'assets/images/huevos.png',
    'Pescado': 'assets/images/pescado.png',
    'Cacahuetes': 'assets/images/cacahuetes.png',
  };

  late Set<int> seleccionadosAlergenos;

  @override
  void initState() {
    super.initState();

    final registro = Provider.of<RegistroData>(context, listen: false);
    //final alergenosGuardados = registro.datos.alergenos ?? [];

    seleccionadosAlergenos = {};

    for (int i = 0; i < restricciones.length; i++) {
      /*if (alergenosGuardados.contains(restricciones[i])) {
        seleccionadosAlergenos.add(i);
      }*/
    }
  }


  @override
  Widget build(BuildContext context) {
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
                  'Restricciones alimentarias',
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
                      color: index == 3
                          ? const Color(0xFF5A99D6)
                          : const Color(0xFFD3E3F1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              const Text(
                'Restricciones alimentarias',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Seleccione los alimentos a los que seas alergicos',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: restricciones.length,
                  itemBuilder: (context, index) {
                    final isSelected = seleccionadosAlergenos.contains(index);
                    final restriccion = restricciones[index];
                    final imagenPath = imagenesAlergenos[restriccion] ?? 'assets/images/gluten.png';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              seleccionadosAlergenos.remove(index);
                            } else {
                              seleccionadosAlergenos.add(index);
                            }
                          });
                        },
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: seleccionadosAlergenos.isEmpty || isSelected ? 1.0 : 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EAEE),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
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
                                Row(
                                  children: [
                                    Container(
                                      width: 23,
                                      height: 23,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(imagenPath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      restriccion,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: isSelected ? const Color(0xFF5A99D6) : Colors.grey,
                                ),
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
                        MaterialPageRoute(builder: (context) => const RegistroActividadFisica()),
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
                        final restriccionesSeleccionadas = seleccionadosAlergenos
                            .map((index) => restricciones[index])
                            .toList();

                        /*Provider.of<RegistroData>(context, listen: false)
                            .actualizarRegistro(alergenos: restriccionesSeleccionadas);*/

                        print('Objetivo guardado: $restriccionesSeleccionadas');


                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistroCampos()),
                        );
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