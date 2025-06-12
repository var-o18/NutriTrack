import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Bienvenida2 extends StatefulWidget {
  const Bienvenida2({super.key});

  @override
  State<Bienvenida2> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<Bienvenida2> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  int currentPage = 0;

  // Modern color palette
  static const Color primaryColor = Color(0xFF5A99D6);
  static const Color backgroundColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFFFFFFF);

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
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Animated gradient background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        backgroundColor,
                        primaryColor.withOpacity(0.3),
                        backgroundColor,
                      ],
                      stops: [0.0, _pulseController.value, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Welcome text with modern style
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_slideAnimation.value),
                      child: Column(
                        children: [
                          Text(
                            'Te damos la bienvenida a',
                            style: TextStyle(
                              color: textColor.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'NutriTrack',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Modern carousel with glass effect
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_slideAnimation.value * (index - currentPage), 0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image container with glass effect
                                  Container(
                                    height: 400,
                                    child: Image.asset(
                                      pages[index]['image']!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Modern text style
                                  Text(
                                    pages[index]['text']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      height: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: primaryColor.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Modern page indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: currentPage == index ? 30 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentPage == index
                              ? primaryColor
                              : primaryColor.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                // Modern registration button with animation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + (_pulseController.value * 0.03),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor.withOpacity(0.8),
                                primaryColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registro1');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'REGÍSTRATE GRATIS',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: textColor.withOpacity(0.9),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Login text button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'INICIA SESIÓN',
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
