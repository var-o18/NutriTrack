import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/Registro/registro1.dart';
import 'package:nutritack/presentation/pages/Registro/registroObjetivos.dart';
import 'package:nutritack/data/registro_data.dart';
import 'package:provider/provider.dart';

class Registro2 extends StatefulWidget {
  const Registro2({super.key});

  @override
  State<Registro2> createState() => _Registro2State();
}

class _Registro2State extends State<Registro2> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
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
              const SizedBox(height: 10),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Bienvenido',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 30,
                    height: 4,
                    decoration: BoxDecoration(
                      color: index == 0 ? const Color(0xFF5A99D6) : const Color(0xFFD3E3F1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 50),
              const Text(
                'Hola, \nqueremos \nsaber \ncomo te \nllamas',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Nombre preferido',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF909090)),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Registro1()),
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
                        final nombre = _nombreController.text.trim();
                        if (nombre.isNotEmpty) {
                          Provider.of<RegistroData>(context, listen: false)
                              .actualizarRegistro(nombre: nombre);

                          print('Nombre guardado: $nombre');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistroObjetivos()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Por favor ingresa tu nombre")),
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
