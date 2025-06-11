import 'package:flutter/material.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  // Estado para cada toggle
  bool recibirMensajes = true;
  bool recibirSolicitudes = true;
  bool registroEjercicio = true;
  bool alcanceRacha = true;
  bool objetivoPasos = true;
  bool noRecibirNotificaciones = false;

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
          'Ajustes',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: cardColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: textColor),
                      children: [
                        const TextSpan(
                          text: 'Actualmente, las notificaciones de MyFitnessPal están desactivadas. Para recibir notificaciones, ve a ',
                        ),
                        TextSpan(
                          text: 'Ajustes',
                          style: TextStyle(color: Colors.blue[300]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enviarme una notificación push cuando',
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          _buildNotificationToggle(
            'Reciba un mensaje nuevo',
            recibirMensajes,
            (value) => setState(() => recibirMensajes = value),
            cardColor,
            textColor,
          ),
          _buildNotificationToggle(
            'Reciba una solicitud de amistad',
            recibirSolicitudes,
            (value) => setState(() => recibirSolicitudes = value),
            cardColor,
            textColor,
          ),
          _buildNotificationToggle(
            'Uno de mis amigos registre un ejercicio',
            registroEjercicio,
            (value) => setState(() => registroEjercicio = value),
            cardColor,
            textColor,
          ),
          _buildNotificationToggle(
            'Uno de mis amigos alcance una racha de acceso',
            alcanceRacha,
            (value) => setState(() => alcanceRacha = value),
            cardColor,
            textColor,
          ),
          _buildNotificationToggle(
            'Alcance mi objetivo de pasos',
            objetivoPasos,
            (value) => setState(() => objetivoPasos = value),
            cardColor,
            textColor,
          ),
          _buildNotificationToggle(
            'No recibir notificaciones entre',
            noRecibirNotificaciones,
            (value) => setState(() => noRecibirNotificaciones = value),
            cardColor,
            textColor,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Si desactivas las notificaciones automáticas, dejarás de ver estos mensajes en la pantalla bloqueada. No obstante, seguirás recibiendo las notificaciones dentro de la aplicación.',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    Color cardColor,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF5A99D6),
        ),
      ),
    );
  }
}