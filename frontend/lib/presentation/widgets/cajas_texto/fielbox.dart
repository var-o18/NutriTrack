import 'package:flutter/material.dart';

class FieldBox extends StatelessWidget {
  final TextEditingController controller;

  const FieldBox({Key? key, required this.controller, required double top}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF5A99D6)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: Color(0xFF232323),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
