import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color textColor = const Color(0xFFFFFFFF);

    List<Map<String, dynamic>> profileItems = [
      {
        'title': 'Información personal',
        'isHeader': true,
      },
      {
        'title': 'Nombre de usuario',
        'value': 'alvaro3019',
      },
      {
        'title': 'Foto de perfil',
        'hasAvatar': true,
      },
      {
        'title': 'Estatura',
        'value': '182 cm',
      },
      {
        'title': 'Sexo',
        'value': 'Masculino',
      },
      {
        'title': 'Fecha de nacimiento',
        'value': '22 oct 2005',
      },
      {
        'title': 'Ubicación',
        'value': 'España',
      },
      {
        'title': 'Código postal',
        'value': '11111',
      },
      {
        'title': 'Zona horaria',
        'value': 'hora de Europa central (Madrid)',
      },
      {
        'title': 'Dirección de email',
        'value': 'alvarorodriguez@gmail.com',
      },
      {
        'title': 'Unidades',
        'value': 'kg, cm, cal, km, ml',
      },
    ];

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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: profileItems.length,
        itemBuilder: (context, index) {
          final item = profileItems[index];
          
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

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                item['title'],
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              trailing: item['hasAvatar'] == true
                  ? const CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    )
                  : Text(
                      item['value'] ?? '',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
              onTap: () {
                // Aquí iría la lógica para editar cada campo
              },
            ),
          );
        },
      ),
    );
  }
} 