import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color textColor = const Color(0xFFFFFFFF);
    final Color valueColor = const Color(0xFF5A99D6);

    Widget buildProfileItem(String title, String value, {Widget? trailing}) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: textColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          minLeadingWidth: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
          trailing: trailing ?? Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
    }

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
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'Información personal',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildProfileItem('Nombre de usuario', '28sgnybvs8'),
                buildProfileItem(
                  'Foto de perfil',
                  '',
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: valueColor,
                    child: Icon(Icons.person, color: textColor, size: 14),
                  ),
                ),
                buildProfileItem('Estatura', '180 cm'),
                buildProfileItem('Sexo', 'Femenino'),
                buildProfileItem('Fecha de nacimiento', '9 jun 2007'),
                buildProfileItem('Ubicación', 'Albania'),
                buildProfileItem('Código postal', '11111'),
                buildProfileItem('Zona horaria', 'hora de Europa central (Madrid)'),
                buildProfileItem('Dirección de email', 'ejemplo@correo.com'),
                buildProfileItem('Unidades', 'kg, cm, cal, km, ml'),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: textColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    minLeadingWidth: 0,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    title: Text(
                      'Objetivos',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Actualiza tus objetivos de peso, nutrición y preparación física.',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
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