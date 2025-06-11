import 'package:flutter/material.dart';

void showQuickActions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code_scanner, color: Colors.blue),
              title: const Text('Escaneo rápido', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/lectorCodigoBarras');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.green),
              title: const Text('Agregar comida', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/agregarComida');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.orange),
              title: const Text('Agregar ejercicio', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/agregarEjercicio');
              },
            ),
          ],
        ),
      );
    },
  );
} 