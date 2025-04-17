import 'package:flutter/material.dart';

Widget botonesBlancosRegistro({
  required String iconAsset,
  required String label,
  required double iconWidth,
  required double iconHeight,
}) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color(0xD9D9D9),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconAsset,
          width: iconWidth,
          height: iconHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        // Texto
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    ),
  );
}