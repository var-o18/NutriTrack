import 'package:flutter/material.dart';

class AjustesDiarioPage extends StatefulWidget {
  const AjustesDiarioPage({super.key});

  @override
  State<AjustesDiarioPage> createState() => _AjustesDiarioPageState();
}

class _AjustesDiarioPageState extends State<AjustesDiarioPage> {
  bool mostrarComidas = true;
  bool utilizarAdiciones = false;
  bool mostrarDatosAlimentos = true;
  bool mostrarTarjetaAgua = true;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color textColor = const Color(0xFFFFFFFF);
    final Color switchColor = const Color(0xFF5A99D6);

    Widget buildPremiumOption(String title, String subtitle) {
      return Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              Icons.workspace_premium,
              color: Color(0xFFFFD700),
            ),
          ),
          Divider(
            color: textColor.withOpacity(0.1),
            height: 1,
          ),
        ],
      );
    }

    Widget buildSwitchOption(String title, bool value, Function(bool) onChanged) {
      return Column(
        children: [
          SwitchListTile(
            title: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            value: value,
            onChanged: onChanged,
            activeColor: switchColor,
            activeTrackColor: switchColor.withOpacity(0.5),
          ),
          Divider(
            color: textColor.withOpacity(0.1),
            height: 1,
          ),
        ],
      );
    }

    Widget buildNavigationOption(String title) {
      return Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: textColor,
            ),
            onTap: () {
            },
          ),
          Divider(
            color: textColor.withOpacity(0.1),
            height: 1,
          ),
        ],
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
          'Ajustes del diario',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                buildPremiumOption(
                  'Mostrar carbohidratos, proteínas y grasa por comida',
                  'Ver carbohidratos, proteínas y grasa por gramo o porcentaje.',
                ),
                buildSwitchOption(
                  'Mostrar todas las comidas en las pestañas del diario',
                  mostrarComidas,
                  (value) => setState(() => mostrarComidas = value),
                ),
                buildSwitchOption(
                  'Utilizar adiciones múltiples por defecto',
                  utilizarAdiciones,
                  (value) => setState(() => utilizarAdiciones = value),
                ),
                buildSwitchOption(
                  'Mostrar datos de los alimentos del diario',
                  mostrarDatosAlimentos,
                  (value) => setState(() => mostrarDatosAlimentos = value),
                ),
                buildSwitchOption(
                  'Mostrar tarjeta de agua en diario',
                  mostrarTarjetaAgua,
                  (value) => setState(() => mostrarTarjetaAgua = value),
                ),
                buildNavigationOption('Pestaña de búsqueda predeterminada'),
                buildNavigationOption('Uso compartido del diario'),
                buildNavigationOption('Personalizar nombres de comidas'),
                buildNavigationOption('Personalizar panel de nutrientes'),
                buildPremiumOption(
                  'Mostrar horas de comida',
                  'Conoce cómo afecta cuándo comes a tu energía, tus rutinas y mucho más.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 