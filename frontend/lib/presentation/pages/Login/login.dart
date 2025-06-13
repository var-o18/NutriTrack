import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../data/services/login_service.dart';
import '../PantallaPrincipal/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  static const Color primaryColor = Color(0xFF5A99D6);
  static const Color backgroundColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$').hasMatch(email.trim());
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El correo electrónico no es válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 8 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final loginExitoso = await loginUsuario(email, password);

    if (loginExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales incorrectas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    backgroundColor,
                    primaryColor.withOpacity(0.3),
                    backgroundColor,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Back button and title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.pop(context, 'bienvenida2'),
                      ),
                      const Expanded(
                        child: Text(
                          'Iniciar Sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Logo
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: textColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/image.png',
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Login form
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: TextField(
                                controller: _emailController,
                                style: const TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: textColor.withOpacity(0.9)),
                                  hintText: 'nutritrack@gmail.com',
                                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: primaryColor.withOpacity(0.1),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.email_outlined, color: textColor.withOpacity(0.9)),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  labelStyle: TextStyle(color: textColor.withOpacity(0.9)),
                                  hintText: 'mínimo 8 caracteres',
                                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: primaryColor.withOpacity(0.1),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.lock_outline, color: textColor.withOpacity(0.9)),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.8),
                                      primaryColor,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Social login buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/logogoogle.png',
                                  height: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/logoappleblanco.png',
                                  height: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Forgot password
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '¿Olvidaste la contraseña?',
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
