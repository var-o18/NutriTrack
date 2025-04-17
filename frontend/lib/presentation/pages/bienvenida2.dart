import 'package:flutter/material.dart';

class Bienvenida2 extends StatefulWidget {
  const Bienvenida2({super.key});

  @override
  State<Bienvenida2> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<Bienvenida2> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/cuerdashombrebienvenidos.png',
      'text': '¡Las proteínas son la \n clave de tu bienestar!',
    },
    {
      'image': 'assets/images/chicabienvenidos.png',
      'text': '¡Siempre en forma!',
    },
    {
      'image': 'assets/images/portrobienvenidos.png',
      'text': 'No te pongas excusas\nempieza ya gratis',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Te damos la bienvenida a',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text.rich(
              TextSpan(
                text: 'Nutri',
                style: TextStyle(color: Color(0xFF5A99D6), fontSize: 24),
                children: [
                  TextSpan(
                    text: 'Track',
                    style: TextStyle(color: Color(0xFF5A99D6), fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: AssetImage(pages[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        pages[index]['text']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildIndicator(),
            const SizedBox(height: 20),
            // Botón REGÍSTRATE GRATIS
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registro1');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF5A99D6), width: 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'REGÍSTRATE GRATIS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'INICIA SESIÓN',
                style: TextStyle(
                  color: Color(0xFF5A99D6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? const Color(0xFF5A99D6)
                : Colors.grey.shade700,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
