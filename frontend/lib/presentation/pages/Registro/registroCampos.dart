import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/registro_data.dart';
import '../../../data/services/registro_service.dart';
import 'package:nutritack/presentation/pages/Registro/registroAlergenos.dart';
import 'package:nutritack/presentation/pages/PantallaPrincipal/dashboard.dart';

class RegistroCampos extends StatefulWidget {
  const RegistroCampos({Key? key}) : super(key: key);

  @override
  State<RegistroCampos> createState() => _RegistroCamposState();
}

class _RegistroCamposState extends State<RegistroCampos> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final registroModel = Provider.of<RegistroData>(context, listen: false).datos;

    nombreController.text = registroModel.nombre ?? '';
    apellidosController.text = registroModel.apellidos ?? '';
    correoController.text = registroModel.correo ?? '';
    contrasenaController.text = registroModel.contrasena ?? '';
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight,
            child: Stack(
              children: [
                // Back button
                Positioned(
                  top: screenHeight * 0.02,
                  left: screenWidth * 0.02,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroRestriccionesAlimentarias(),
                        ),
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
                ),

                // Logo
                Positioned(
                  top: screenHeight * 0.05,
                  left: (screenWidth * 0.9 - 200) / 2,
                  child: SizedBox(
                    width: 200,
                    height: 100,
                    child: Image.asset(
                      'assets/images/logonutritracknegro.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Title
                Positioned(
                  top: screenHeight * 0.18,
                  left: (screenWidth * 0.9 - 100) / 2,
                  child: const Text(
                    'Registro',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF232323),
                    ),
                  ),
                ),

                // Form Fields
                Positioned(
                  top: screenHeight * 0.25,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Apellidos', apellidosController),
                        const SizedBox(height: 20),
                        _buildTextField('Nombre', nombreController),
                        const SizedBox(height: 20),
                        _buildTextField('Correo', correoController),
                        const SizedBox(height: 20),
                        _buildTextField('Contraseña', contrasenaController, obscureText: true),
                      ],
                    ),
                  ),
                ),

                // Create account button
                Positioned(
                  bottom: screenHeight * 0.1,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A99D6),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      final registroData = Provider.of<RegistroData>(context, listen: false);
                      final registroModel = registroData.datos;
                      if (_formKey.currentState?.validate() ?? false) {
                        registroData.actualizarRegistro(
                          nombre: nombreController.text,
                          apellidos: apellidosController.text,
                          correo: correoController.text,
                          contrasena: contrasenaController.text,
                          sexo: registroModel.sexo,
                          edad: registroModel.edad,
                          peso: registroModel.peso,
                          altura: registroModel.altura,
                          objetivo_personal: registroModel.objetivo_personal,
                          nivel_actividad_fisica: registroModel.nivel_actividad_fisica,
                        );

                        print('--- DATOS REGISTRADOS ---');
                        print('Nombre: ${registroModel.nombre}');
                        print('Apellidos: ${registroModel.apellidos}');
                        print('Correo: ${registroModel.correo}');
                        print('Contraseña: ${registroModel.contrasena}');
                        print('Género: ${registroModel.sexo}');
                        print('Edad: ${registroModel.edad}');
                        print('Peso: ${registroModel.peso}');
                        print('Altura: ${registroModel.altura}');
                        print('Objetivos: ${registroModel.objetivo_personal}');
                        print('Actividad Física: ${registroModel.nivel_actividad_fisica}');

                        final response = await enviarRegistro(registroModel);
                        print('Respuesta: ${response}');
                        if (response.statusCode == 200 || response.statusCode == 201) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DashboardScreen()),
                          );
                        } else {
                          final errorMessage = response.body.isNotEmpty ? response.body : 'Error al registrar. Inténtalo de nuevo.';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF232323),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: Color(0xFF232323),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF5A99D6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            hintText: 'Ingresa tu $label',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Color(0xFF979797),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese un $label';
            }

            if (label == 'Apellidos' || label == 'Nombre') {
              final regex = RegExp(r'^[a-zA-Z\s]+$');
              if (!regex.hasMatch(value)) {
                return '$label no puede contener números ni caracteres especiales';
              }
            }

            if (label == 'Correo') {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Ingrese un correo válido';
              }
            }

            if (label == 'Contraseña') {
              if (value.length < 8) {
                return 'La contraseña debe tener al menos 8 caracteres';
              }
              final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=<>?{}\[\]-]).+$');
              if (!passwordRegex.hasMatch(value)) {
                return 'La contraseña debe tener una mayúscula, una minúscula, un número y un carácter especial';
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}
