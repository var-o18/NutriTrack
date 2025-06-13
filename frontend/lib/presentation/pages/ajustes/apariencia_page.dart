import 'package:flutter/material.dart';

class AparienciaPage extends StatefulWidget {
  const AparienciaPage({super.key});

  @override
  State<AparienciaPage> createState() => _AparienciaPageState();
}

class _AparienciaPageState extends State<AparienciaPage> {
  String selectedTheme = 'claro';

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color textColor = const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Apariencia de la aplicación',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Seleccionar tema',
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
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
                    title: Text(
                      'Predeterminado del sistema',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => setState(() => selectedTheme = 'sistema'),
                    trailing: selectedTheme == 'sistema'
                        ? Icon(Icons.check, color: Colors.blue[400])
                        : null,
                  ),
                ),
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
                    title: Text(
                      'Tema claro',
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => setState(() => selectedTheme = 'claro'),
                    trailing: selectedTheme == 'claro'
                        ? Icon(Icons.check, color: Colors.blue[400])
                        : null,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Tema oscuro',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => setState(() => selectedTheme = 'oscuro'),
                  trailing: selectedTheme == 'oscuro'
                      ? Icon(Icons.check, color: Colors.blue[400])
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 