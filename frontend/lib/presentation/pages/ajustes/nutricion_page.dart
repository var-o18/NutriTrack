import 'package:flutter/material.dart';

class NutricionPage extends StatefulWidget {
  const NutricionPage({super.key});

  @override
  State<NutricionPage> createState() => _NutricionPageState();
}

class _NutricionPageState extends State<NutricionPage> {
  String? selectedOption = 'Jueves'; // Can be 'hace7' or a day name

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF5A99D6).withOpacity(0.3);
    final Color textColor = const Color(0xFFFFFFFF);

    final List<String> weekDays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
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
          'Ajustes de nutrición semanales',
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
              'La semana comienza:',
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
            child: ListTile(
              title: Text(
                'Hace 7 días',
                style: TextStyle(
                  color: selectedOption == 'hace7' ? Colors.blue[400] : textColor,
                  fontSize: 16,
                ),
              ),
              trailing: selectedOption == 'hace7' 
                ? Icon(Icons.check, color: Colors.blue[400])
                : null,
              onTap: () => setState(() => selectedOption = 'hace7'),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weekDays.length,
            itemBuilder: (context, index) {
              final String currentDay = weekDays[index];
              final bool isSelected = selectedOption == currentDay;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    currentDay,
                    style: TextStyle(
                      color: isSelected ? Colors.blue[400] : textColor,
                      fontSize: 16,
                    ),
                  ),
                  trailing: isSelected 
                    ? Icon(Icons.check, color: Colors.blue[400])
                    : null,
                  onTap: () => setState(() => selectedOption = currentDay),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 