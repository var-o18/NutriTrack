import 'package:flutter/material.dart';
import 'package:nutritack/presentation/pages/Registro/registroEdad.dart';
import 'package:nutritack/presentation/pages/Registro/registroAltura.dart';

class RegistroPeso extends StatefulWidget {
  const RegistroPeso({super.key});

  @override
  State<RegistroPeso> createState() => _RegistroPesoState();
}

class _RegistroPesoState extends State<RegistroPeso> {
  final List<int> pesos = List.generate(200, (index) => index + 30);
  int pesoSeleccionado = 60;
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: pesoSeleccionado - 10);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  'Peso',
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
              const SizedBox(height: 70),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/peso.png',
                  width: screenWidth * (100 / 390),
                  height: screenHeight * (100 / 844),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Cuánto pesas?',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Selecciona tu peso',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: scrollController,
                        itemExtent: 40,
                        physics: const FixedExtentScrollPhysics(),
                        perspective: 0.005,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            pesoSeleccionado = pesos[index];
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: pesos.length,
                          builder: (context, index) {
                            final isSelected = pesos[index] == pesoSeleccionado;
                            return Center(
                              child: Text(
                                '${pesos[index]}',
                                style: TextStyle(
                                  fontSize: isSelected ? 24 : 18,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Color(0xFF5A99D6) : Color(0xFFD3E3F1),
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Kg',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistroEdad()),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Registroaltura()),
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
