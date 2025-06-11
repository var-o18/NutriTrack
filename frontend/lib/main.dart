import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/registro_data.dart';
import 'package:nutritack/routes/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistroData()),
      ],
      child: const MyApp(),
    ),
  );
}